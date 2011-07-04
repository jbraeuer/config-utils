require 'git_store'
require 'pp'
require 'json'

class Item
    attr_accessor :mode, :key, :value
    def initialize(mode, key, value=nil)
        @mode, @key, @value = mode, key, value
    end
end

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
                get_and_print(item.key)
            when :set
                set(item.key, item.value)
            when :append
                append(item.key, item.value)
            when :del
                del(item.key, item.value)
            when :listkeys
                keys = listkeys(item.key)
                puts keys
            when :list
                listkeys(item.key).each do |key|
                    get_and_print(key)
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
    end

    private
    def get(key)
        KVStore.unserialize(@store[key])
    end

    def get_and_print(key)
        value = get(key)
        start = "#{key}="
        start = "" if @options[:raw]
        if value.nil? or value.empty?
            puts "#{start}"
        else
            puts "#{start}#{value.join(@options[:separator])}"
        end
    end

    def set(key, value)
        @store[key] = KVStore.serialize(value)
    end

    def del(key, value=nil)
        if value.nil? or value.empty?
            @store.delete(key)
        else
            values = get(key)
            matcher = value.match("^/\(.*\)/$")
            if matcher
                regexp = Regexp.new(matcher[1])
                values = values.reject {|element| regexp.match(element) }
            else
                values = values.reject {|element| element == value}
            end
            @store[key] = KVStore.serialize(values)
        end
    end

    def append(key, value)
        values = get(key)
        if values.nil?
            set(key, value)
        else
            values << value
            @store[key] = KVStore.serialize(values)
        end
    end

    def listkeys(key)
        paths = @store.paths
        unless key.nil? or key.empty?
            paths = paths.find_all {|p| p.index(key) == 0 }
        end
        paths
    end
end
