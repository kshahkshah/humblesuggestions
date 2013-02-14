Humblesuggestions::Application.routes.draw do
  resources :ideas
  resources :suggestions

  devise_for :users

  root :to => 'welcome#index'
  match '/home' => 'welcome#home'
  match '/roadmap' => 'welcome#roadmap'
  match '/auth/:provider/callback', to: 'sessions#create'

end
