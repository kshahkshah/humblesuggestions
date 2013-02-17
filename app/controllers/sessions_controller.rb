class SessionsController < ApplicationController
  def create
    if current_user
      current_user.add_service_from_auth_hash(auth_hash)
      redirect_to '/'
    else
      @user = User.find_or_create_from_auth_hash(auth_hash)
      sign_in_and_redirect(@user)
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end