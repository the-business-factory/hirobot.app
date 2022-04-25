require "./app"
require "opentelemetry-instrumentation"
require "opentelemetry-instrumentation/src/opentelemetry/instrumentation/**"

Habitat.raise_if_missing_settings!

OpenTelemetry.configure do |config|
  config.service_name = "hirobot.app"
  config.service_version = "v0.0.1"
  config.exporter = OpenTelemetry::Exporter.new(variant: :http) do |exporter|
    exporter = exporter.as(OpenTelemetry::Exporter::Http)
    exporter.endpoint = "https://otlp.nr-data.net:4318/v1/traces"
    headers = HTTP::Headers.new
    headers["api-key"] = ENV["NEW_RELIC_LICENSE_KEY"]?.to_s
    exporter.headers = headers
  end
end

spawn(name: "GC Span Recording") do
  loop do
    stats = GC.prof_stats
    OpenTelemetry.trace.in_span("GC Stats") do |span|
      span["bytes_before_gc"] = stats.bytes_before_gc
      span["bytes_reclaimed_sinc_gc"] = stats.bytes_reclaimed_since_gc
      span["bytes_since_gc"] = stats.bytes_since_gc
      span["free_bytes"] = stats.free_bytes
      span["gc_no"] = stats.gc_no
      span["heap_size"] = stats.heap_size
      span["markers_m1"] = stats.markers_m1
      span["non_gc_bytes"] = stats.non_gc_bytes
      span["reclaimed_bytes_before_gc"] = stats.reclaimed_bytes_before_gc
      span["unmapped_bytes"] = stats.unmapped_bytes
    end

    sleep 30
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
