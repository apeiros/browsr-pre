class Browsr
  class Log
    attr_reader :level
    attr_reader :message
    attr_reader :data

    def initialize(level, message, data=nil)
      @level    = level
      @message  = message
      @data     = data
    end
  end
end
