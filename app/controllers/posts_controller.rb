class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = User.includes(created_posts:[:creator,:likes,:liked_users,comments: [:creator]]).find(current_user.id).created_posts + 
      User.includes(infriends: [created_posts: [:creator,:likes,:liked_users,comments: [:creator]]], 
                    outfriends: [created_posts:[:creator,:likes,:liked_users,comments: [:creator]]]).find(current_user.id)
      .friends.reduce([]){|array, friend| array + friend.created_posts}
    @posts.sort_by{|post| post[:created_at]}
    #@posts = Post.includes(:creator,:likes,:liked_users,comments: [:creator]).all
		@post = Post.new
  end

  def create
    @post = current_user.created_posts.build(posts_params) 
    if @post.save
      redirect_to posts_path
    else
      puts @post.errors.full_messages
      render :new
    end
  end

  private
  
  def posts_params
    params.require(:post).permit(:title, :content)
  end

end
