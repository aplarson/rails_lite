require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      if cookie
        @contents = JSON.parse(cookie.value)
      else
        @contents = { 'csrf_token' => SecureRandom.urlsafe_base64 }
      end
    end

    def [](key)
      @contents[key]
    end

    def []=(key, val)
      @contents[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @contents.to_json)
    end
  end
end
