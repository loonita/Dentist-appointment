Rails.application.routes.draw do
  resources :appointments
  resources :statuses

  default_url_options :host => 'localhost'

  root "application#index"

  resources :roles

  devise_for :users,
             :controllers => {
               :confirmations => 'users/confirmations',
               :registrations => 'users/registrations'

             }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get '/users/:id', :to => 'users#show', :as => :user




end
