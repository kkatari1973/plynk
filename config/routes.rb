Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  get "invitations/index"
  get "friendships/index"
  get "categories/index"
  get "categories/show"
  get "items/index"
  get "items/show"
  get "items/new"
  get "items/edit"
  get "reviews/index"
  get "reviews/show"
  get "reviews/new", as: :new_review
  get "reviews/edit"
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [ :new, :create ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  resources :invitations, only: [ :index, :create ]
  resources :friendships, only: [ :index, :create, :update, :destroy ]

  resources :categories, only: [ :index, :show ]

  resources :items do
    resources :reviews, only: [ :new, :create, :show ]
  end

  resources :reviews, only: [ :index, :create, :show, :edit, :update, :destroy ]

  resource :profile, only: [:show, :edit, :update]

  namespace :admin do
    resources :categories
  end
end
