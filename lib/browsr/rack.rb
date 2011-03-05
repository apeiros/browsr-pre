require 'rack'

class Browsr
  module Rack

  def initialize_rack(app, options={})
    @mock_request   = Rack::MockRequest.new(app)
  end

  def visit(page)
    response        = Response.rack_mock_response(@mock_request.get(page))
    window          = Window.new(self, response)
    window
  end

  def get(page, relative_to="/")
    page = [relative_to, page].join("/") unless page[0] == "/"
    response = @mock_request.get(page)
    response.body
  end

  def inspect
    sprintf '#<%s>', self.class
  end
end
