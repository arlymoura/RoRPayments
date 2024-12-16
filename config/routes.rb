Rails.application.routes.draw do
  devise_for :users
  root "payments#new"

  resources :payments, only: [:new, :create, :show]

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end
end
