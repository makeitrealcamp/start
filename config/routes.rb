Rails.application.routes.draw do
  root 'pages#home'

  get  'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new', as: :signup
  post 'signup', to: 'users#create'

  get 'dashboard', to: 'dashboard#index'

  resources :users
  resources :courses, only: [:show, :edit, :update] do
    resources :challenges, only: [:new, :create, :edit, :update, :show]
    resources :resources, only: [:new, :create, :show]
  end

  resources :solutions, only: [] do
    put 'update_documents', on: :member
    post 'submit', on: :member
    get  'preview/:file', action: 'preview', on: :member, constraints: { file: /[0-z\.]+/ }, as: :preview
  end


  resources :resources, only: [:edit, :update, :destroy] do
    resource :completion, controller: 'resource_completion', only: [:create, :destroy]
  end
end
