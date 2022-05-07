class WebhookEventHandler
  @access_token : SlackAccessToken

  getter team_id, access_token

  def self.handle_event(event : Slack::Event)
    new(event.team_id.not_nil!).process(event)
  end

  def initialize(@team_id : String)
    @access_token = SlackAccessTokenQuery
      .new
      .join_slack_team
      .where_slack_team(SlackTeamQuery.new.slack_id(@team_id))
      .created_at
      .desc_order
      .first
  end

  def process(event)
    Log.info { "Did not process: #{event.type}" }
  end

  def process(message : Slack::Events::Message::FileShare)
    WebhookTriggers::MessageFileShared
      .new(message, access_token)
      .process
  end

  def process(message : Slack::Events::Message)
    WebhookTriggers::MessagePosted
      .new(message, access_token)
      .process
  end

  def process(reaction : Slack::Events::ReactionAdded)
    WebhookTriggers::ReactionAdded
      .new(reaction, access_token)
      .process
  end
end
