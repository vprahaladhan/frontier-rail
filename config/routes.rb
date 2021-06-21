Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth/facebook/callback' => 'sessions#create'

  root 'welcome#home'

  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :trains

  resources :trips

  get  '/login',  to: 'sessions#new'    
  post '/login',  to: 'sessions#create',  as: 'login_post' 
  get  '/logout', to: 'sessions#destroy'
end