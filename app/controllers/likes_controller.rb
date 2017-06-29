class LikesController < ApplicationController
  # GET /likes
  def index
    if params[:number]
      if !authorized?
        redirect_to login_index_path
      else
        @token = session[:access_token]
        @liked = Like.like_all(session[:access_token], params[:number].to_i)
        render json: {"message": "liked #{@liked} people"}
      end
    else
      render json: {"message": "please input a number"}
    end
  end

  # POST /likes
  def create

  end
end
