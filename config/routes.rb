Rails.application.routes.draw do
  devise_for :users

  resource :user, only: [:show, :edit, :update] do
    patch :toggle_visibility, on: :collection
  end

  resources :challenges, only: [:index, :show] do
    member do
      get 'day/:date', action: :show_by_date, as: :day
      post 'update_logs', to: 'challenges#update_all_logs', as: 'update_all_logs'
    end

    resources :logs, only: [:create, :index, :destroy] do
      collection do
        delete 'reset_logs', to: 'logs#reset_logs', as: 'reset'
      end
    end
  end

  get 'logs/all', to: 'logs#index_all', as: 'all_logs'

  root to: "challenges#index"
end