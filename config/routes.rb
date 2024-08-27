Rails.application.routes.draw do
  devise_for :users
  
  # Custom routes for user profile
  resource :user, only: [:show, :edit, :update]
  
  root to: "home#index"
end