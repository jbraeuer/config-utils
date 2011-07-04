class Item
    attr_accessor :mode, :key, :value
    def initialize(mode, key, value=nil)
        @mode, @key, @value = mode, key, value
    end
end

