class WebhookTriggerQuery < WebhookTrigger::BaseQuery
  def self.trigger_for(event_type : WebhookTriggerEvent,
                       team_id : String,
                       channel : String)
    new
      .event_type(event_type)
      .join_slack_team
      .join_slack_channel
      .where_slack_team(SlackTeamQuery.new.slack_id(team_id))
      .where_slack_channel(SlackChannelQuery.new.slack_id(channel))
  end
end
