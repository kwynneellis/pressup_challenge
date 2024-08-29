Rails.application.routes.draw do
  devise_for :users

  resource :user, only: [:show, :edit, :update] do
    patch :update_press_ups, on: :collection
  end

  resources :press_ups, only: [:index] do
    collection do
      get 'day/:date', action: :show_by_date, as: :day
    end
  end

  resources :logs, only: [:create, :index]
  delete 'reset_logs', to: 'logs#reset_logs', as: 'reset_logs'

  root to: "press_ups#index"
end