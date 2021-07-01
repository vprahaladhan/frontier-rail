Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth/facebook/callback' => 'sessions#create'

  root 'welcome#home'

  resources :users

  resources :trains

  resources :trips

  resources :users, only: [:show] do
    resources :trips, only: [:show, :index]
  end

  resources :trains, only: [:show] do
    resources :trips, only: [:show, :index]
  end

  get  '/login',  to: 'sessions#new'    
  post '/login',  to: 'sessions#create',  as: 'login_post' 
  get  '/logout', to: 'sessions#destroy'
end