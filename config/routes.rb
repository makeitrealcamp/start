Rails.application.routes.draw do
  root 'pages#home'

  get  'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'dashboard', to: 'dashboard#index'

  resources :users, only: [:create]
  resources :courses, only: [:show] do
    resources :challenges, only: [:new, :create, :edit, :update, :show]
  end

  resources :solutions, only: [] do
    put 'update_documents', on: :member
    post 'submit', on: :member
    get  'preview/:file', action: 'preview', on: :member, constraints: { file: /[0-z\.]+/ }, as: :preview
  end

  resources :resources, only: [] do
    resource :completion, controller: 'resource_completion', only: [:create, :destroy]
  end
end
