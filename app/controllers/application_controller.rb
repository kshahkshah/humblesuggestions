class ApplicationController < ActionController::Base
  after_filter :update_user_if_user
  protect_from_forgery
  helper_method :resource, :resource_name, :devise_mapping, :tracking

  def update_user_if_user
    if current_user
      current_user.last_latitude   = cookies["latitude"]
      current_user.last_longitude  = cookies["longitude"]
      # current_user.last_location   = ""
      current_user.save if current_user.changed?
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || connect_or_home(resource)
  end

  def connect_or_home(resource)
    resource.connected? ? '/home' : '/services'
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def tracking
    @track ? "<script>mixpanel.track('#{@track}');</script>".html_safe : nil
  end

end
