class SlackAuth < BrowserAction
  include Auth::AllowGuests

  get "/slack/auth" do
    auth_response = PerformanceTrace.trace("Slack API") do
      Slack::AuthHandler.run(request)
    end

    slack_team = SaveSlackTeam.upsert!(
      name: auth_response.team.name,
      slack_id: auth_response.team.id
    )

    SaveSlackAccessToken.create!(
      slack_team_id: slack_team.id,
      token: auth_response.access_token,
      json_body: auth_response
    )

    spawn { TriggerToken.refresh }

    redirect to: Home::Index
  end
end
