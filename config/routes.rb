require 'resque/server'

Humblesuggestions::Application.routes.draw do
  mount Resque::Server, :at => "/admin/queues"

  resources :suggestions

  devise_for :users, :controllers => {:registrations => "registrations"}

  root :to => 'welcome#index'
  match '/home' => 'welcome#home'
  match '/settings' => 'welcome#settings'
  match '/auth/:provider/callback', to: 'sessions#create'

end
