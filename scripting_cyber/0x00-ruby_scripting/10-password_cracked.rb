require 'digest'

if ARGV.length != 2
  puts "Usage: 10-password_cracked.rb HASHED_PASSWORD DICTIONARY_FILE"
  exit
end

hash_to_crack = ARGV[0].downcase
dictionary_file = ARGV[1]

File.foreach(dictionary_file) do |line|
  word = line.chomp
  next if word.empty?
  if Digest::SHA256.hexdigest(word) == hash_to_crack
    puts "Password found: #{word}"
    exit
  end
end

puts "Password not found in dictionary."
