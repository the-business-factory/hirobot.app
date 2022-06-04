class WebhookTriggers::MessagePosted
  @team_id : String
  @channel_id : String

  getter message, team_id, channel_id

  def initialize(@message : Slack::Events::Message)
    @team_id = @message.team_id.not_nil!
    @channel_id = @message.channel
  end

  def triggers
    TriggerTokenQuery
      .new
      .event_type(WebhookTriggerEvent::MessagePosted)
      .team_identifier(team_id)
      .channel_identifier(channel_id)
  end

  def process
    spawn do
      CacheChannelInfo.new(channel_id: channel_id, team_id: team_id).run
    end

    PerformanceTrace.trace(self.class.name) do
      triggers.each do |trigger|
        spawn do
          case trigger.action
          when WebhookTriggerAction::DeleteBotMessage
            delete_all_messages(trigger)
          when WebhookTriggerAction::PostJobListingBestPractices
            listing_best_practices(trigger.bot_token)
          end
        end
      end
    end
  end

  private def delete_all_messages(trigger, run_times = 0)
    return if trigger.bot_user_id == message.user
    return unless admin_token = trigger.user_token

    if message.text.strip == ":bomb:"
      spawn do
        messages = Slack::Api::ConversationsHistory
          .new(channel: message.channel, token: trigger.bot_token)
          .call
          .messages

        messages.each_with_index do |msg, i|
          spawn delete_msg!(msg, i, admin_token)
        end
      end
    end
  end

  private def extract_timestamp(msg)
    if msg.subtype == "tombstone"
      msg.latest_reply.to_json
    else
      msg.ts.to_json
    end
  end

  private def delete_msg!(msg, sleep_time : Int32, token : String)
    sleep sleep_time / 2.0
    ts = extract_timestamp(msg)
    PerformanceTrace.trace("Slack API: ChatDelete") do
      Slack::Api::ChatDelete.new(channel: channel_id, token: token, ts: ts).call
    end
  rescue exc : RateLimiter::Timeout
    delete_msg!(msg, 30 + sleep_time, token)
  rescue exc : Slack::Errors::Api
    nil
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
