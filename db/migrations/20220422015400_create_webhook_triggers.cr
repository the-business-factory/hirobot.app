class CreateWebhookTriggers::V20220422015400 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(WebhookTrigger) do
      primary_key id : Int64
      add_belongs_to slack_team : SlackTeam, on_delete: :cascade
      add_belongs_to slack_channel : SlackChannel?, on_delete: :cascade
      add event_type : Int32
      add action : Int32
      add conditions : JSON::Any?

      add_timestamps
    end

    create_index :webhook_triggers,
      [:slack_team_id, :slack_channel_id, :event_type, :action],
      name: "unique_webhook_trigger_idx",
      unique: true
  end

  def rollback
    drop table_for(WebhookTrigger)
  end
end
