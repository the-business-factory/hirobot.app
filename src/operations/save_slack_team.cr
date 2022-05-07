class SaveSlackTeam < SlackTeam::SaveOperation
  upsert_lookup_columns :slack_id
end
