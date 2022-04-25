class WebhookTrigger < BaseModel
  include JSON::Serializable

  table do
    belongs_to slack_team : SlackTeam
    belongs_to slack_channel : SlackChannel?
    column event_type : WebhookTriggerEvent
    column action : WebhookTriggerAction
    column conditions : TriggerConditions?, serialize: true
  end
end
