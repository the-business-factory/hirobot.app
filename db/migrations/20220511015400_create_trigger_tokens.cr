class CreateTriggerTokens::V20220511015400 < Avram::Migrator::Migration::V1
  def migrate
    execute <<-SQL
      CREATE MATERIALIZED VIEW trigger_tokens AS
      SELECT DISTINCT ON (
          webhook_triggers.action,
          webhook_triggers.event_type,
          webhook_triggers.slack_channel_id,
          slack_access_tokens.slack_team_id
        ) slack_access_tokens.token as bot_token,
        slack_access_tokens.json_body::json->'bot_user_id' AS bot_user_id,
        slack_access_tokens.json_body::json->'authed_user'->'access_token' AS user_token,
        webhook_triggers.event_type,
        webhook_triggers.action,
        webhook_triggers.conditions,
        slack_channels.slack_id AS channel_identifier,
        slack_teams.slack_id AS team_identifier
      FROM webhook_triggers
      JOIN slack_teams ON
        slack_teams.id = webhook_triggers.slack_team_id
      JOIN slack_channels ON
      	slack_channels.id = webhook_triggers.slack_channel_id
      JOIN slack_access_tokens ON
        slack_access_tokens.slack_team_id = webhook_triggers.slack_team_id
      ORDER BY
        webhook_triggers.event_type,
        webhook_triggers.action,
        webhook_triggers.slack_channel_id,
        slack_access_tokens.slack_team_id,
        slack_access_tokens.created_at DESC;
    SQL

    execute <<-INDEX_SQL
      CREATE UNIQUE INDEX unique_trigger_type ON trigger_tokens
      (event_type, action, channel_identifier, team_identifier);
    INDEX_SQL
  end

  def rollback
    execute "DROP MATERIALIZED VIEW trigger_tokens;"
  end
end
