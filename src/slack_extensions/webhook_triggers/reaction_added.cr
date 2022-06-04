class WebhookTriggers::ReactionAdded
  @team_id : String
  @channel_id : String

  getter reaction, team_id, channel_id

  def initialize(@reaction : Slack::Events::ReactionAdded)
    @team_id = @reaction.team_id.not_nil!
    @channel_id = reaction.item.channel
  end

  def triggers
    TriggerTokenQuery
      .new
      .event_type(WebhookTriggerEvent::ReactionAdded)
      .team_identifier(team_id)
      .channel_identifier(channel_id)
  end

  def process
    PerformanceTrace.trace(self.class.name) do
      triggers.each do |trigger|
        case trigger.action
        when WebhookTriggerAction::DeleteBotMessage
          delete_bot_message(trigger) if conditions_met?(trigger)
        end
      end
    end
  end

  def conditions_met?(trigger)
    conditions = trigger.conditions
    return true if conditions.nil?

    case conditions.field
    when "reaction"
      conditions.value == reaction.reaction
    else
      false
    end
  end

  private def delete_bot_message(trigger : TriggerToken)
    return unless trigger.bot_user_id == reaction.item_user

    spawn do
      PerformanceTrace.trace("Slack API: ChatDelete") do
        Slack::Api::ChatDelete.new(
          channel: channel_id,
          token: trigger.bot_token,
          ts: reaction.item.ts
        ).call
      end
    end
  end
end
