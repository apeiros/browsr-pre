class Browsr
  class JavascriptEngine
    @default_engine = :v8
    @engines        = {}

    class <<self
      attr_accessor :default_engine
      attr_reader   :engines
    end

    def self.register_engine(sym)
      raise TypeError, "Symbol expected, but got #{sym.class}" unless sym.is_a?(Symbol)
      raise ArgumentError, "Engine #{sym.inspect} is already registered" if JavascriptEngine.engines[sym]
      JavascriptEngine.engines[sym] = self
      define_singleton_method(:new, Class.instance_method(:new))
    end

    def self.require_engine(engine)
      require "browsr/javascriptengine/#{engine}"
      true
    rescue LoadError => e
      puts "#{e.class}: #{e}", *e.backtrace.first(5)
      false
    end

    def self.new(window, engine=nil)
      engine ||= default_engine
      raise ArgumentError, "Unknown engine: #{engine.inspect}" unless require_engine(engine)
      @engines[engine].new(window, engine)
    end

    attr_reader :engine, :window

    def initialize(window, engine=nil)
      @engine = engine
      @window = window
      @interpreter["__NATIVE__"] = native_object
      require_js 'browsr/browsers/safari5/script_core.js'
    end

    def eval_js(code, file="(eval)", line=1)
      @interpreter.eval(code, file, line)
    end

    def require_js(path)
      full_path = Dir.glob("\{#{$LOAD_PATH.join(',')}\}/#{path}{.js,}").first
      if full_path then
        @interpreter.eval(File.read(full_path), full_path)
      else
        raise "Missing source file, could not find #{path.inspect}"
      end
      true
    end

    def native_object
      @native_object ||= {
        "javascript.document.location.href"         => "http://127.0.0.1:80/index.html",
        "javascript.document.location.protocol"     => "http:",
        "javascript.document.location.host"         => "127.0.0.1:80",
        "javascript.document.location.hostname"     => "127.0.0.1",
        "javascript.document.location.port"         => "80",
        "javascript.document.location.pathname"     => "/index.html",
        "javascript.document.location.hash"         => "",
        "javascript.document.location.search"       => "",

        "javascript.window.navigator.appCodeName"   => "Mozilla",
        "javascript.window.navigator.appName"       => "Netscape",
        "javascript.window.navigator.appVersion"    => "5.0 (Macintosh; U; Intel Mac OS X 10_6_6; de-de) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27",
        "javascript.window.navigator.cookieEnabled" => true,
        "javascript.window.navigator.geolocation"   => nil, # Geolocation
        "javascript.window.navigator.language"      => "en",
        "javascript.window.navigator.mimeTypes"     => nil, # MimeTypeArray
        "javascript.window.navigator.onLine"        => false,
        "javascript.window.navigator.platform"      => "MacIntel",
        "javascript.window.navigator.plugins"       => nil, #PluginArray
        "javascript.window.navigator.product"       => "Gecko",
        "javascript.window.navigator.productSub"    => "20030107",
        "javascript.window.navigator.userAgent"     => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; de-de) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27",
        "javascript.window.navigator.vendor"        => "Apple Computer, Inc.",
        "javascript.window.navigator.vendorSub"     => "",

        "document.querySelector"                    => proc { |selector| @window.dom.at_css(selector) },
        "document.querySelectorAll"                 => proc { |selector| @window.dom.css(selector) },
      }
    end
  end
end
