class WebhookTriggers::MessagePosted
  getter message, access_token

  def initialize(@message : Slack::Events::Message,
                 @access_token : SlackAccessToken)
  end

  def triggers
    WebhookTriggerQuery.trigger_for(
      event_type: WebhookTriggerEvent::MessagePosted,
      team_id: message.team_id.not_nil!,
      channel: message.channel
    )
  end

  def process
    CacheChannelInfo.new(message).run

    triggers.each do |trigger|
      case trigger.action
      when WebhookTriggerAction::PostJobListingBestPractices
        listing_best_practices
      end
    end
  end

  private def listing_best_practices
    return if message.thread?

    spawn do
      Slack::Api::ChatPostMessage.post_blocks(
        token: access_token.token,
        blocks: SlackComponents::JobInfoResponse.render(message.user),
        channel: message.channel,
        thread_ts: message.ts.to_json
      )
    end
  end
end
