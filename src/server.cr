require "athena"

require "./controllers/*"
require "./listeners/*"

require "./websockets/cable"
require "./websockets/connection"
require "./websockets/chat_channel"

require "snowpacker"
require "snowpacker/ext/athena"

Snowpacker::Engine.configure do |config|
  config.enabled = ENV["ATHENA_ENV"]? == "development"
end

Snowpacker::Engine.run

# Run the server
ART.run
