class SlackTeam < BaseModel
  include JSON::Serializable

  table do
    column slack_id : String
    column name : String
    has_many slack_access_tokens : SlackAccessToken
  end
end
