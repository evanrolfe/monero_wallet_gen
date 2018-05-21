require 'zlib'
require 'digest/sha3'
require 'monero_wallet_gen/version'
require 'monero_wallet_gen/base58'
require 'monero_wallet_gen/ed25519'
require 'monero_wallet_gen/words'

module MoneroWalletGen
  NETBYTE_STANDARD = '12'
  NETBYTE_TESTNET = '35'

  def self.generate(testnet: false)
    hex = sc_reduce32(mn_random)
    generate_from_private_key(hex, testnet: testnet)
  end

  def self.generate_from_private_key(hex, testnet: false)
    mn = mn_encode(hex)
    priv_spend_key = hex
    priv_view_key = sc_reduce32(cn_fast_hash(hex))
    pub_spend_key = priv_key_to_pub(priv_spend_key)
    pub_view_key = priv_key_to_pub(priv_view_key)
    netbyte = testnet ? NETBYTE_TESTNET : NETBYTE_STANDARD
    address = get_public_address(netbyte, pub_spend_key, pub_view_key)

    {
      priv_spend_key: priv_spend_key,
      priv_view_key: priv_view_key,
      pub_spend_key: pub_spend_key,
      pub_view_key: pub_view_key,
      address: address,
      mnemonic: mn
    }
  end

  def self.little_endian(str)
    output = []
    (0..str.length).step(2) do |i|
      substr = str[i..i+1]
      output << substr
    end
    output.reverse.join
  end

  def self.hex_to_int(hex)
    le_hex = little_endian(hex)
    le_hex.to_i(16)
  end

  def self.int_to_hex(n)
    be_hex = n.to_s(16).rjust(64, '0')
    little_endian(be_hex)
  end

  # Takes a 32-byte integer and outputs the integer modulo q. Same code as above,
  # except skipping the 64→32 byte step.
  def self.sc_reduce32(hex)
    l = 2**252 + 27742317777372353535851937790883648493
    n = hex_to_int(hex)
    reduced = (n % l)
    int_to_hex(reduced)
  end

  def self.random_integer_digits(digits)
    digits.times.map{ rand(10) }.join.to_i
  end

  def self.mn_random
    # Generate array of random integers
    array = 8.times.map { random_integer_digits(10) }

    # Convert to 8-bit hex
    array.map do |n|
      ('0000000' + n.to_s(16))[-8..-1]
    end.join
  end

  def self.mn_encode(message)
    n = WORDS.length

    (0..message.length-1).step(8) do |i|
      if i == 0
        message = little_endian(message[i..i+7]) + message[i+8..-1]
      else
        message = message[0..i-1] + little_endian(message[i..i+7]) + message[i+8..-1]
      end
    end

    words = []
    limit = message.length / 8 - 1
    (0..limit).to_a.each do |i|
      word = message[8*i..8*i+7]
      x = word.to_i(16)
      w1 = (x % n)
      w2 = ((x / n).to_i + w1) % n
      w3 = (((x / n) / n).to_i + w2) % n

      words += [ WORDS[w1], WORDS[w2], WORDS[w3] ]
    end

    trimmed_words = words.map { |word| word[0..2] }.join
    checksum = Zlib.crc32(trimmed_words)
    checkword = words[checksum % words.length]
    words << checkword
    words.join(' ')
  end

  def self.hex_to_bin(hex)
    output = []
    (0..hex.length-1).step(2) do |i|
      substr = hex[i..i+1]
      output << substr.to_i(16)
    end
    output.pack('C*')
  end

  def self.cn_fast_hash(hex)
    bin = hex_to_bin(hex)
    Digest::SHA3.hexdigest(bin, 256)
  end

  def self.priv_key_to_pub(hex)
    point = Ed25519::scalarmultbase(hex_to_int(hex))
    Ed25519::encode_point(point).unpack('H*').first.to_s
  end

  def self.get_public_address(netbyte, pub_spend_key, pub_view_key, pid = '')
    pre_address = netbyte + pub_spend_key + pub_view_key
    hashed = cn_fast_hash(pre_address)
    hex_address = pre_address + hashed[0..7]
    Base58::encode(hex_address)
  end
end
