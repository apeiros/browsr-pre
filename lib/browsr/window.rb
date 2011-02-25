class Browsr
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
