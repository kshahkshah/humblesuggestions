class WelcomeController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    if current_user
      redirect_to '/home'
    else
      @track = 'Home Page Visit'
    end
  end

  def home
    @track = 'User Home Visit'
  end

  def settings
    if current_user.connected?
      @track = 'Settings Visited'
    else
      @track = 'Settings Reached'
    end
  end
end
