# (sort of) efficiently searches a memory dump for vxworks hashes, and prints
# workalike plaintext for every match found - cvk/2010-08-10

require 'vxworks_collide'

if ARGV.length < 2
  puts 'usage: mem_search.rb lookup.txt mem.dump'
  exit 1
end

lookup_file = ARGV.shift
input_file = ARGV.shift

load_hash_table lookup_file

memory_data = File.read(input_file)

# find all runs of text that are comprised of only hash characters
possible_hash_regions = memory_data.scan(%r([9QRSbcdeyz]{6,}))

# get all possible hash-size character subsets in the hashlike regions
possible_hashes = possible_hash_regions.collect do |region| 
  (6..10).collect do |length|
    region.bytes.each_cons(length).collect { |run_of_bytes| run_of_bytes.pack('C*') }
  end
end.flatten.uniq

puts 'found %d possible hashes' % [possible_hashes.length]
puts possible_hashes.inspect

# search
possible_hashes.each do |hash|
  if workalike = collide(hash)
    puts 'possible hash match: hash = %s / workalike = %s' % [hash.inspect, workalike.inspect]
  end
end
