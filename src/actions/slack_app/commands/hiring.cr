class SlackHiring < SlackAction
  # The application has been configured to eventually allow for a /hiring
  # command to post jobs to a community hiring board + channel alert.
  #
  # Currently, this a no-op. It will require additional support to be added to
  # the slack.cr library for different ways of handling Interactions.
  post "/slack/hiring" do
    command = Slack.process_command(request)

    clippy = TextSection.render(text: "👀 📎 It looks like you're trying to post a job. Would you like help?")

    location = InputElement.render(
      action_id: "location",
      placeholder_text: "e.g. Seattle (Remote OK)",
      label_text: "Location"
    )

    compensation = InputElement.render(
      action_id: "compensation",
      placeholder_text: "e.g. $170,000-$220,000",
      label_text: "Compensation"
    )

    description = InputElement.render(
      action_id: "description",
      label_text: "Description",
      placeholder_text: "e.g. Full Stack, Backend, Frontend, Leadership... what does your team need help with?",
      multiline: true
    )

    access_token = SlackAccessTokenQuery
      .new
      .created_at
      .desc_order
      .first

    spawn do
      Slack::Helpers::Modal.open(
        access_token: access_token.token,
        title: "Post a Job",
        submit: "Post",
        close: "Cancel",
        blocks: [clippy, location, compensation, description],
        trigger_id: command.trigger_id
      )
    end

    head :ok
  end
end
