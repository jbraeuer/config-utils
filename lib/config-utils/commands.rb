class CommandFactory
    def self.fromWorkItem(store, item)
        content = (store[item.docpath] or {})
        document = Document.new(item.docpath, content)
        case item.op
        when :get
            GetCommand.new(document, item.args[0])
        when :set
            SetCommand.new(document, item.args[0], item.args[1])
        when :append
            AppendCommand.new(document, item.args[0], item.args[1])
        when :del
            DelCommand.new(document, item.args[0], item.args[1])
        else
            raise "Unsupported workitem operation: #{item.op}"
        end
    end
end

class CommandResult < Hash

    def self.build(command, document, key, value)
        CommandResult.new.merge( {
                                     :command => command,
                                     :document => document,
                                     :key => key,
                                     :value => value
                                 } )
    end

    def render(options)
        prefix = ""
        prefix = "#{self[:key]}=" unless options[:raw]
        values = self[:value]
        values = [values] unless values.is_a? Array
        puts "#{prefix}#{values.join(options[:separator])}"
    end
end

class Command
    def initialize(document, key, value=nil)
        raise "Command cant operate without document." if document.nil?
        @document, @key, @value = document, key, value
    end

    def to_s
        return "<#{super.to_s}:#{@document}:#{@key}:#{@value}>"
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
        CommandResult.build(self, @document, @key, value)
    end
end

class SetCommand < Command
    def run
        @document[@key] = @value
        CommandResult.build(self, @document, @key, @value)
    end
end

class AppendCommand < Command
    def run
        if @document[@key].is_a? Array
            @document[@key] << @value
        else
            @document[@key] = [@document[@key], @value]
        end
        CommandResult.build(self, @document, @key, @document[@key])
    end
end

class DelCommand < Command
    def run
        if @value.nil?
            set(@value)
            return CommandResult.build(self, @document, nil, nil)
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
            return CommandResult.build(self, @document, @key, @document[@key])
        else
            return CommandResult.build(self, @document, nil, nil)
        end
    end
end




