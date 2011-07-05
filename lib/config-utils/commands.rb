class Command
    def initialize(document, key, value=nil)
        @document, @key, @value = document, key, value
    end

    def run
        raise RuntimeError, "Implement me"
    end

    private
    def build_result(command, document, key, value)
        {
            :command => command,
            :document => document,
            :key => key,
            :value => value
        }
    end

    def set(value)
        if value.is_a? Array
            if value.length == 0
                @document.delete(@key)
            elsif value.length == 1
                @document[@key] = value[0]
            else
                @document[@key] = value
            end
        elsif value.nil?
            @document.delete(@key)
        else
            @document[@key] = value
        end
    end
end

class GetCommand < Command
    def run
        value = @document[@key]
        build_result(self, @document, @key, value)
    end
end

class SetCommand < Command
    def run
        @document[@key] = @value
        build_result(self, @document, @key, @value)
    end
end

class AppendCommand < Command
    def run
        if @document[@key].is_a? Array
            @document[@key] << @value
        else
            @document[@key] = [@document[@key], @value]
        end
        build_result(self, @document, @key, @document[@key])
    end
end

class DelCommand < Command
    def run
        if @value.nil?
            set(@value)
            return build_result(self, @document, nil, nil)
        end

        values = @document[@key]
        values = [values] unless values.is_a? Array

        matcher = @value.match("^/\(.*\)/$")
        if matcher
            regexp = Regexp.new(matcher[1])
            values = values.reject {|element| regexp.match(element) }
        else
            values = values.reject {|element| element == @value}
        end

        set(values)
        if @document.has_key? @key
            return build_result(self, @document, @key, @document[@key])
        else
            return build_result(self, @document, nil, nil)
        end
    end
end




