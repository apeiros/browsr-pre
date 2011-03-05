class Browsr
  class CSS

    # A ruleset is a collection of rules sharing the same media query
    class RuleSet
      include Enumerable

      attr_reader :media
      attr_reader :rulesets

      def initialize(media, rules={})
        @media = media
        @rules = rules # selector[String] => rule[Rule]
      end

      def update(rule)
        string_selector = rule.selector.to_s
        existing        = @rules[string_selector]
        if existing then
          less, more = *[existing, rule].sort
          less.update(more.properties.__hash__)
        else
          @rules[string_selector] = rule
        end
      end

      def each(&block)
        @rules.each_value(&block)
      end

      # Match this Ruleset
      def =~(medium)
        @media =~ medium
      end
      alias === =~
    end
  end
end
