class Document < Hash
    attr_reader :path
    def initialize(path, values=nil)
        @path = path
        unless values.nil?
            values.each { |k,v| self[k] = v }
        end
    end
end

