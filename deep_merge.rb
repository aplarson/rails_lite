def deep_merge(hash1, hash2)
  merged_hash = {}
  first_keys = hash1.keys
  second_keys = hash2.keys
  first_keys.each do |key|
    if !(second_keys.include?(key))
      merged_hash[key] = hash1[key]
    else
      merged_hash[key] = deep_merge(hash1[key], hash2[key])
    end
  end
  second_keys.each do |key|
    merged_hash[key] = hash2[key] unless merged_hash.keys.include?(key)
  end
  merged_hash
end

# cases: if hashes do not share keys, merge!
#        if hashes do share keys, deep merge

    # user[address][street]=main&user[address][zip]=89436
    
hash1 = { 'user' => { 'address' => { 'street' => 'main' } } }
hash2 = { 'user' => { 'address' => { 'zip' => 89436 } } }
p deep_merge(hash1, hash2)    