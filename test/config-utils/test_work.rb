class TestWorkItem < MiniTest::Unit::TestCase
    def test_item
        wi = WorkItem.new("foo", :get, 1, 2, 3)
        assert(wi.docpath == "foo")
        assert(wi.op == :get)
        assert(wi.args = [1,2,3])
    end

    def test_constructor
        assert_raises(RuntimeError) { WorkItem.new("foo", "get", 1, 2, 3) }
    end
end
