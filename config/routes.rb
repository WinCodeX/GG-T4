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
resources :chat_rooms, only: [:index, :show, :create] do
resources :messages, only: [:create]
end
get "/chat_with/:id", to: "chat_rooms#chat_with", as: :chat_with_user





  root "home#index"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/dashboard", to: "dashboard#index", as: :dashboard
  get '/search_users', to: 'users#search', as: 'search_users'
  get '/search_packages', to: 'packages#search', as: 'search_packages'
  
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
    post   '/login',  to: 'auth#login'
    delete '/logout', to: 'auth#logout'
    get    '/me',     to: 'users#me'
    put    '/me',     to: 'users#update'
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
