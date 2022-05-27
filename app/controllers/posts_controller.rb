class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = User.includes(created_posts:[:creator,:likes,:liked_users,:post_element,comments: [:creator]]).find(current_user.id).created_posts + 
      User.includes(infriends: [created_posts: [:creator,:likes,:liked_users,:post_element,comments: [:creator]]], 
                    outfriends: [created_posts:[:creator,:likes,:liked_users,:post_element,comments: [:creator]]]).find(current_user.id)
      .friends.reduce([]){|array, friend| array + friend.created_posts}
    @posts.sort_by!{|post| post[:created_at]}.reverse!
    #@posts = Post.includes(:creator,:likes,:liked_users,comments: [:creator]).all
		@post = Post.new
  end

  def create_text
    puts "Why am I here?"
    @text_post = current_user.created_posts.build(post_element: TextPost.new(text_params)) 
    if @text_post.save
      redirect_to posts_path
    else
      puts @text_post.errors.full_messages
      render :new
    end
  end
  
  def create_image
    @image_post = current_user.created_posts.build(post_element: ImagePost.new(image_params)) 
    if @image_post.save
      redirect_to posts_path
    else
      puts @image_post.errors.full_messages
      render :new
    end
  end

  private
  
  def text_params
    params.require(:text_post).permit(:text_content)
  end

  def image_params
    params.require(:image_post).permit(:image_link)
  end

end
