Rails.application.routes.draw do
  resources :morning_times
  get '/appointments/pending', to: 'appointments#pending'
  resources :appointments
  resources :statuses
  get 'contact/new'
  resources :contacts, only: [:new, :create]

  default_url_options :host => 'localhost'

  root "application#index"

  get 'servicios', to: 'application#servicios'
  get 'contacto', to: 'application#contacto'
  get 'calendar', to: 'appointments#calendar'
  get 'agendar', to: 'appointments#agendar'
  get 'agendar_d', to: 'appointments#agendar_d'
  get 'agendar_p', to: 'appointments#agendar_p'
  get 'espera', to: 'appointments#agendar_en_espera'
  put 'appointments', :to => 'appointments#agendar_espera'

  resources :roles

  devise_for :users,
             :controllers => {
               :confirmations => 'users/confirmations',
               :registrations => 'users/registrations',

             }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get '/users/dentists', :to => 'users#dentists'
  get '/users/patients', :to => 'users#patients'
  get '/users/new', :to => 'users#new'
  post '/users/create', :to => 'users#create'
  get '/users/:id', :to => 'users#show', :as => :user
  put '/users/:id', :to => 'users#edit'











end
