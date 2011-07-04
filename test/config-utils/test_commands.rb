class TestCommand < MiniTest::Unit::TestCase
    def test_set
        d = { }
        k = "key"
        v = "value"

        c = SetCommand.new(d, k, v)
        r = c.run

        assert(r == v)
        assert(d.has_key?(k))
        assert(d[k] = v)
    end

    def test_get
        k = "key"
        v = "value"
        d = { k => v }

        c = GetCommand.new(d, k)
        r = c.run

        assert(r == v)
    end
end
