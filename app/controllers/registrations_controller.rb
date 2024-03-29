class RegistrationsController < Devise::RegistrationsController
  # ripped entirely, but with a change of redirect
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(resource_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      redirect_to '/'
    else
      clean_up_passwords resource
      redirect_to '/'
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in :user, @user, :bypass => true
      redirect_to '/settings?initial=true'
    else
      render '/welcome/index'
    end
  end
end