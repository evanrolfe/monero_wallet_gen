module MoneroWalletGen
  module Base58
    ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'.split('').map { |c| c.ord }
    B58BASE = 58
    UINT64MAX = 2**64
    ENCODED_BLOCK_SIZES = [0, 2, 3, 5, 6, 7, 9, 10, 11]
    FULL_BLOCK_SIZE = 8
    FULL_ENCODED_BLOCK_SIZE = 11

    def self.hex_to_bin(hex)
      raise ArgumentError, 'Hex string has invalid length!' if hex.length % 2 != 0

      (0..(hex.length / 2 - 1)).to_a.map do |i|
        hex[i*2..i*2+1].to_i(16)
      end
    end

    def self.bin_to_hex(bin)
      bin.map do |x|
        x.to_s(16).rjust(2, '0')
      end.join
    end

    def self.str_to_bin(str)
      str.split('').map { |c| c.ord }
    end

    def self.bin_to_str(bin)
      bin.map { |x| x.chr }.join
    end

    def self.uint8be_to_64(data)
      raise ArgumentError 'Invalid input length' if data.length < 1 || data.length > 8

      data.reduce(0) { |result, x| result = result << 8 | x }
    end

    def self.uint64_to_8be(x, size)
      result = size.times.map { '0' }

      raise ArgumentError 'Invalid input length' if size < 1 || size > 8

      (size-1).downto(0) do |i|
        result[i] = x % 2 ** 8
        x = x / 2 ** 8
      end
      result
    end

    def self.encode_block(data, buffer, index)
      num = uint8be_to_64(data)
      i = ENCODED_BLOCK_SIZES[data.length] - 1

      while(num > 0) do
        remainder = num % B58BASE
        num = num / B58BASE
        buffer[index+i] = ALPHABET[remainder];
        i -= 1
      end

      buffer
    end

    def self.encode(hex)
      data = hex_to_bin(hex)

      full_block_count = data.length / FULL_BLOCK_SIZE
      last_block_size = data.length % FULL_BLOCK_SIZE
      res_size = full_block_count * FULL_ENCODED_BLOCK_SIZE + ENCODED_BLOCK_SIZES[last_block_size]

      result = res_size.times.map { ALPHABET[0] }

      (0..full_block_count-1).to_a.each do |i|
        result = encode_block(
          data[(i*FULL_BLOCK_SIZE)..(i*FULL_BLOCK_SIZE+FULL_BLOCK_SIZE-1)], result, i * FULL_ENCODED_BLOCK_SIZE
        )
      end

      if last_block_size > 0
        res = encode_block(data[(full_block_count*FULL_BLOCK_SIZE)..(full_block_count*FULL_BLOCK_SIZE+last_block_size - 1)], result, full_block_count * FULL_ENCODED_BLOCK_SIZE)
      end

      bin_to_str(result)
    end
  end
end
