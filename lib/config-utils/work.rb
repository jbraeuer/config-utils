class WorkItem
    attr_accessor :docpath, :op, :args

    def initialize(docpath, op, *args)
        raise "docpath must not be empty" if docpath.nil? or docpath.empty?
        raise "op must be symbol" unless op.is_a? Symbol
        @docpath, @op, @args = docpath, op, args
    end

    def to_s
        return "<#{super.to_s}:#{@docpath}:#{@op}:#{@args.join(":")}>"
    end
end
