Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'

  resources :animals, only: [:index, :show]

  namespace :admin do
    resources :animals
    resources :users, only: [:index, :new, :create]
    resource :profile, only: [:edit, :update]
  end

  root to: "animals#index"
end
