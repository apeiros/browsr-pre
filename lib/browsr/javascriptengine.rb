require 'browsr/javascript'

class Browsr
  class JavascriptEngine
    @default_engine = :v8
    class <<self
      attr_accessor :default_engine
    end

    attr_reader :engine, :window

    def initialize(window, engine=nil)
      @engine = engine ||= self.class.default_engine
      @window = window

      case @engine
        when :v8
          require 'v8'
          extend V8Engine
        else
          raise ArgumentError, "Unknown engine #{engine.inspect}"
      end
      initialize_engine
    end

    module V8Engine
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
      public :require

      def initialize_engine
        @interpreter               = V8::Context.new
        @interpreter["__NATIVE__"] = {
          "javascript.document.location.href"      => "http://127.0.0.1:80/index.html",
          "javascript.document.location.protocol"  => "http:",
          "javascript.document.location.host"      => "127.0.0.1:80",
          "javascript.document.location.hostname"  => "127.0.0.1",
          "javascript.document.location.port"      => "80",
          "javascript.document.location.pathname"  => "/index.html",
          "javascript.document.location.hash"      => "",
          "javascript.document.location.search"    => "",
        }
        require_js 'browsr/browsers/safari5/javascript/browsr.js'
      end
    end
  end
end
