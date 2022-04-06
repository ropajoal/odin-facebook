class UsersController < ApplicationController
  #before_action :authenticate_user!
  def show
    @user = User.find_by({username: params[:username]})
    @friendship = Friendship.where("( user1_id = #{current_user.id} AND user2_id = #{@user.id} ) OR ( user1_id = #{@user.id} AND user2_id = #{current_user.id} )").limit(1)[0]
  end

  def index
    @users = User.all
    @friendships = current_user.friendships
  end

  #private
  #def like_params
  #  params.require(:like).permit(:post_id)
  #end 
end
