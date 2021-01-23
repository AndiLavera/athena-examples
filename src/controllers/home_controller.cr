require "athena"

class HomeController < ART::Controller
  @[ARTA::Get("/")]
  def index : ART::Response
    html = <<-STR
    <head>
      <link rel="stylesheet" href="styles.css">
      <script src="actioncable.js"></script> 
      <script src="index.js" defer></script> 
    <head>
    <body>
      <h1>Chat app</h1>
      <form>
        <input id="message" type="text"/>
        <button type="submit">Submit</button>
      </form>
      <br />
      <br />

      <h3>Messages</h3>
      <div id="chat-log">
      </div>
    <body>
    STR

    ART::Response.new(
      html,
      status: 200,
      headers: HTTP::Headers{"content-type" => "text/html;"}
    )
  end
end
