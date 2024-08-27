Rails.application.routes.draw do
  devise_for :users

  resources :press_ups, only: [:index]
  resources :logs, only: [:create, :index]

  root to: "press_ups#index"
end