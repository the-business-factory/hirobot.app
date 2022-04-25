# CacheChannelInfo caches a channel's name as a SlackChannel record; this allows
# for user-friendly channel names to be used in place of channel IDs.
class CacheChannelInfo
  alias Message = Slack::Events::Message

  record Info, name : String, id : String

  @channel : String
  @slack_team : SlackTeam
  @team_id : String

  getter team_id, channel, slack_team

  def initialize(message : Message::FileShare | Message)
    @team_id = message.team_id.not_nil!
    @channel = message.channel
    @slack_team = SlackTeamQuery.new.slack_id(@team_id).first
  end

  def run
    cache = SlackChannelQuery
      .new
      .slack_team_id(slack_team.id)
      .slack_id(channel)
      .first?

    return Info.new(name: cache.name, id: channel) if cache

    access_token = SlackAccessTokenQuery
      .new
      .slack_team_id(slack_team.id)
      .created_at
      .desc_order
      .first

    conversation = Slack::Api::ConversationsInfo
      .new(access_token.token, channel)
      .call

    case conversation
    when Slack::Models::PublicChannel
      SaveSlackChannel.upsert!(
        name: conversation.name,
        slack_id: channel,
        slack_team_id: slack_team.id,
      )

      Info.new(name: conversation.name, id: channel)
    end
  end
end
