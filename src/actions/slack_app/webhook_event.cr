class SlackWebhookEvent < SlackAction
  post "/slack/webhook_events" do
    event_payload = Slack.process_webhook(request)
    case event_payload
    when Slack::UrlVerification
      json(event_payload.response)
    else
      WebhookEventHandler.handle_event(event_payload.event)
      json({ok: true})
    end
  rescue exc
    Raven.capture(exc) do |event|
      event.extra.merge!(
        json: Hash(String, JSON::Any).from_json(request.body.to_s)
      )
    end

    json({ok: true})
  end
end
