Rails.application.routes.draw do
  devise_for :users

  resource :user, only: [:show, :edit, :update] do
    patch :toggle_visibility, on: :collection
  end

  resources :challenges do
    member do
      get 'day/:date', action: :show_by_date, as: :day
      post 'join', to: 'challenges#join', as: 'join'
      delete 'leave', to: 'challenges#leave', as: 'leave'
    end
  
    collection do
      get 'public', to: 'challenges#public_index', as: 'public'
    end

    resources :logs, only: [:create, :index, :destroy] do
      collection do
        delete 'reset_logs', to: 'logs#reset_logs', as: 'reset'
        post 'catch_up', to: 'logs#catch_up', as: 'catch_up'
      end
    end
  end

  get 'logs/all', to: 'logs#index_all', as: 'all_logs'

  authenticated :user do
    root 'logs#index_all', as: :authenticated_root
  end
  
  unauthenticated do
    root 'session#new', as: :unauthenticated_root
  end
end