class CreateSlackTeams::V20220408203820 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(SlackTeam) do
      primary_key id : Int64
      add slack_id : String, unique: true
      add name : String
      add_timestamps
    end
  end

  def rollback
    drop table_for(SlackTeam)
  end
end
