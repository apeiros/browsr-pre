require 'browsr/javascript'

class Browsr
  class JavascriptEngine
    @default_engine = :v8
    class <<self
      attr_accessor :default_engine
    end

    attr_reader :engine

    def initialize(browsr, window, engine=nil)
      @engine = engine ||= self.class.default_engine
      @browsr = browsr
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
          puts "Require javascript #{full_path}"
          @interpreter.eval(File.read(full_path), full_path)
        else
          raise "Missing source file, could not find #{path.inspect}"
        end
        true
      end
      public :require

      def initialize_engine
        @interpreter = V8::Context.new(:with => Javascript::Context.new(@browsr, @window))
        require_js 'browsr/js/browsr'
      end
    end
  end
end
