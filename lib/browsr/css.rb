class Browsr
  class CSS
    RE_NL = Regexp.new('(\n|\r\n|\r|\f)')
    RE_NON_ASCII = Regexp.new('([\x00-\xFF])', Regexp::IGNORECASE, 'n')  #[^\0-\177]
    RE_UNICODE = Regexp.new('(\\\\[0-9a-f]{1,6}(\r\n|[ \n\r\t\f])*)', Regexp::IGNORECASE | Regexp::EXTENDED | Regexp::MULTILINE, 'n')
    RE_ESCAPE = Regexp.union(RE_UNICODE, '|(\\\\[^\n\r\f0-9a-f])')
    RE_IDENT = Regexp.new("[\-]?([_a-z]|#{RE_NON_ASCII}|#{RE_ESCAPE})([_a-z0-9\-]|#{RE_NON_ASCII}|#{RE_ESCAPE})*", Regexp::IGNORECASE, 'n')
  
    # General strings
    RE_STRING1 = Regexp.new('(\"(.[^\n\r\f\\"]*|\\\\' + RE_NL.to_s + '|' + RE_ESCAPE.to_s + ')*\")')
    RE_STRING2 = Regexp.new('(\'(.[^\n\r\f\\\']*|\\\\' + RE_NL.to_s + '|' + RE_ESCAPE.to_s + ')*\')')
    RE_STRING = Regexp.union(RE_STRING1, RE_STRING2)
  
    RE_URI = Regexp.new('(url\([\s]*([\s]*' + RE_STRING.to_s + '[\s]*)[\s]*\))|(url\([\s]*([!#$%&*\-~]|' + RE_NON_ASCII.to_s + '|' + RE_ESCAPE.to_s + ')*[\s]*)\)', Regexp::IGNORECASE | Regexp::EXTENDED  | Regexp::MULTILINE, 'n')
    URI_RX = /url\(("([^"]*)"|'([^']*)'|([^)]*))\)/im
  
    # Initial parsing
    RE_AT_IMPORT_RULE = /\@import[\s]+(url\()?["''"]?(.[^'"\s"']*)["''"]?\)?([\w\s\,^\])]*)\)?;?/
    
    #--
    #RE_AT_MEDIA_RULE = Regexp.new('(\"(.[^\n\r\f\\"]*|\\\\' + RE_NL.to_s + '|' + RE_ESCAPE.to_s + ')*\")')
    
    #RE_AT_IMPORT_RULE = Regexp.new('@import[\s]*(' + RE_STRING.to_s + ')([\w\s\,]*)[;]?', Regexp::IGNORECASE) -- should handle url() even though it is not allowed
    #++
    IMPORTANT_IN_PROPERTY_RX = /[\s]*\!important[\s]*/i
    STRIP_CSS_COMMENTS_RX = /\/\*.*?\*\//m
    STRIP_HTML_COMMENTS_RX = /\<\!\-\-|\-\-\>/m
  
    # Special units
    BOX_MODEL_UNITS_RX = /(auto|inherit|0|([\-]*([0-9]+|[0-9]*\.[0-9]+)(e[mx]+|px|[cm]+m|p[tc+]|in|\%)))([\s;]|\Z)/imx
    RE_LENGTH_OR_PERCENTAGE = Regexp.new('([\-]*(([0-9]*\.[0-9]+)|[0-9]+)(e[mx]+|px|[cm]+m|p[tc+]|in|\%))', Regexp::IGNORECASE)
    RE_BACKGROUND_POSITION = Regexp.new("((#{RE_LENGTH_OR_PERCENTAGE})|left|center|right|top|bottom)", Regexp::IGNORECASE | Regexp::EXTENDED)
    FONT_UNITS_RX = /(([x]+\-)*small|medium|large[r]*|auto|inherit|([0-9]+|[0-9]*\.[0-9]+)(e[mx]+|px|[cm]+m|p[tc+]|in|\%)*)/i
   
    # Patterns for specificity calculations
    ELEMENTS_AND_PSEUDO_ELEMENTS_RX = /((^|[\s\+\>]+)[\w]+|\:(first\-line|first\-letter|before|after))/i
    NON_ID_ATTRIBUTES_AND_PSEUDO_CLASSES_RX = /(\.[\w]+)|(\[[\w]+)|(\:(link|first\-child|lang))/i
  
    # Colours
    RE_COLOUR_RGB = Regexp.new('(rgb[\s]*\([\s-]*[\d]+(\.[\d]+)?[%\s]*,[\s-]*[\d]+(\.[\d]+)?[%\s]*,[\s-]*[\d]+(\.[\d]+)?[%\s]*\))', Regexp::IGNORECASE)
    RE_COLOUR_HEX = /(#([0-9a-f]{6}|[0-9a-f]{3})([\s;]|$))/i
    RE_COLOUR_NAMED = /([\s]*^)?(aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|orange|purple|red|silver|teal|white|yellow|transparent)([\s]*$)?/i
    RE_COLOUR = Regexp.union(RE_COLOUR_RGB, RE_COLOUR_HEX, RE_COLOUR_NAMED)

    class RuleSet
      attr_reader :rules, :position
      def self.parse(string)
        rule_set = new
        rule_set.parse(string)
        rule_set
      end

      def initialize
        @position = 0
        @rules    = []
      end

      def parse(string)
        string.scan(/(\S[^{]*)\{([^}]*)\}/m) do |selectors, properties|
          properties = Properties.parse(properties)
          selectors.split(/,/).each do |selector|
            self << Rule.new(@position += 1, selector.strip, properties)
          end
        end
      end

      def <<(rule)
        @rules << rule
      end
    end

    class Properties
      def self.parse(string)
        properties = new
        properties.parse(string)
        properties
      end

      def initialize
        @properties = {}
      end

      def parse(string)
        string.scan(/([^:]*):([^;]*);/).each do |property, value|
          self[property.strip.tr('-','_').downcase.to_sym] = value.strip
        end
      end

      def [](property)
        @properties[property.is_a?(Symbol) ? property : property.to_s.strip.tr('-','_').downcase.to_sym]
      end

      def []=(property, value)
        @properties[property] = value
      end

      def method_missing(name, *args)
        if @properties.has_key?(name) then
          raise ArgumentError, "Too many arguments" unless args.empty?
          @properties[name]
        else
          super
        end
      end

      def respond_to_missing?(name)
        @properties.has_key?(name)
      end

      def to_hash
        @properties.dup
      end
    end

    class Rule
      include Comparable

      attr_reader :position, :selector, :properties, :importance, :specificity

      def initialize(position, selector, properties)
        @selector     = selector
        @specificity  = Specificity.parse(selector)
        @properties   = properties
        @importance   = [*@specifity, position]
      end
    end

    class Specificity
      OriginSpecifity = {
      }
      include Comparable

      def self.parse_to_int(selector)
      end

      def self.parse(selector, origin=:user)
        b = selector.count('#')
        a = 0
        b = selector.scan(/\#/).length
        c = selector.scan(NON_ID_ATTRIBUTES_AND_PSEUDO_CLASSES_RX).length
        d = selector.scan(ELEMENTS_AND_PSEUDO_ELEMENTS_RX).length
        new(0,b,c,d)
      end

      attr_reader :a, :b, :c, :d, :value

      def initialize(a,b,c,d)
        @a      = a
        @b      = b
        @c      = c
        @d      = d
        @value  = [a,b,c,d]
      end

      def <=>(other)
        other.respond_to?(:value) && @value <=> other.value
      end

      def to_a
        @value
      end

      def binary
        @value.pack("S4") # base 65536 ought to be enough, yes?
      end

      def inspect
        "\#<CSS::Specifity %d,%d,%d,%d>" % @value
      end
    end
  end
end
