Rails.application.routes.draw do
  devise_for :users

  resources :press_ups, only: [:index]
  resources :logs, only: [:create, :index]
  delete 'reset_logs', to: 'logs#reset_logs', as: 'reset_logs'

  root to: "press_ups#index"
end