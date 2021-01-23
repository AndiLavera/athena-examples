require "cable"

Cable.configure do |settings|
  settings.route = "/cable" # the URL your JS Client will connect
  settings.token = "token"  # The query string parameter used to get the token
end
