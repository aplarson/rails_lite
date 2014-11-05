def deep_merge(hash1, hash2)
  merged_hash = {}
  common_keys = hash1.keys.select { |key| hash2.keys.include?(key) }
  common_keys.each do |key|
    merged_hash[key] = deep_merge(hash1[key], hash2[key])
    hash1.delete(key)
    hash2.delete(key)
  end
  merged_hash.merge!(hash1).merge!(hash2)
end

# cases: if hashes do not share keys, merge!
#        if hashes do share keys, deep merge

    # user[address][street]=main&user[address][zip]=89436
    
hash1 = { 'user' => { 'address' => { 'street' => { 'name' => 'main', 'type' => 'st' } } } }
hash2 = { 'user' => { 'address' => { 'zip' => 89436 } } }
p deep_merge(hash1, hash2)    