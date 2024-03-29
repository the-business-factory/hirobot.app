# Load .env file before any other config or app code
require "lucky_env"
LuckyEnv.load?(".env")

# Require your shards here
require "raven"
require "raven/integrations/lucky"
require "avram"
require "lucky"
require "avram/lucky"
require "carbon"
require "authentic"
require "jwt"
require "slack"
require "slack/oauth"
