require 'git_store'
require 'pp'
require 'json'

class KVStore
    # static methods
    def self.serialize(value)
        if value.is_a? Array
            value.to_json + "\n"
        else
            serialize([value])
        end
    end

    def self.unserialize(raw)
        return [] if raw.nil? or raw.empty?
        JSON.parse(raw)
    end

    def initialize(store, items, options, log)
        @store, @items, @options, @log = store, items, options, log
    end

    def run
        @store.start_transaction
        @items.each do |item|
            @log.debug "handle item #{item.mode},#{item.key},#{item.value}"
            case item.mode
            when :get
                result << get(item)
            when :set
                result << set(item)
            when :append
                result << append(item, item.value)
            when :del
                result << del(item, item.value)
            when :listkeys
                keys = listkeys(item.key)
            when :list
                listkeys(item.key).each do |key|
                    render(item.key, get(key))
                end
            end

            if [:get, :set, :del, :append].include?(item.mode)
                @log.debug "#{item.mode}: #{item.key}=#{item.value}"
                @log.debug "store: #{@store[item.key]}"
            end
        end

        if @store.root.modified?
            commit = @store.commit @options[:commitmsg]
            @log.info "Commit done: #{commit.id}"
        end
        @store.finish_transaction
        result
    end

    private
    def get(item)
        item.value = KVStore.unserialize(@store[item.key])
        item
    end

    def set(item)
        if item.value.nil? or item.value.empty?
            @store.delete(key)
        else
            @store[item.key] = KVStore.serialize(item.value)
        end
    end

    def del(item, value)
        values = get(item)
        matcher = value.match("^/\(.*\)/$")
        if matcher
            regexp = Regexp.new(matcher[1])
            values = values.reject {|element| regexp.match(element) }
        else
            values = values.reject {|element| element == value}
        end
        item.value = values
        set(item)
    end

    def append(item, value)
        get(item).value << value
        set(item)
    end

    def listkeys(key)
        paths = @store.paths
        unless key.nil? or key.empty?
            paths = paths.find_all {|p| p.index(key) == 0 }
        end
        paths
    end
end
