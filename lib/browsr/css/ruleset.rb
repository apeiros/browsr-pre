class Browsr
  class CSS

    # A ruleset is a collection of rules sharing the same media query
    class RuleSet
      include Enumerable

      attr_reader :media
      attr_reader :rulesets

      def initialize(media)
        @media = media
        @rules = {} # selector[String] => rule[Rule]
      end

      def update(rulesets)
        
      end

      def each(&block)
        @rulesets.each(&block)
      end

      # Match this Ruleset
      def =~(medium)
        @media =~ medium
      end
      alias === =~
    end
  end
end
