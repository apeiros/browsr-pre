require 'strscan'
require 'browsr/css/expressions'
require 'browsr/css/rule'



class Browsr
  class CSS
    class Parser
      include Expressions

      # For the arguments, see Parser::new
      def self.parse(data, styles, origin, filename, line=1)
        parser = new(data, styles, origin, filename, line)
        parser.parse
        parser
      end

      attr_reader   :data, :scanner, :styles, :origin, :filename, :line

      # @param data [String]
      #   The raw data to parse
      # @param stylesheet [Browsr::CSS::StyleSheet]
      #   The stylesheet to add the parsed information to
      # @param filename [String]
      #   The filename to report in rules and errors
      # @param line [Integer]
      #   The starting line number (default: 1)
      def initialize(data, styles, origin, filename, line=1)
        @data       = data.encode(Encoding::BINARY)
        @styles     = styles
        @origin     = origin
        @filename   = filename.dup.freeze
        @line       = line
        @scanner    = StringScanner.new(data)
      end
    
      def current_selectors
        nil
      end

      def current_media
        nil
      end

      # @return [Array] [line, column, character]
      def position
        last_newline  = (@scanner.string.rindex("\n", @scanner.pos) || -1) + 1
        char          = @scanner.pos
        col           = char-last_newline

        [@line, col, char]
      end

      def scan(expression)
        result = @scanner.scan(expression)
        @line += result.count("\n") if result
        result
      end

      def check(expression)
        @scanner.check(expression)
      end

      def parse
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(AT_RULE)
              p :parse => :parse_at_rule
              parse_at_rule
            else
              p :parse => :parse_ruleset
              parse_ruleset
          end
        end
      end

      def parse_block
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(CLOSE_BLOCK)
              return
            else
              p :parse_block => :parse_ruleset
              parse_ruleset
          end
        end
      end

      # not really implemented...
      def parse_at_rule
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(TERMINATE)
              return
            when scan(ANYTHING)
              # nothing
            when scan(OPEN_BLOCK)
              p :parse_at_rule => :parse_block
              return parse_block
          else
            malformed!
          end
        end
        premature_end!(:at_rule)
      end

      def parse_ruleset
        current_chain       = []
        current_specificity = [0,0,0]
        selectors   = [current_chain] # [selector, selector, ...]; selector: [piece, piece, ...]; piece: [:id | :class | :type | :combinator, <value>]
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              unless current_chain.empty? || current_chain.last.last == :descendant then
                malformed! if current_chain.last.first == :combinator
                current_chain << [:combinator, :descendant]
              end
            when scan(COMMENT)
              # nothing
            when scan(UNIVERSAL_SELECTOR)
              #malformed! unless current_chain.empty? || current_chain.last.first == :combinator
              current_chain << [:universal_selector, @scanner[0]]
            when scan(CLASS_A_SELECTOR)
              #malformed! unless current_chain.empty? || current_chain.last.first == :combinator
              current_specificity[0] += 1
              current_chain << [:id_selector, @scanner[0]]
            when scan(CLASS_B_SELECTOR)
              #malformed! unless current_chain.empty? || current_chain.last.first == :combinator
              current_specificity[1] += 1
              current_chain << [:class_selector, @scanner[0]]
            when scan(CLASS_C_SELECTOR)
              #malformed! unless current_chain.empty? || current_chain.last.first == :combinator
              current_specificity[2] += 1
              current_chain << [:type_selector, @scanner[0]]
            when scan(COMBINATOR)
              malformed! if current_chain.empty? || current_chain.last.first == :combinator
              current_chain << [:combinator, @scanner[0]]
            when scan(COMMA)
              malformed! if current_chain.empty?
              malformed! if current_chain.last.first == :combinator
              current_chain      = []
              selectors << current_chain
            when scan(OPEN_BLOCK)
              malformed! if current_chain.empty?
              current_chain.pop if current_chain.last.last == :descendant
              malformed! if current_chain.last.first == :combinator
              p :parse_ruleset => :parse_style_block
              return parse_style_block(selectors, current_specificity, nil)
          else
            malformed!
          end
        end
      end

      def parse_style_block(selectors, media)
        string_selectors = selectors.map { |chain, specificity| selector_chain_to_string(chain) }.join(', ')
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(CLOSE_BLOCK)
              return
            when check(IDENT)
              property, value, important = *parse_rule
              puts "parsed #{property.inspect}: #{value.inspect}; selectors: #{string_selectors}; media: #{current_media}"
              decomposed = Rule.decompoase(property, value)
              decomposed.each do |property, value|
                string_selectors.each do |selector|
                  @stylesheet.add Rule.new(property, value, selector, media)
                end
              end
          else
            malformed!
          end
        end
        premature_end!(:style_block)
      end

      def parse_rule
        malformed! unless scan(IDENT)
        property = @scanner[0]
        parse_whitespace_and_comment
        malformed! unless scan(COLON)
        parse_whitespace_and_comment
        malformed! unless scan(ANYVAL)
        value    = @scanner[0].strip
        parse_whitespace_and_comment
        important = scan(IMPORTANT) ? true : false
        malformed! unless scan(TERMINATE)

        [property, value, important]
      end

      def parse_whitespace_and_comment
        scan(WHITESPACE)
        scan(COMMENT)
        scan(WHITESPACE)
      end

    private
      def premature_end!(context)
        raise "Stylesheet ended prematurely in context #{context}"
      end
      def malformed!
        raise "Malformed stylesheet #{position.first(2).join(':')}"
      end
    end # Parser
  end # CSS
end # Browsr
