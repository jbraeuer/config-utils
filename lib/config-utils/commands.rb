class CommandFactory
    def self.fromWorkItem(store, item)
        if [:get, :set, :append, :del, :listkeys, :listkeyvalues].include? item.op
            CommandFactory.toDocumentCommand store, item
        elsif [:listdocs].include? item.op
            CommandFactory.toStoreCommand store, item
        else
            raise "Unsupported workitem operation: #{item.op}"
        end
    end

    private
    def self.toStoreCommand(store, item)
        case item.op
        when :listdocs
            ListdocsStoreCommand.new item.op, store
        end
    end

    def self.toDocumentCommand(store, item)
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
        when :listkeys
            ListkeysCommand.new(document, item.args[0])
        when :listkeyvalues
            ListkeyvaluesCommand.new(document, item.args[0])
        end
    end
end

class StoreCommandResult < Array
    def render(options)
        self.sort
    end
end

class StoreCommand
    def initialize(op, store)
        raise "Op must by symbol." unless op.is_a? Symbol
        raise "Command can't operate without store." if store.nil?
        @op, @store = op, store
    end
end

class ListdocsStoreCommand < StoreCommand
    def run
        docs = @store.paths.map { |p| p.gsub(".json", "") }
        StoreCommandResult.new.concat docs
    end
end

class DocumentCommandResult < Hash
    def self.build(command, document, key, value)
        DocumentCommandResult.new.merge( {
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
        [ "#{prefix}#{values.join(options[:separator])}" ]
    end
end

class DocumentCommand
    def initialize(document, key, value=nil)
        raise "Command cant operate without document." if document.nil?
        @document, @key, @value = document, key, value
    end

    def to_s
        return "<#{super.to_s}:#{@document.path}:#{@key}:#{@value}>"
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

class GetCommand < DocumentCommand
    def run
        value = @document[@key]
        DocumentCommandResult.build(self, @document, @key, value)
    end
end

class SetCommand < DocumentCommand
    def run
        @document[@key] = @value
        DocumentCommandResult.build(self, @document, @key, @value)
    end
end

class AppendCommand < DocumentCommand
    def run
        if @document[@key].is_a? Array
            @document[@key] << @value
        else
            @document[@key] = [@document[@key], @value]
        end
        DocumentCommandResult.build(self, @document, @key, @document[@key])
    end
end

class DelCommand < DocumentCommand
    def run
        if @value.nil? or ! @document.has_key?(@key)
            set(@value)
            return DocumentCommandResult.build(self, @document, @key, nil)
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
        return DocumentCommandResult.build(self, @document, @key, @document[@key])
    end
end

class ListCommandResult
    def initialize(document, options={})
        @document, @options = document, options
    end

    def render(options)
        @document.map do |k,v|
            if @options[:showvalues]
                "#{v}=#{k}"
            else
                "#{k}"
            end
        end
    end
end

class ListkeysCommand < DocumentCommand
    def run
        ListCommandResult.new @document
    end
end

class ListkeyvaluesCommand < DocumentCommand
    def run
        ListCommandResult.new @document, :showvalues => true
    end
end



