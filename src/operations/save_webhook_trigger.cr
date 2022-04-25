class SaveWebhookTrigger < WebhookTrigger::SaveOperation
  upsert_lookup_columns :slack_team_id, :event_type, :action
end
