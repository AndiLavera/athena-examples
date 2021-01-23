require "athena"

require "./controllers/*"
require "./listeners/*"

require "./websockets/cable"
require "./websockets/connection"
require "./websockets/chat_channel"

# Run the server
ART.run
