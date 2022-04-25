struct TriggerConditions
  include JSON::Serializable
  include Slack::InitializerMacros

  properties_with_initializer field : String, value : String
end
