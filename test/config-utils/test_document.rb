class TestDocument < MiniTest::Unit::TestCase
    def test_get
        d = Document.new("foo", {5 => 6})
        assert(d[5] == 6)
    end

    def test_set
        d = Document.new("foo")
        d[5] = 6
        assert(d[5] == 6)
    end

    def test_path
        d = Document.new("foo")
        assert(d.path == "foo")
    end
end
