class ChatChannel < Cable::Channel
  def subscribed
    # We don't support stream_for, needs to generate your own unique string
    puts "Subscribed to chat_#{params["room"]}"
    stream_from "chat_#{params["room"]}"
  end

  def receive(data)
    puts "Recieved message"
    broadcast_message = {} of String => String
    broadcast_message["message"] = data["message"].to_s
    broadcast_message["current_user_id"] = connection.identifier
    ChatChannel.broadcast_to("chat_#{params["room"]}", broadcast_message)
  end

  def perform(action, action_params)
    puts "Performing broadcast"
    ChatChannel.broadcast_to("chat_#{params["room"]}", {
      "user"      => "test@email.com",
      "performed" => action.to_s,
    })
  end

  def unsubscribed
    puts "Unsubscribing"
  end
end
