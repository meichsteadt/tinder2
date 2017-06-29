class RecommendationsController < ApplicationController
  def index
    if !authorized?
      redirect_to logins_path
    else
      render json: Like.get_recommendations(session[:access_token])
    end
  end
end
