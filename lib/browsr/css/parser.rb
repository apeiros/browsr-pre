require 'strscan'
require 'browsr/css/expressions'
require 'browsr/css/rule'



def parse_css(string, media=Browsr::CSS::Media.new(nil,nil,nil), file="test.css")
  css = Browsr::CSS.new
  Browsr::CSS::Parser.new string, css, :author_style_sheet, media, file
end



class Browsr
  class CSS
    class Parser
      include Expressions

      ValidProperty = Hash.new(true) # FIXME: provide a list with string-keys

      # For the arguments, see Parser::new
      def self.parse(data, styles, origin, filename, line=1)
        parser = new(data, styles, origin, filename, line)
        parser.parse
        parser
      end

      attr_reader   :data, :scanner, :css, :media, :origin, :filename, :line, :debug

      # @param data [String]
      #   The raw data to parse
      # @param stylesheet [Browsr::CSS::StyleSheet]
      #   The stylesheet to add the parsed information to
      # @param filename [String]
      #   The filename to report in rules and errors
      # @param line [Integer]
      #   The starting line number (default: 1)
      def initialize(data, css, origin, media, filename, line=1)
        @data       = data.encode(Encoding::BINARY)
        @css        = css
        @media      = media
        @origin     = origin
        @filename   = filename.dup.freeze
        @line       = line
        @scanner    = StringScanner.new(data)
        @debug      = []
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
              @debug << [:parse, :parse_at_rule, position]
              parse_at_rule(@media)
            else
              @debug << [:parse, :parse_ruleset, position]
              parse_ruleset(@media)
          end
        end

        self
      end

      def parse_block(media)
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(CLOSE_BLOCK)
              @debug << [:terminate, :parse_block, position]
              return
            else
              @debug << [:parse_block, :parse_ruleset, position]
              parse_ruleset(media)
          end
        end
      end

      # not really implemented...
      def parse_at_rule(media)
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(TERMINATE)
              @debug << [:terminate, :parse_at_rule, position]
              return
            when scan(ANYTHING)
              # nothing
            when scan(OPEN_BLOCK)
              @debug << [:parse_at_rule, :parse_block, position]
              value = parse_block(media)
              @debug << [:terminate, :parse_at_rule, position]
              return value
          else
            malformed!
          end
        end
        premature_end!(:at_rule)
      end

      def parse_ruleset(media)
        current_chain       = []
        current_specificity = [0,0,0]
        selectors           = []
        until @scanner.eos?
          case
            when scan(WHITESPACE)
              unless current_chain.empty? || current_chain.last.first == :combinator then # whitespace/descendant has least precedence
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
              current_chain.pop if current_chain.last.last == :descendant # the 'descendant' has less precedence
              malformed! if current_chain.empty? || current_chain.last.first == :combinator
              current_chain << [:combinator, @scanner[0]]
            when scan(COMMA)
              malformed! if current_chain.empty?
              malformed! if current_chain.last.first == :combinator
              selectors << Selector.with_calculated_specificities(current_chain, current_specificity, @css.position += 1, @origin)
              current_chain       = []
              current_specificity = [0,0,0]
            when scan(OPEN_BLOCK)
              malformed! if current_chain.empty?
              current_chain.pop if current_chain.last.last == :descendant
              malformed! if current_chain.last.first == :combinator
              selectors << Selector.with_calculated_specificities(current_chain, current_specificity, @css.position += 1, @origin)
              @debug << [:parse_ruleset, :parse_style_block, position]
              value = parse_style_block(media, selectors)
              @debug << [:terminate, :parse_at_rule, position]
              return value
          else
            malformed!
          end
        end
      end

      def parse_style_block(media, selectors)
        normal_selectors, important_selectors = *selectors.map { |selector|
          [selector.normal_selector, selector.important_selector]
        }.transpose
        normal_rules    = normal_selectors.map { |selector| Rule.new(selector) }
        important_rules = important_selectors.map { |selector| Rule.new(selector) }

        until @scanner.eos?
          case
            when scan(WHITESPACE)
              # nothing
            when scan(COMMENT)
              # nothing
            when scan(CLOSE_BLOCK)
              (normal_rules+important_rules).each do |rule|
                @css.add_rule(media, rule)
              end
              @debug << [:terminate, :parse_style_block, position]
              return
            when check(IDENT)
              @debug << [:parse_style_block, :parse_rule, position]
              property, value, important = *parse_rule
              if ValidProperty[property] then
                begin
                  decomposed = Properties.decompose(property.to_sym, value)
                rescue
                  puts "#{$!.class} at #{position}"
                  raise
                end
                rules      = important ? important_rules : normal_rules
                rules.each do |rule| rule.update(decomposed) end
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
        @debug << [:terminate, :parse_rule, position]

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
