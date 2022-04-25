class SaveSlackChannel < SlackChannel::SaveOperation
  upsert_lookup_columns :slack_team_id, :slack_id
end
