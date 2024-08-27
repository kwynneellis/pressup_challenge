Rails.application.routes.draw do
  get 'press_ups/index'
  devise_for :users
  
  # Custom routes for user profile
  resource :user, only: [:show, :edit, :update]
  
  root to: "home#index"
end