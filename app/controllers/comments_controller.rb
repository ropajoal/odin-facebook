class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      puts @comment.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  
  private
  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end 
end
