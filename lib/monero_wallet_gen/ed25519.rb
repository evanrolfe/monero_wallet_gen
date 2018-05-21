require 'digest/sha3'

# This is a port of the pure-python implementation of Ed25519
# http://ed25519.cr.yp.to/software.html

module MoneroWalletGen
  module Ed25519
    B = 256
    Q = 2**255 - 19
    L = 2**252 + 27742317777372353535851937790883648493

    def self.hash(str)
      Digest::SHA512.digest(str)
    end

    def self.expmod(base, exponent, modulus)
      return modulus == 1 ? 0 : begin
        result = 1
        base = base % modulus
        while exponent > 0
          result = result * base % modulus if exponent % 2 == 1
          exponent = exponent >> 1
          base = base * base % modulus
        end
      result
      end
    end

    def self.inverse(x)
      expmod(x,Q-2,Q)
    end

    def self.d
      -121665 * inverse(121666)
    end

    def self.i
      expmod(2,(Q-1)/4,Q)
    end

    def self.xrecover(y)
      xx = (y * y - 1) * inverse(d * y * y + 1)
      x = expmod(xx, (Q + 3) / 8, Q)
      if (x * x - xx) % Q != 0
        x = (x * i) % Q
      end
      if x % 2 != 0
        x = Q-x
      end
      x
    end

    def self.edwards_add(p, q)
      x1 = p[0]
      y1 = p[1]
      x2 = q[0]
      y2 = q[1]

      x3 = (x1*y2+x2*y1) * inverse(1+d*x1*x2*y1*y2)
      y3 = (y1*y2+x1*x2) * inverse(1-d*x1*x2*y1*y2)
      [x3 % Q,y3 % Q]
    end

    def self.base
      by = 4 * inverse(5)
      bx = xrecover(by)
      [bx % Q,by % Q]
    end

    def self.scalarmult(point, e)
      return [0,1] if e == 0

      q = scalarmult(point, e / 2)
      q = edwards_add(q,q)

      if (e & 1) == 1
        q = edwards_add(q,point)
      end
      q
    end

    def self.scalarmultbase(e)
      return [0,1] if e == 0

      q = scalarmult(base, e/2)
      q = edwards_add(q,q)

      if (e & 1) == 1
        q = edwards_add(q,base)
      end
      q
    end

    def self.ge_scalarmult(point, e)
      encode_point_hex(scalarmult(to_point(point), e))
    end

    def self.encode_point(p)
      x = p[0]
      y = p[1]
      bits = (0..254).to_a.map do |i|
        (y >> i) & 1
      end
      bits << (x & 1)

      output = []
      (0..31).to_a.each do |i|
        sub_bits = []
        (0..7).to_a.each do |j|
          sub_bits << (bits[i * 8 + j] << j)
        end
        output << sub_bits.sum
      end
      output.pack('C*')
    end

    def self.encode_point_hex(p)
      x = p[0]
      y = p[1]
      bits = (0..254).to_a.map do |i|
        (y >> i) & 1
      end
      bits << (x & 1)

      output = []
      (0..31).to_a.each do |i|
        sub_bits = []
        (0..7).to_a.each do |j|
          sub_bits << (bits[i * 8 + j] << j)
        end
        output << sub_bits.sum
      end
      output.map { |x| x.to_s(16).rjust(2, '0') }.join
    end

    def self.encode_int(y)
      #TODO
      #bits = [(y >> i) & 1 for i in range(b)]
      #return ''.join([chr(sum([bits[i * 8 + j] << j for j in range(8)])) for i in range(b/8)])
    end

    def self.bit(str,i)
      str[i / 8].ord >> (i % 8) & 1
    end


    def self.decode_point(str)
      y = (0..B-2).to_a.map do |i|
        2**i * bit(str,i)
      end.sum

      x = xrecover(y)

      if x & 1 != bit(str,B-1)
        x = Q - x
      end

      [x,y]
    end

    def self.to_point(hex)
      output = []
      (0..hex.length-1).step(2) do |i|
        substr = hex[i..i+1]
        output << substr.to_i(16)
      end
      bin = output.pack('C*')
      decode_point(bin)
    end

    def self.decode_int(str)
      (0..B).to_a.map do |i|
        2**i * bit(str,i)
      end.sum
    end
  end
end
