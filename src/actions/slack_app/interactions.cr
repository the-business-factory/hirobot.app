class SlackInteraction < SlackAction
  # The application has been configured to eventually allow for a /hiring
  # command to post jobs to a community hiring board + channel alert. This,
  # and other UI blocks posted by the application will send interactions to this
  # endpoint.
  #
  # Currently, this a no-op. It will require additional support to be added to
  # the slack.cr library for different ways of handling Interactions.
  post "/slack/interactions" do
    head :ok
  end
end
