require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params

      if req.query_string
        parse_www_encoded_form(req.query_string).each do |key, value|
          @params[key] = value
        end
      end

      if req.body.to_s
        parse_www_encoded_form(req.body.to_s).each do |key, value|
          @params[key] = value
        end
      end
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
    # user[address][street]=main&user[address][zip][hello]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      non_nested = Hash[URI::decode_www_form(www_encoded_form)]
      result = {}
      non_nested.each do |keys, value|
        parsed_keys = parse_key(keys)
        inner_result = {}
        parsed_keys.reverse.each do |key|
          inner_result[key] = value
          value = {key => value}
        end



        if result[parsed_keys.first] && inner_result[parsed_keys.first]
          p result.keys
          p parsed_keys.first => inner_result[parsed_keys.first]
          p "hello"
          p result.merge(parsed_keys.first => inner_result[parsed_keys.first])
        else
          result[parsed_keys.first] = inner_result[parsed_keys.first]
        end
      end
      p 'hi'
      p result
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      regex = /\]\[|\[|\]/
      key.split(regex)
    end
  end
end
