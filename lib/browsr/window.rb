require 'v8'
require 'nokogiri'
require 'browsr/css'
require 'browsr/javascript'
require 'browsr/javascriptengine'
require 'mime/types'



class Browsr

  # Window is the equivalent to the state a normal browser has when the user
  # visits a website. It is the context for any javascript, the relative path
  # for assets like images and stylesheets etc.
  class Window < Resource
    InlineResource  = Struct.new(:data, :content_mime_type, :loading_file, :loading_line)
    CSS_MIME_Type   = MIME::Types['text/css'].first
    JS_MIME_Type    = MIME::Types['application/javascript'].first

    attr_reader :browsr
    attr_reader :main_resource
    attr_reader :original_source
    attr_reader :javascript
    attr_reader :resources
    attr_reader :site
    attr_reader :base
    attr_reader :log

    def initialize(browsr, resource)
      @browsr          = browsr
      @main_resource   = resource
      @site            = resource.site
      @resources       = []
      @original_source = resource.data
      @log             = []
    end

    def original_dom
      @original_dom ||= Nokogiri.HTML(@original_source)
    end

    def dom
      @dom ||= begin
        original_dom.css('head script,head link[rel="stylesheet"]').each do |node|
          case node.name
            when "script"
              # add an if to test whether it's really javascript
              resource = load_resource(node, node["src"], JS_MIME_Type)
              evaluate_javascript_resource(resource)
            when "link"
              if node["rel"].nil? || ['stylesheet', 'alternate stylesheet'].include?(node["rel"].downcase) then
                load_resource(node, node["href"], CSS_MIME_Type)
              end
            when "style"
              load_resource(node, nil, :stylesheet)
          else
            raise "Unknown node.name #{node.name.inspect}"
          end
        end
        original_dom.dup
      end
    end

    def source
      dom.to_html
    end

    def css
      @css ||= begin
        dom # loads the dom and with it all external stylesheets
        css = CSS.new do |url|
          uri      = absolute_uri_for(url)
          resource = @browsr.get(uri)
          @resources << resource
        end # TODO: add media options
        @resources.select { |resource|
          resource.response.content_mime_type == CSS_MIME_Type
        }.each do |resource|
          css.append_external_stylesheet(
            resource.data,
            :author_style_sheet,
            CSS::Media::AllMedia,
            resource.loading_file,
            resource.loading_line
          )
        end

        css
      end
    end

    def load_resource(node, url, mime_type)
      if url then
        absolute_url  = absolute_uri_for(url)
        p :url => url, :absolute_url => absolute_url
        resource      = @browsr.get(absolute_url)
        resource_mime = resource.response.content_mime_type
        if resource_mime != mime_type then
          @log << Log.new(
            :warning,
            "Resource delivered as #{resource_mime}, interpreted as #{mime_type}",
            {:received => resource_mime, :interpreted => mime_type}
          )
        end
        identifier            = url
        data                  = resource.data
        resource.loading_file = url
        resource.loading_line = 1
      else
        data        = node.text
        identifier  = "<#{type}>:#{@resources.size}:line #{node.line}"
        file        = @site
        line        = 1
        resource    = InlineResource.new(data, mime_type, file, line)
      end

      @resources << resource

      resource
    end

    def eval_js(code)
      javascript_context.eval_js(code, "(eval)")
    end

    def evaluate_javascript_resource(resource)
      javascript_context.eval_js(resource.data, resource.loading_file, resource.loading_line)
    rescue
      puts "Failed to parse #{resource.loading_file}:#{resource.loading_line}", resource.data[/\A(?:.*\n){,5}/].gsub(/^/, '>> '), ""
      puts "#{$!.class}:#{$!}", *$!.backtrace.first(5)
    end

    def javascript_context
      @javascript ||= JavascriptEngine.new(self)
    rescue
      puts "#{$!.class}:#{$!}", *$!.backtrace.first(5)
    end

    # generate an absolute uri relative to the window's uri
    def absolute_uri_for(site)
      @main_resource.site_uri + site
    end

    def inspect
      sprintf "#<%s %s>", self.class, @site
    end
  end
end
