class SlackAuth < BrowserAction
  include Auth::AllowGuests

  get "/slack/user_auth" do
    auth_response = Slack::SignInWithSlack.run(request)
    pp auth_response

    # slack_team = SaveSlackTeam.upsert!(
    #   name: auth_response.team.name,
    #   slack_id: auth_response.team.id
    # )

    # SaveSlackAccessToken.create!(
    #   slack_team_id: slack_team.id,
    #   token: auth_response.access_token,
    #   json_body: auth_response
    # )

    # spawn { TriggerToken.refresh }

    redirect to: Home::Index
  end
end
