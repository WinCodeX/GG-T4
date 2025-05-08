Rails.application.routes.draw do
  get 'packages/create'
  devise_for :users, controllers: {
  registrations: "accounts/registrations"
}


devise_scope :user do
  patch 'users/update_avatar', to: 'accounts/registrations#update_avatar', as: :update_avatar
  delete 'users/remove_avatar', to: 'accounts/registrations#remove_avatar', as: :remove_avatar
end

resources :packages, only: [:new, :create, :index, :show]

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

  # config/routes.rb
namespace :api do
  namespace :v1 do
    # Use Devise’s SessionsController (with JWT dispatch/revocation)
    devise_for :users,
      path: '',
      path_names: {
        sign_in:  'login',   # POST   /api/v1/login  → dispatch a JWT
        sign_out: 'logout'   # DELETE /api/v1/logout → revoke the JWT
      },
      controllers: {
        sessions: 'api/v1/sessions'
      },
      defaults: { format: :json }

    # Your custom profile endpoints
    get  '/me', to: 'users#me'
    put  '/me', to: 'users#update'
  end
end

   # Must include :index

  resources :packages do
    member do
      get 'pay'  # payment logic
    end
  end
  
  get '/track/:tracking_code', to: 'packages#track', as: 'track_package'
  

  # Defines the root path route ("/")
  # root "posts#index"
end
