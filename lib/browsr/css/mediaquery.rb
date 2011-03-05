class Browsr
  class CSS
    # A MediaQuery that can be used to match against a Medium
    # TODO: implement
    class MediaQuery
      def self.parse(string)
        new
      end

      def initialize()
      end

      def =~(medium)
        true
      end

      def inspect
        sprintf "\#<%p %s>", self.class, @media.to_a.join(', ')
      end
    end
  end
end
