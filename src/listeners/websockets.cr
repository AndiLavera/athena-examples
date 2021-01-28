require "athena"

# Define a new event listener to handle applying this writer
@[ADI::Register]
struct WebsocketListener
  include AED::EventListenerInterface
  private SERVER = Cable::Handler.new(ApplicationCable::Connection)

  def self.subscribed_events : AED::SubscribedEvents
    AED::SubscribedEvents{
      ART::Events::Request => 254,
    }
  end

  def call(event : ART::Events::Request, dispatcher : AED::EventDispatcherInterface) : Nil
    if event.request.path == "/cable"
      res = HTTP::Server::Response.new(IO::Memory.new)
      context = HTTP::Server::Context.new(event.request, res)
      SERVER.call(context)

      athena_response = ART::Response.new(
        headers: res.headers,
        status: res.status_code,
        upgrade_handler: context.response.upgrade_handler
      )

      event.response = athena_response
    end
  end
end
