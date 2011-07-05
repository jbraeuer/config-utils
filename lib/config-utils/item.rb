class Item
    attr_accessor :mode, :key, :value
    def initialize(mode, key, options, value=nil)
        @mode, @key, @options, @value = mode, key, options, value
    end

    def render
        start = "#{key}="
        start = "" if @options[:raw]
        if value.nil? or value.empty?
            puts "#{start}"
        else
            puts "#{start}#{value.join(@options[:separator])}"
        end
    end
end

