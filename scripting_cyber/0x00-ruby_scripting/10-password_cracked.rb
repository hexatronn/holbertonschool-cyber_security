#!/usr/bin/env ruby
require 'digest'

if ARGV.length != 2
  puts "Usage: #{File.basename(__FILE__)} HASHED_PASSWORD DICTIONARY_FILE"
  exit 1
end

target_hash = ARGV[0].downcase.strip
dictionary_file = ARGV[1]

unless File.exist?(dictionary_file)
  puts "Error: Dictionary file '#{dictionary_file}' not found."
  exit 1
end

found_password = nil

begin
  File.foreach(dictionary_file) do |line|
    word = line.strip
    next if word.empty?

    word_hash = Digest::SHA256.hexdigest(word)

    if word_hash == target_hash
      found_password = word
      break
    end
  end
rescue StandardError => e
  puts "An error occurred while reading the file: #{e.message}"
  exit 1
end

if found_password
  puts "Password found: #{found_password}"
else
  puts "Password not found in dictionary."
end
