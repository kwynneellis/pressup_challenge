Rails.application.routes.draw do
  devise_for :users

  resource :user, only: [:show, :edit, :update]

  resources :press_ups, only: [:index] do
    collection do
      get 'day/:date', action: :show_by_date, as: :day
    end
  end

  resources :logs, only: [:create, :index] do
    collection do
      delete 'reset_logs', to: 'logs#reset_logs', as: 'reset'
    end
  end

  post 'update_logs', to: 'logs#update_all_logs', as: 'update_all_logs'

  root to: "press_ups#index"
end