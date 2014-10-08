module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req, @res = req, res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response ? true : false
    end

    # Set the response status code and header
    def redirect_to(url)
      unless @already_built_response
        # @res.set_redirect(WEBrick::HTTPStatus::Found,url)
        @res.header["location"] = url
        @res.status = 302
        @already_built_response = @res
      else
        raise "can't render twice"
      end
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      unless @already_built_response
        @res.content_type = type
        @res.body = content
        @already_built_response = @res
      else
        raise "can't render twice"
      end
    end
  end
end
