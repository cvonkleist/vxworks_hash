require 'vxworks_collide'

if ARGV.empty?
  puts 'usage: find_collision.rb lookup.txt RcQbRbzRyc'
  exit 1
end

load_hash_table ARGV.shift
puts collide(ARGV.shift)
