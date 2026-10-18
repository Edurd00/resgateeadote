Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :animals
  end

  root to: "admin/animals#index"
end
