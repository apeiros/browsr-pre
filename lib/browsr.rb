require 'v8'
require 'nokogiri'
require 'rack'
require 'browsr/css'
require 'browsr/javascript'

class Browsr
  def initialize(app)
    @app          = app
    @mock_request = Rack::MockRequest.new(app)
  end

  def visit(page)
    response = @mock_request.get(page)
    if response.ok? && response.content_type == "text/html" then
      Window.new(self, page, response.body)
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

  Resource = Struct.new(:type, :identifier, :file, :line, :data)

  class JS
    R_TagName   = /\A[A-Za-z_][A-Za-z0-9_-]*\z/
    R_ClassName = /\A[A-Za-z_][A-Za-z0-9_]*\z/
    R_AttrID    = /\A[A-Za-z_][A-Za-z0-9_]*\z/

    def initialize(window)
      @window = window
    end

    def document
      @document ||= HTMLDocument.new(@window)
    end

    class HTMLDocument
      def initialize(window)
        @window = window
      end

      def getElementById(id)
        id = id.to_s
        return unless id =~ R_AttrID
        node = @window.dom.at_css("\##{id}")
        node && HTMLElement.new(@window, node)
      end

      def getElementsByClassName(class_name)
        class_name = class_name.to_s
        return unless class_name =~ R_ClassName
        node = @window.dom.css(class_name)
        node && HTMLElement.new(@window, node)
      end

      def getElementsByTagName(tag_name)
        tag_name = tag_name.to_s
        return unless tag_name =~ R_TagName
        node = @window.dom.css(tag_name)
        node && HTMLElement.new(@window, node)
      end

      def querySelector(selector)
        node = @window.dom.at_css(selector.to_s)
        node && HTMLElement.new(@window, node)
      end

      def querySelectorAll(selector)
        @window.dom.css(selector.to_s).map { |node|
          HTMLElement.new(@window, node)
        }
      end
    end

    class HTMLElement
      def initialize(window, node)
        @window = window
        @node   = node
      end

      def innerHTML=(value)
        @node.inner_html = value.to_s
      end

      def innerHTML
        @node.inner_html
      end

      def innerText=(value)
        @node.inner_html = value.to_s
      end

      def innerText
        @node.inner_text
      end

      def tagName
        @node.name.upcase
      end

      def getAttribute(name)
        @node[name]
      end

      def setAttribute(name, value)
        @node[name] = value
      end

      def to_s
        attrs = @node.attributes.empty? ? "" : " #{@node.attributes.map { |name,a| "#{name}=#{a.value.inspect}" }.join(" ")}"
        "[HTMLElement <#{@node.name}#{attrs}>]"
      end
    end
  end

  module V8Extensions
    def require(path)
      full_path = Dir.glob("\{#{$LOAD_PATH.join(',')}\}/#{path}{.js,}").first
      if full_path then
        puts "Require javascript #{full_path}"
        eval(File.read(full_path), full_path)
      else
        raise "Missing source file, could not find #{path.inspect}"
      end
      true
    end
    public :require
  end

  class Window
    attr_reader :original_source
    attr_reader :original_dom
    attr_reader :dom
    attr_reader :javascript
    attr_reader :resources
    attr_reader :page
    attr_reader :base
    attr_reader :styles

    def initialize(browser, page, source)
      @browser         = browser
      @page            = page
      @base            = File.dirname(page)
      @resources       = {}
      @styles          = CSS::RuleSet.new
      @original_source = source
      @original_dom    = Nokogiri.HTML(source)
      @original_dom.css('head script,head link[rel="stylesheet"]').each do |node|
        case node.name
          when "script"
            resource = load_resource(node, node["src"], :script)
            evaluate_javascript_resource(resource)
          when "link"
            resource = load_resource(node, node["href"], :link)
            evaluate_stylesheet_resource(resource)
        else
          raise "Unknown node.name #{node.name.inspect}"
        end
      end
      @dom            = original_dom.dup
    end

    def source
      @dom.to_html
    end

    def load_resource(node, url, type)
      if url then
        data        = @browser.get(url, @base)
        identifier  = url
        file        = url
        line        = 1
      else
        data        = node.text
        identifier  = "<#{type}>:#{@resources.size}:line #{node.line}"
        file        = @page
        line        = 1
      end

      resource               = Resource.new(type, identifier, file, line, data)
      @resources[identifier] = resource

      resource
    end

    def eval_js(code)
      javascript_context.eval(code, "(eval)")
    end

    def evaluate_javascript_resource(resource)
      javascript_context.eval(resource.data, resource.file, resource.line)
    rescue
      puts "Failed to parse #{resource.file}:#{resource.line}", resource.data
    end

    def evaluate_stylesheet_resource(resource)
      @styles.parse(resource.data)
    end

    def javascript_context
      @javascript ||= begin
        js = V8::Context.new(:with => Javascript::Context.new(self))
        js.extend V8Extensions
        js.require 'browsr/js/browsr'
        js
      end
      @javascript
    rescue
      puts "#{$!.class}:#{$!}", *$!.backtrace.first(5)
    end

    def inspect
      sprintf "#<%s %s>", self.class, @page
    end
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