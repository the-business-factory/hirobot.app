class WebhookTriggers::MessageFileShared
  @team_id : String
  @channel_id : String

  getter message, team_id, channel_id

  def initialize(@message : Slack::Events::Message::FileShare)
    @team_id = @message.team_id.not_nil!
    @channel_id = @message.channel
  end

  def triggers
    TriggerTokenQuery
      .new
      .event_type(WebhookTriggerEvent::MessageFileShared)
      .team_identifier(team_id)
      .channel_identifier(channel_id)
  end

  def process
    spawn do
      CacheChannelInfo.new(channel_id: channel_id, team_id: team_id).run
    end

    PerformanceTrace.trace(self.class.name) do
      triggers.each do |trigger|
        case trigger.action
        when WebhookTriggerAction::PostJobListingBestPractices
          listing_best_practices(trigger.bot_token)
        end
      end
    end
  end

  private def listing_best_practices(token : String)
    return if message.thread?

    spawn do
      PerformanceTrace.trace("Slack API: ChatPostMessage") do
        Slack::Api::ChatPostMessage.post_blocks(
          token: token,
          blocks: SlackComponents::JobInfoResponse.render(message.user),
          channel: channel_id,
          thread_ts: message.ts.to_json
        )
      end
    end
  end
end
