Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/ping", to: proc { [200, {}, ["pong"]] }

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'

  resources :animals, only: [:index, :show]

  namespace :admin do
    resources :animals
    delete "animals/:id/photos/:photo_id", to: "animals#purge_photo", as: :purge_photo
    resources :users, only: [:index, :new, :create]
    resource :profile, only: [:edit, :update]
  end

  root to: "animals#index"
end
