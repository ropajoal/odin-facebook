class Message < ApplicationRecord
  belongs_to :sender, class_name:"User"
  belongs_to :receiver, class_name:"User"

  after_create_commit { broadcast_message }

  private

  def broadcast_message
    ActionCable.server.broadcast('MessagesChannel',{
      id: self.id,
      body: self.body 
    })
  end

end
