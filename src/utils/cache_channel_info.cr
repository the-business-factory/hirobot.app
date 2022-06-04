# CacheChannelInfo caches a channel's name as a SlackChannel record; this allows
# for user-friendly channel names to be used in place of channel IDs.
class CacheChannelInfo
  getter channel_id, team_id

  def initialize(@channel_id : String, @team_id : String)
  end

  def run : SlackChannel?
    PerformanceTrace.trace("Caching Channel Info") { run! }
  end

  private def run!
    channel = SlackChannelQuery.new.slack_id(channel_id).first?

    return channel if channel

    return unless token = SlackAccessTokenQuery
                    .new
                    .join_slack_team
                    .where_slack_team(SlackTeamQuery.new.slack_id(team_id))
                    .preload_slack_team
                    .created_at
                    .desc_order
                    .first?

    conversation = PerformanceTrace.trace("Slack API: ConversationsInfo") do
      Slack::Api::ConversationsInfo.new(token.token, channel_id).call
    end

    case conversation
    when Slack::Models::PublicChannel
      SaveSlackChannel.upsert!(
        name: conversation.name,
        slack_id: channel_id,
        slack_team_id: token.slack_team.id,
      )
    end
  end
end
