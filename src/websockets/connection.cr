module ApplicationCable
  class Connection < Cable::Connection
    # You need to specify how you identify the class, using something like:
    # Remembering that it must, be a String
    # Tip: Use your `User#id` converted to String
    identified_by :identifier

    # owned_by current_user : User

    def connect
      self.identifier = [1, 2, 3, 4, 5, 6, 7, 8, 9].sample.to_s
      puts "Connected"
      true
    end
  end
end
