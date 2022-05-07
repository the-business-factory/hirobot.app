class SlackAccessToken < BaseModel
  include JSON::Serializable

  table do
    belongs_to slack_team : SlackTeam
    column token : String
    column expires_at : Time?
    column json_body : Slack::AuthResponse, serialize: true
  end
end
