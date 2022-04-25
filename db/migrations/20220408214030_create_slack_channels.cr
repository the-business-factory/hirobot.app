class CreateSlackChannels::V20220408214030 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(SlackChannel) do
      primary_key id : Int64
      add name : String
      add_belongs_to slack_team : SlackTeam, on_delete: :cascade
      add slack_id : String
      add_timestamps
    end

    create_index :slack_channels,
      [:slack_team_id, :slack_id],
      name: "unique_channel_per_team",
      unique: true
  end

  def rollback
    drop table_for(SlackChannel)
  end
end
