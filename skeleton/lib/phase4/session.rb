require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie_array = req.cookies.select do |cookie|
        cookie.name == '_rails_lite_app'
      end
      if cookie_array.empty?
        @val = {}
      else
        @val = {}
        @cookie = cookie_array[0]
        @val = JSON.parse(@cookie.value)
      end
    end

    def [](key)
      @val[key]
    end

    def []=(key, val)
      @val[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      new_cookie = WEBrick::Cookie.new('_rails_lite_app', @val.to_json)
      res.cookies << new_cookie
    end
  end
end
