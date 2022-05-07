require "./app"
require "opentelemetry-instrumentation"
require "opentelemetry-instrumentation/src/opentelemetry/instrumentation/**"

Habitat.raise_if_missing_settings!

OpenTelemetry.configure do |config|
  config.service_name = ENV["OPENTEL_APP_NAME"]? || "hirobot.app"
  config.service_version = "v0.0.1"
  config.exporter = OpenTelemetry::Exporter.new(variant: :http) do |exporter|
    exporter = exporter.as(OpenTelemetry::Exporter::Http)
    exporter.endpoint = "https://otlp.nr-data.net:4318/v1/traces"
    headers = HTTP::Headers.new
    headers["api-key"] = ENV["NEW_RELIC_LICENSE_KEY"]?.to_s
    exporter.headers = headers
  end
end

if LuckyEnv.development?
  Avram::Migrator::Runner.new.ensure_migrated!
  Avram::SchemaEnforcer.ensure_correct_column_mappings!
end

app_server = AppServer.new

Signal::INT.trap do
  app_server.close
end

app_server.listen
