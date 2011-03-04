require 'v8'
require 'nokogiri'
require 'browsr/css'
require 'browsr/javascript'
require 'browsr/javascriptengine'



class Browsr

  # Window is the equivalent to the state a normal browser has when the user
  # visits a website. It is the context for any javascript, the relative path
  # for assets like images and stylesheets etc.
  class Window
    attr_reader :original_source
    attr_reader :javascript
    attr_reader :resources
    attr_reader :page
    attr_reader :base

    def initialize(browser, response)
      @browser         = browser
      @page            = response.page
      @resources       = {}
      @original_source = source
    end

    def original_dom
      @original_dom ||= Nokogiri.HTML(source)
    end

    def dom
      @dom ||= begin
        original_dom.css('head script,head link[rel="stylesheet"]').each do |node|
          case node.name
            when "script"
              # add an if to test whether it's really javascript
              resource = load_resource(node, node["src"], :javascript)
              evaluate_javascript_resource(resource)
            when "link"
              if node["rel"].nil? || ['stylesheet', 'alternate stylesheet'].include?(node["rel"].downcase) then
                resource = load_resource(node, node["href"], :stylesheet)
                evaluate_stylesheet_resource(resource)
              end
            when "style"
              resource = load_resource(node, nil, :stylesheet)
              evaluate_stylesheet_resource(resource)
          else
            raise "Unknown node.name #{node.name.inspect}"
          end
        end
        original_dom.dup
      end
    end

    def source
      @dom.to_html
    end

    def css
      @css ||= begin
        dom # loads the dom and with it all external stylesheets
        @css = CSS.new # TODO: add media options
        @resources.values.select { |resource|
          #resource.mime_type == :'text/css'
          resource.type == :stylesheet
        }.sort_by { |resource|
          resource.order
        }.each do |resource|
          @css.add_stylesheet(resource.data)
        end
      end
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

      resource               = Resource.new(@resources.size, type, identifier, file, line, data)
      raise ArgumentError, "Identifier #{identifier.inspect} already exists"
      @resources[identifier] = resource

      resource
    end

    def eval_js(code)
      javascript_context.eval_js(code, "(eval)")
    end

    def evaluate_javascript_resource(resource)
      javascript_context.eval_js(resource.data, resource.file, resource.line)
    rescue
      puts "Failed to parse #{resource.file}:#{resource.line}", resource.data
      puts "#{$!.class}:#{$!}", *$!.backtrace.first(5)
    end

    def evaluate_stylesheet_resource(resource)
      @styles.parse(resource.data)
    end

    def javascript_context
      @javascript ||= JavascriptEngine.new(@browser, self)
    rescue
      puts "#{$!.class}:#{$!}", *$!.backtrace.first(5)
    end

    def inspect
      sprintf "#<%s %s>", self.class, @page
    end
  end
end
