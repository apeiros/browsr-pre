require 'rack'
require 'browsr/resource'
require 'browsr/window'

class Browsr
  attr_reader :current_window
  attr_reader :medium

  def initialize(app, options={})
    @app            = app
    @mock_request   = Rack::MockRequest.new(app)
    @current_window = nil
    @medium         = CSS::Medium.new(options[:medium])
  end

  def visit(page)
    response = @mock_request.get(page)
    if response.ok? && response.content_type == "text/html" then
      @current_window = Window.new(self, page, response.body)
    else
      nil
    end
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
