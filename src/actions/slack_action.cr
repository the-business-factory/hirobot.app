abstract class SlackAction < Lucky::Action
  include Lucky::EnforceUnderscoredRoute
  include Slack::UI::BaseComponents

  disable_cookies
  accepted_formats [:json]
end
