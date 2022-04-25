class SlackChannel < BaseModel
  include JSON::Serializable

  table do
    column name : String
    column slack_id : String
    belongs_to slack_team : SlackTeam
  end
end
