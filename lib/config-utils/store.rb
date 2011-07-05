require 'json'
require 'git_store'

class JSONHandler
    def read(path)
        JSON.load(path)
    end

    def write(data)
        data.to_json
    end
end

class DKVStore
    def initialize(path)
        @store = GitStore.new(path)
        @store.handler['json'] = JSONHandler.new
    end

    def [](path)
        @store[path + ".json"]
    end

    def []=(path, data)
        @store[path + ".json"] = data
    end

    def method_missing(m, *args, &block)
        @store.send(m, *args, &block)
    end

end
