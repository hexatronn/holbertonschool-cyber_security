#!/usr/bin/env ruby

class CaesarCipher
  def initialize(shift)
    @shift = shift
  end

  def encrypt(message)
    cipher(message, @shift)
  end

  def decrypt(message)
    cipher(message, -@shift)
  end

  private

  def cipher(message, shift)
    result = ""
    
    message.each_char do |char|
      if ('a'..'z').include?(char)
        base = 'a'.ord
        shifted = ((char.ord - base + shift) % 26) + base
        result += shifted.chr
      elsif ('A'..'Z').include?(char)
        base = 'A'.ord
        shifted = ((char.ord - base + shift) % 26) + base
        result += shifted.chr
      else
        result += char
      end
    end
    
    result
  end
end
