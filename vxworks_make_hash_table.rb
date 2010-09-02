# turns checksum table (output of vxworks_collide.c) into hash table (input to vxworks_find_collision.rb)
#
# cvk/2010-08-09

require 'vxworks_collide'

if ARGV.length < 2
  puts 'usage: ruby vxworks_make_hash_table.rb sums.txt lookup.txt'
  exit 1
end

SUM_TABLE_FILENAME = ARGV.shift
OUTPUT_FILENAME = ARGV.shift

File.open(OUTPUT_FILENAME, 'w') do |output|
  File.readlines(SUM_TABLE_FILENAME).each do |line|
    sum, plaintext = line.chomp.split("\t")
    hash = sum_to_hash(sum.to_i)
    output.puts [hash, plaintext] * "\t"
  end
end
