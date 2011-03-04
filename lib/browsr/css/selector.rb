require 'browsr/css/expressions'

class Browsr
  class CSS
    # A rule is a couple of property/value pairs sharing the same selector
    class Selector
      OriginSpecifity = Hash.new { |_,key| raise ArgumentError, "Unknown origin: #{key.inspect}" }.merge({
        :user_agent_style_sheet       => (0 << 59),
        :user_normal_style_sheet      => (1 << 59),
        :author_normal_style_sheet    => (2 << 59),
        :author_important_style_sheet => (3 << 59),
        :user_important_style_sheet   => (4 << 59),
        :style_tag                    => (5 << 59),
      })
      UnaugmentOrigin =  Hash.new { |_,key| raise ArgumentError, "Can't unaugment: #{key.inspect}" }.merge({
        :user_agent_style_sheet       => :user_agent_style_sheet,
        :user_normal_style_sheet      => :user_style_sheet,
        :author_normal_style_sheet    => :author_style_sheet,
        :author_important_style_sheet => :author_style_sheet,
        :user_important_style_sheet   => :user_style_sheet,
        :style_tag                    => :style_tag,
      })
      UnaugmentedOrigin = Hash.new { |_,key| raise ArgumentError, "Can't augment: #{key.inspect}" }.merge({
        :user_agent_style_sheet  => {
          :normal     => (0 << 59),
          :important  => (0 << 59),
        },
        :user_style_sheet        => {
          :normal     => (1 << 59),
          :important  => (4 << 59),
        },
        :author_style_sheet        => {
          :normal     => (2 << 59),
          :important  => (3 << 59),
        },
        :style_tag               => {
          :normal     => (5 << 59),
          :important  => (5 << 59),
        }
      })
      StyleTagSpecificity = OriginSpecifity[:style_tag]

      def self.css_specificity_from_counts(class_a, class_b, class_c)
        int  = [class_a << 50, (1<<59)-1].min
        int |= [class_b << 40, (1<<50)-1].min
        int |= [class_c << 30, (1<<40)-1].min
        int
      end

      attr_reader :normal_specificity
      attr_reader :important_specificity
      attr_reader :chain

      def initialize(chain, counts, position, origin)
        css_specificity         = css_specificity_from_counts(*counts) | position
        @normal_specificity     = css_specificity | UnaugmentedOrigin[origin][:normal]
        @important_specificity  = css_specificity | UnaugmentedOrigin[origin][:important]
        @counts                 = counts
        @chain                  = chain
        @string                 = chain.map { |type, value| value == :descendant ? " " : value }.join('')
      end

      def to_s
        @string.dup
      end
    end
  end
end
