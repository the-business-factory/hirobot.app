class WebhookEventHandler
  def self.handle_event(event : Slack::Event)
    new.process(event)
  end

  def process(event)
    Log.info { "Did not process: #{event.type}" }
  end

  def process(message : Slack::Events::Message::FileShare)
    WebhookTriggers::MessageFileShared.new(message).process
  end

  def process(message : Slack::Events::Message)
    WebhookTriggers::MessagePosted.new(message).process
  end

  def process(reaction : Slack::Events::ReactionAdded)
    WebhookTriggers::ReactionAdded.new(reaction).process
  end
end
