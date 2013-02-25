class ApplicationController < ActionController::Base
  after_filter :update_user_if_user
  protect_from_forgery

  def update_user_if_user
    if current_user
      current_user.last_latitude   = cookies["latitude"]
      current_user.last_longitude  = cookies["longitude"]
      # current_user.last_location   = ""
      current_user.save if current_user.changed?
    end
  end

end
