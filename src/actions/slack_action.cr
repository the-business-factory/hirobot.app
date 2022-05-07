abstract class SlackAction < Lucky::Action
  include Lucky::EnforceUnderscoredRoute
  include Slack::UI::BaseComponents

  disable_cookies
  accepted_formats [:json]

  private def trace(span_name)
    PerformanceTrace.trace(span_name) { yield }
  end
end
