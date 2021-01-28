require "athena"

require "./controllers/*"
require "./listeners/*"

require "snowpacker"
require "snowpacker/ext/athena"

Snowpacker::Engine.configure do |config|
  config.enabled = ENV["ATHENA_ENV"]? == "development"
end

Snowpacker::Engine.run

# Run the server
ART.run
