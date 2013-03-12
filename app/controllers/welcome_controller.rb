class WelcomeController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    if current_user
      redirect_to '/home'
    end
  end

  def home
  end

  def settings
  end
end
