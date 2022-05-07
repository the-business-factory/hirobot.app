class CreateSlackAccessTokens::V20220408213624 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(SlackAccessToken) do
      primary_key id : Int64
      add_belongs_to slack_team : SlackTeam, on_delete: :cascade
      add token : String
      add expires_at : Time?
      add json_body : JSON::Any
      add_timestamps
    end
  end

  def rollback
    drop table_for(SlackAccessToken)
  end
end
