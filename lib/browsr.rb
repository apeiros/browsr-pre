require 'v8'
require 'nokogiri'
require 'rack'
require 'browsr/css'
require 'browsr/javascript'
require 'browsr/javascriptengine'
require 'browsr/resource'
require 'browsr/window'

class Browsr
  attr_reader :current_window

  def initialize(app)
    @app            = app
    @mock_request   = Rack::MockRequest.new(app)
    @current_window = nil
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

if __FILE__ == $0 then
  [
     '*',                '0,0,0,0',
     'li',               '0,0,0,1',
     'li:first-line',    '0,0,0,2',
     'ul li',            '0,0,0,2',
     'ul ol+li',         '0,0,0,3',
     'h1 + *[rel=up]',   '0,0,1,1',
     'ul ol li.red',     '0,0,1,3',
     'li.red.level',     '0,0,2,1',
     '#x34y',            '0,1,0,0',
  ].each_slice(2) do |selector, should_be|
    p Browsr::CSS::Specificity.parse(selector) => should_be
  end
end
