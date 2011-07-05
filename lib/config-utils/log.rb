module Log
    def log
        return $log
    end

    def self.log_init
        $log = Logger.new(STDERR)
        $log.level = Logger::WARN
        $log.formatter = proc { |severity, datetime, progname, msg| "#{severity}: #{msg}\n" }
    end
end

