def deep_merge(hash1, hash2)
  merged_hash = {}
  common_keys = hash1.keys.select { |key| hash2.keys.include?(key) }
  common_keys.each do |key|
    if hash1[key].is_a?(Hash) && hash2[key].is_a?(Hash)
      merged_hash[key] = deep_merge(hash1[key], hash2[key])
    else
      merged_hash[key] = hash2[key]
    end
    hash1.delete(key)
    hash2.delete(key)
  end
  merged_hash.merge!(hash1).merge!(hash2)
end

# cases: if hashes do not share keys, merge!
#        if hashes do share keys, deep merge

# sample case: user[address][street]=main&user[address][zip]=89436
    
hash1 = { 'user' => { 'address' => { 'street' => { 'name' => 'main', 'type' => 'st' } } } }
hash2 = { 'user' => { 'address' => { 'zip' => 89436 } } }
puts deep_merge(hash1, hash2)    

hash1 = { 'user' => { 'address' => { 'street' => { 'name' => 'main', 'type' => 'st' } } } }
hash2 = { 'user' => { 'address' => { 'street' => 89436 } } }

puts deep_merge(hash1, hash2)