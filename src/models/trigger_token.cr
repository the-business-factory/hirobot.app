class TriggerToken < BaseModel
  skip_default_columns
  skip_schema_enforcer

  view do
    column event_type : WebhookTriggerEvent
    column action : WebhookTriggerAction
    column conditions : TriggerConditions?, serialize: true
    column team_identifier : String
    column channel_identifier : String
    column bot_token : String
    column user_token : String?, serialize: true
    column bot_user_id : String, serialize: true
  end

  def self.refresh
    AppDatabase.exec "REFRESH MATERIALIZED VIEW CONCURRENTLY #{table_name}"
  end
end
