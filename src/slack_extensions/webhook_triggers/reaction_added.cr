class WebhookTriggers::ReactionAdded
  getter reaction, access_token

  def initialize(@reaction : Slack::Events::ReactionAdded,
                 @access_token : SlackAccessToken)
  end

  def triggers
    WebhookTriggerQuery.trigger_for(
      event_type: WebhookTriggerEvent::ReactionAdded,
      team_id: reaction.team_id.not_nil!,
      channel: reaction.item.channel
    )
  end

  def process
    triggers.each do |trigger|
      case trigger.action
      when WebhookTriggerAction::DeleteBotMessage
        delete_bot_message if conditions_met?(trigger)
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

  private def delete_bot_message
    bot_id = access_token.json_body["bot_user_id"]

    return unless bot_id == reaction.item_user

    spawn do
      Slack::Api::ChatDelete.new(
        channel: reaction.item.channel,
        token: access_token.token,
        ts: reaction.item.ts
      ).call
    end
  end
end
