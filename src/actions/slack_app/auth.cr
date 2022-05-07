class SlackAuth < BrowserAction
  include Auth::AllowGuests

  get "/slack/auth" do
    auth_response = Slack::AuthHandler.run(request)
    slack_team = SaveSlackTeam.upsert!(
      name: auth_response.team.name,
      slack_id: auth_response.team.id
    )

    SaveSlackAccessToken.create!(
      slack_team_id: slack_team.id,
      token: auth_response.access_token,
      json_body: JSON.parse(auth_response.to_json)
    )

    redirect to: Home::Index
  end
end
