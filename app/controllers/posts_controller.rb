class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:creator,:likes,:liked_users).all
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
