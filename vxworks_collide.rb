# cvk/2010-08-09

def sum_to_hash(int)
  out = "%u" % ((int * 31695317) & 0xffffffff)
  out.bytes.each_with_index do |b, i|
    out[i] += '!'[0] if out[i] < '3'[0]
    out[i] += '/'[0] if out[i] < '7'[0]
    out[i] += 'B'[0] if out[i] < '9'[0]
  end
  out
end

def load_hash_table(filename)
  @found_hashes = {}
  File.readlines(filename).each do |line|
    hash, plaintext = line.chomp.split("\t")
    @found_hashes[hash] = plaintext
  end
  puts 'loaded %d hashes' % @found_hashes.length
  nil
end

def collide(hash)
  @found_hashes[hash]
end
