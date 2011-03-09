class Browsr

  # A convenience access to http headers.
  # * Case insensitive
  # * Case preserving
  # * Underscored accessors to all headers
  #
  # Example:
  #   headers = Browsr::HTTPHeaders.new "ACCEPT-CHARSET" => "utf-8"
  #   header["ACCEPT-CHARSET"] # => "utf-8"
  #   header["Accept-Charset"] # => "utf-8"
  #   header.accept_charset    # => "utf-8"
  #
  # Known Issues:
  # * For headers which indeed have an underscore ("_") in their identifier,
  #   you *must* use a String as key to set the value, in order to have case
  #   preservation work correctly, and using the dynamic setter method won't
  #   work. This is because symbol-keys become normalized using
  #   HTTPHeaders#normalized
  class HTTPHeaders
    include Enumerable

    def self.new(headers=nil)
      headers.is_a?(HTTPHeaders) ? headers : super(headers)
    end

    # For internal use only
    attr_reader :__hash__

    def initialize(headers=nil)
      @__hash__ = headers ? Hash[headers.map { |name, value| [canonical(name), [preserve(name), value]] }] : {}
    end

    def [](name)
      value = @__hash__[canonical(name)]
      value && value.last
    end

    def []=(name, value)
      @__hash__[canonical(name)] = [preserve(name), value]
    end

    def include?(name)
      @__hash__.has_key?(canonical(name))
    end

    def merge(other, &block)
      HTTPHeaders.new(@__hash__.merge(HTTPHeaders.new(other).__hash__, &block))
    end

    def merge!(other, &block)
      @__hash__.merge!(HTTPHeaders.new(other).__hash__, &block)
    end

    def replace(other)
      @__hash__.replace(other.__hash__)
    end

    def each
      @__hash__.each do |name, (preserved, value)|
        yield(preserved, value)
      end

      self
    end

    def to_header_string
      map { |key, value| "#{key}: #{value}" }.join("\r\n")
    end

    def to_a
      @__hash__.map { |name, (preserved, value)| [preserved, value] }
    end

    def to_hash
      Hash[to_a]
    end

    def to_s
      map { |key, value| "#{key}: #{value}" }.join(", ")
    end

    def inspect
      sprintf '#<%s %p>',
        self.class,
        to_hash
    end

    def method_missing(name, *args)
      case name[-1]
        when '?' then
          raise ArgumentError, "Too many arguments for method #{name} (#{args.size} for 0)" unless args.empty?
          @__hash__.has_key?(canonical(name[0..-2]))
        when '=' then
          raise ArgumentError, "Too many arguments for method #{name} (#{args.size} for 1)" if args.size > 1
          name = name[0..-2]
          @__hash__[canonical(name)] = [normalized(name), args.first]
        else
          raise ArgumentError, "Too many arguments for method #{name} (#{args.size} for 0)" unless args.empty?
          value = @__hash__[canonical(name)]
          value && value.last
      end
    end

  private
    def canonical(name)
      name.to_s.tr('A-Z-', 'a-z_')
    end

    def preserve(name)
      name.is_a?(Symbol) ? normalized(name) : name
    end

    def normalized(name)
      name.to_s.split(/_|-/).map { |slice| slice.capitalize }.join('-')
    end
  end
end
