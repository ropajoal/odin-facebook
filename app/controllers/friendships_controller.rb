class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @friendship = current_user.outfriendships.build({user2_id: params[:friend_id], status: "requested"})
    if @friendship.save
      redirect_back(fallback_location: root_path)
    else
      puts @friendship.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  def accept
    @friendship = current_user.infriendships.find_by({user1_id: params[:friend_id]})
    unless @friendship.nil?
      if @friendship.status == "requested" 
        @friendship.update({status: "accepted"})
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def decline
    @friendship = current_user.infriendships.find_by({user1_id: params[:friend_id]})
    unless @friendship.nil?
      if @friendship.status == "requested" 
        @friendship.update({status: "declined"})
        redirect_back(fallback_location: root_path)
      end
    end
  end
  
  #private
  #def like_params
  #  params.require(:like).permit(:post_id)
  #end 
end
