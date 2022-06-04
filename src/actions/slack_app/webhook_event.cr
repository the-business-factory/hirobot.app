class SlackWebhookEvent < SlackAction
  post "/slack/webhook_events" do
    payload = trace("Processing Webhook") { Slack.process_webhook(request) }

    case payload
    when Slack::UrlVerification
      json(payload.response)
    else
      trace("Handling Event") { WebhookEventHandler.handle_event(payload.event) }
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
