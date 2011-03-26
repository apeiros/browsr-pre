require 'v8'



class Browsr
  class JavascriptEngine
    class V8 < JavascriptEngine
      register_engine :v8

      def initialize(*)
        @interpreter = ::V8::Context.new
        super
      end
    end
  end
end
