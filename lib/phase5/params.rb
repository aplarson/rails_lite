require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @params = route_params
      parse_www_encoded_form(req.query_string) if req.query_string
      parse_www_encoded_form(req.body) if req.body
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      pairs = URI.decode_www_form(www_encoded_form)
      pairs.each do |pair|
        @params = deep_merge(
                    @params, 
                    generate_nested_hash(parse_key(pair[0]), pair[1])
                  )
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
    
    def generate_nested_hash(array, value)
      return { array[0] => value } if array.length == 1
      { array[0] => generate_nested_hash(array[1..-1], value) }
    end
    
    # breaks if both hashes have a key but one points to a non-hash object; this
    # should not matter in context
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
  end
end
