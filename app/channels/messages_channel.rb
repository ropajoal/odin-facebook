class MessagesChannel < ApplicationCable::Channel
  def subscribed
    interlocutor = User.find(params[:interId])
    if current_user.id < interlocutor.id
      user1 = current_user
      user2 = interlocutor
    else
      user1 = interlocutor
      user2 = current_user
    end
    stream_from "messages_"+ user1.id.to_s + "_" +user2.id.to_s
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
