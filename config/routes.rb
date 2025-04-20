Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: "accounts/registrations"
}

  root "home#index"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/dashboard", to: "dashboard#index", as: :dashboard
  
  namespace :clients do
    get 'dashboard/index'
    get "dashboard", to: "dashboard#index"
  end
  
  namespace :admin do
    get "dashboard", to: "dashboard#index"
  end
  
  namespace :agents do
    get "dashboard", to: "dashboard#index"
  end
  
  namespace :riders do
    get "dashboard", to: "dashboard#index"
  end
  
  # Defines the root path route ("/")
  # root "posts#index"
end
