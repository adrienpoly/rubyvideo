# == Route Map
#

Rails.application.routes.draw do

  extend Authenticator

  # static pages
  get "uses", to: "page#uses"

  # authentication
  get "/auth/failure", to: "sessions/omniauth#failure"
  get "/auth/:provider/callback", to: "sessions/omniauth#create"
  post "/auth/:provider/callback", to: "sessions/omniauth#create"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  authenticate :admin do
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  resources :topics, only: [:index, :show]
  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :password_reset, only: [:new, :edit, :create, :update]
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end

  # resources
  namespace :analytics do
    resource :dashboards, only: [:show] do
      get :daily_page_views
      get :daily_visits
      get :monthly_page_views
      get :monthly_visits
    end
  end
  resources :talks, param: :slug, only: [:index, :show, :update, :edit] do
    scope module: :talks do
      resources :recommendations, only: [:index]
    end
  end
  resources :speakers, param: :slug, only: [:index, :show, :update, :edit]
  resources :events, param: :slug, only: [:index, :show, :update, :edit]
  namespace :speakers do
    resources :enhance, only: [:update], param: :slug
  end

  # admin
  namespace :admin, if: -> { Current.user & admin? } do
    resources :suggestions, only: %i[index update destroy]
  end

  get "/sitemap.xml", to: "sitemaps#show", defaults: {format: "xml"}

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "page#home"
end
