class Command
    def initialize(document, key, value=nil)
        @document, @key, @value = document, key, value
    end

    def run
        raise RuntimeError, "Implement me"
    end
end

class SetCommand < Command
    def run
        @document[@key] = @value
    end
end

class GetCommand < Command
    def run
        @document[@key]
    end
end

