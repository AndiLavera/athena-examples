require "athena"

class HomeController < ART::Controller
  @[ARTA::Get("/")]
  def index : ART::Response
    html = <<-STR
    <!DOCTYPE html>
    <html>
    <head>
      <meta content="text/html;charset=utf-8" http-equiv="Content-Type">
      <meta content="utf-8" http-equiv="encoding">
      <link rel="stylesheet" href="styles.css">
      <script src="index.js" type="module" defer></script>
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
    </html>
    STR

    ART::Response.new(
      html,
      status: 200,
      headers: HTTP::Headers{"content-type" => "text/html;"}
    )
  end
end
