class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorized?
    if session[:access_token]
      return true
    else
      return false
    end
  end

  def store_token(token)
    session[:access_token] = token
  end
end
