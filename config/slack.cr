Slack.configure do |config|
  config.bot_scopes = %w(
    app_mentions:read
    channels:history
    channels:read
    chat:write
    chat:write:user
    commands
    groups:history
    groups:read
    im:history
    im:read
    mpim:read
    reactions:read
    team:read
    users:read
  )
  config.client_id = ENV["SLACK_CLIENT_ID"]
  config.client_secret = ENV["SLACK_CLIENT_SECRET"]
  config.signing_secret = ENV["SLACK_SIGNING_SECRET"]
  config.signing_secret_version = "v0"
  config.webhook_delivery_time_limit = 5.minutes
end

Slack::AuthHandler.configure do |config|
  config.oauth_redirect_url = ENV["OAUTH_REDIRECT_URL"]
end

Slack::SignInWithSlack.configure do |config|
  config.sign_in_redirect_url = ENV["SIGN_IN_REDIRECT_URL"]
end
