class LikesController < ApplicationController
  def create
    @like = current_user.likes.build({post_id: params[:post_id]})
    if @like.save
      redirect_back(fallback_location: root_path)
    else
      puts @like.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  def delete
    @like = current_user.likes.find_by({post_id: params[:post_id]})
    puts @like ? "IS OK!!!" : "SOMETHING HAPPEND #{params[:post_id]}"
    @like.destroy unless @like.nil?
    redirect_back(fallback_location: root_path)
  end
  
  #private
  #def like_params
  #  params.require(:like).permit(:post_id)
  #end 
end
