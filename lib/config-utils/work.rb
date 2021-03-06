class WorkItem
    attr_accessor :docpath, :op, :args

    def initialize(op, *args)
        raise "op must be symbol" unless op.is_a? Symbol
        @op, @docpath, @args = op, args[0], args[1, args.length]
    end

    def to_s
        args = ""
        args = @args.join(":") unless @args.nil?
        return "<#{super.to_s}:#{@docpath}:#{@op}:#{args}>"
    end
end
