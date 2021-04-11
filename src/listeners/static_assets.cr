require "athena"

@[ADI::Register]
struct StaticFileListener
  include AED::EventListenerInterface

  # This could be parameter if the directory changes between environments.
  private PUBLIC_DIR = Path.new("public/dist").expand

  def self.subscribed_events : AED::SubscribedEvents
    # Run this listener with a very high priority so it is invoked before any application logic.
    AED::SubscribedEvents{ART::Events::Request => 100}
  end

  def call(event : ART::Events::Request, _dispatcher : AED::EventDispatcherInterface) : Nil
    # Fallback if the request method isn't intended for files.
    # Alternatively, a 405 could be thrown if the server is dedicated to serving files.
    return unless event.request.method.in? "GET", "HEAD"

    original_path = event.request.path
    request_path = URI.decode original_path

    # File path cannot contains '\0' (NUL).
    if request_path.includes? '\0'
      raise ART::Exceptions::BadRequest.new "File path cannot contain NUL bytes."
    end

    request_path = Path.posix request_path
    expanded_path = request_path.expand "/"

    file_path = PUBLIC_DIR.join expanded_path.to_kind Path::Kind.native

    is_dir = Dir.exists? file_path
    is_dir_path = original_path.ends_with? '/'

    event.response = if request_path != expanded_path || is_dir && !is_dir_path
                       redirect_path = expanded_path
                       if is_dir && !is_dir_path
                         redirect_path = expanded_path.join ""
                       end

                       # Request is a directory but acting as a file,
                       # redirect to the actual directory URL.
                       ART::RedirectResponse.new redirect_path
                     elsif File.file? file_path
                       ART::BinaryFileResponse.new file_path
                     else
                       # Nothing to do.
                       return
                     end
  end
end
