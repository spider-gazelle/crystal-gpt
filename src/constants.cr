require "action-controller/logger"
require "yaml"

module App
  struct Shard
    include YAML::Serializable

    getter name : String
    getter version : String
    getter description : String?
  end

  {% begin %}
    SHARD = Shard.from_yaml({{read_file("./shard.yml").split("\n").select { |row| row.starts_with?("version:") || row.starts_with?("name:") || row.starts_with?("description:") }.join("\n")}})
  {% end %}
  NAME        = SHARD.name
  VERSION     = SHARD.version
  DESCRIPTION = SHARD.description

  Log         = ::Log.for(NAME)
  LOG_BACKEND = ActionController.default_backend

  ENVIRONMENT   = ENV["SG_ENV"]? || "development"
  IS_PRODUCTION = ENVIRONMENT == "production"

  DEFAULT_PORT          = (ENV["SG_SERVER_PORT"]? || 3000).to_i
  DEFAULT_HOST          = ENV["SG_SERVER_HOST"]? || "127.0.0.1"
  DEFAULT_PROCESS_COUNT = (ENV["SG_PROCESS_COUNT"]? || 1).to_i

  STATIC_FILE_PATH = ENV["PUBLIC_WWW_PATH"]? || "./www"

  COOKIE_SESSION_KEY    = ENV["COOKIE_SESSION_KEY"]? || "_spider_gazelle_"
  COOKIE_SESSION_SECRET = ENV["COOKIE_SESSION_SECRET"]? || "4f74c0b358d5bab4000dd3c75465dc2c"

  def self.running_in_production?
    IS_PRODUCTION
  end

  # flag to indicate if we're outputting trace logs
  class_getter? trace : Bool = false

  # Registers callbacks for USR1 signal
  #
  # **`USR1`**
  # toggles `:trace` for _all_ `Log` instances
  # `namespaces`'s `Log`s to `:info` if `production` is `true`,
  # otherwise it is set to `:debug`.
  # `Log`'s not registered under `namespaces` are toggled to `default`
  #
  # ## Usage
  # - `$ kill -USR1 ${the_application_pid}`
  def self.register_severity_switch_signals : Nil
    # Allow signals to change the log level at run-time
    Signal::USR1.trap do |signal|
      @@trace = !@@trace
      level = @@trace ? ::Log::Severity::Trace : (running_in_production? ? ::Log::Severity::Info : ::Log::Severity::Debug)
      puts " > Log level changed to #{level}"
      ::Log.builder.bind "#{NAME}.*", level, LOG_BACKEND

      # Ignore standard behaviour of the signal
      signal.ignore

      # we need to re-register our interest in the signal
      register_severity_switch_signals
    end
  end
end
