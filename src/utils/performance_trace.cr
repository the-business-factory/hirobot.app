class PerformanceTrace
  def self.trace(span_name : String, &block)
    {% if @top_level.has_constant?("OpenTelemetry") %}
      OpenTelemetry.trace.in_span(span_name) { yield }
    {% else %}
      yield
    {% end %}
  end
end
