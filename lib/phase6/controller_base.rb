require_relative '../phase5/controller_base'
require_relative 'csrf'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    include CSRFProtector
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send(name)
      render(name) unless @already_built_response
    end
    
    def flash
      @flash ||= Flash.new(@req)
    end
    
    def redirect_to(url)
      super(url)
      flash.store_session(@res)
    
    end

    def render_content(content, type)
      super(content, type)
      flash.store_session(@res)
    end
    
  end
  
  class Flash
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_flash' }
      if cookie
        @contents = JSON.parse(cookie.value)
        @contents.each do |key, arr|
          @contents[key] = [arr[0], arr[1] + 1]
        end
      else
        @contents = {}
      end
    end

    # grab only the value, not the counter
    def [](key)
      @contents[key][0] if @contents[key]
    end

    # set value and number of requests it has lived with
    def []=(key, val)
      @contents[key] = [val, 0]
    end
    
    def now(key, val)
      @contents[key] = [val, 1]
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      @contents.each do |key, arr|
        if @contents[key][1] == 1
          @contents.delete(key)
        end
      end
      res.cookies << WEBrick::Cookie.new('_rails_lite_flash', @contents.to_json)
    end
  end
end
