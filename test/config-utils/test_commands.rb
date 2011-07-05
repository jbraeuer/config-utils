class TestCommand < MiniTest::Unit::TestCase
    def check_result(r)
        [:command, :document, :key, :value].each do |k|
            assert(r.has_key?(k))
        end
    end

    def check_keyvalue(r, k, v)
        assert(r[:key] == k)
        assert(r[:value] == v)
    end

    def test_set
        d = { }
        k = "key"
        v = "value"

        c = SetCommand.new(d, k, v)
        r = c.run

        check_result r
        check_keyvalue r, k, v
    end

    def test_get
        k = "key"
        v = "value"
        d = { k => v }

        c = GetCommand.new(d, k)
        r = c.run

        check_result r
        check_keyvalue r, k, v
    end

    def test_append_stringarray
        d = { "key" => "value1" }

        c = AppendCommand.new(d, "key", "value2")
        r = c.run

        check_result r
        check_keyvalue r, "key", ["value1", "value2"]
    end

    def test_del_key
        d = { "key" => "value1" }

        c = DelCommand.new(d, "key", nil)
        r = c.run

        check_result r
        check_keyvalue r, nil, nil
        assert(! d.has_key?("key"))
    end

    def test_del_keyvalue_ok
        d = { "key" => "value1" }

        c = DelCommand.new(d, "key", "value1")
        r = c.run

        check_result r
        check_keyvalue r, nil, nil
        assert(! d.has_key?("key"))
    end

    def test_del_keyvalue_oklist
        d = { "key" => ["value", "value", "value"] }

        c = DelCommand.new(d, "key", "value")
        r = c.run

        check_result r
        check_keyvalue r, nil, nil
        assert(! d.has_key?("key"))
    end


    def test_del_keyvalue_fail
        d = { "key" => "value1" }

        c = DelCommand.new(d, "key", "bla")
        r = c.run

        check_result r
        check_keyvalue r, "key", "value1"
    end

    def test_del_keyvalue_regexp_all
        d = { "key" => ["value1", "value2"] }

        c = DelCommand.new(d, "key", "/alue/")
        r = c.run

        check_result r
        check_keyvalue r, nil, nil
    end

    def test_del_keyvalue_regexp_part
        d = { "key" => ["value1", "foobar", "value2"] }

        c = DelCommand.new(d, "key", "/alue/")
        r = c.run

        check_result r
        check_keyvalue r, "key", "foobar"
    end

    def test_del_keyvalue_regexp_partlist
        d = { "key" => ["value1", "foo", "bar", "value2"] }

        c = DelCommand.new(d, "key", "/alue/")
        r = c.run

        check_result r
        check_keyvalue r, "key", ["foo", "bar"]
    end
end

class TestCommandWorkItem < MiniTest::Unit::TestCase
    def test_unknown_raises
        store = { "path/" => {} }
        w = WorkItem.new("/path/", :foo)
        assert_raises(RuntimeError) { CommandFactory.fromWorkItem(store, w) }
    end

    def test_get
        store = { "path/" => {} }
        w = WorkItem.new("path/", :get)
        c = CommandFactory.fromWorkItem(store, w)
        assert(c.is_a?(GetCommand))
    end

    def test_set
        store = { "path/" => {} }
        w = WorkItem.new("path/", :set, "hallo", "welt")
        c = CommandFactory.fromWorkItem(store, w)
        assert(c.is_a?(SetCommand))
    end

    def test_append
        store = { "path/" => {} }
        w = WorkItem.new("path/", :append, "hallo", "welt")
        c = CommandFactory.fromWorkItem(store, w)
        assert(c.is_a?(AppendCommand))
    end

    def test_del
        store = { "path/" => {} }
        w = WorkItem.new("path/", :del, "hallo", "welt")
        c = CommandFactory.fromWorkItem(store, w)
        assert(c.is_a?(DelCommand))
    end
end
