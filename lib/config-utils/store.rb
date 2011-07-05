require 'json'
require 'git_store'

class JSONHandler
    def read(path)
        JSON.load(path)
    end

    def write(path, data)
        data.to_json
    end
end

class DKVStore < GitStore
    def initialize(path, branch='master', bare=false)
        super(path, branch, bare)
        @handler['json'] = JSONHandler.new
    end

    def [](path)
        super(path + ".json")
    end

    def []=(path, data)
        super(path + ".json", data)
    end
end
