class Message < ApplicationRecord
  belongs_to :sender, class_name:"User"
  belongs_to :receiver, class_name:"User"

  after_create_commit { broadcast_message }

  private

  def broadcast_message
    message = self.reload
    if message.sender.id > message.receiver.id
      user1 = message.receiver.id
      user2 = message.sender.id
    else
      user1 = message.sender.id
      user2 = message.receiver.id
    end
    ActionCable.server.broadcast('messages_'+user1.to_s+'_'+user2.to_s,{
      id: self.id,
      body: self.body,
      sender_id: message.sender.id,
      receiver_id: message.receiver.id
    })
  end

end
