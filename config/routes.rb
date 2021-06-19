Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth/facebook/callback' => 'sessions#create'

  root 'welcome#home'

  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
end