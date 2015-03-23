Rails.application.routes.draw do
  root 'pages#home'

  get  'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new', as: :signup
  post 'signup', to: 'users#create'

  resource :password, only: [:edit, :update]

  resources :users, only: [:index, :new, :create]
  resources :courses, only: [:index, :show, :new, :create, :edit, :update] do
    resources :challenges, only: [:new, :create, :edit, :update, :show]
    resources :resources, only: [:new, :create, :show, :edit, :update, :destroy] do
      resource :completion, controller: 'resource_completion', only: [:create, :destroy]
    end
  end

    resources :challenges, only:[] do
      patch 'update_position', on: :member
    end

  resources :solutions, only: [] do
    put 'update_documents', on: :member
    post 'submit', on: :member
    get  'preview/:file', action: 'preview', on: :member, constraints: { file: /[0-z\.]+/ }, as: :preview
  end

  get 'dashboard', to: redirect("/courses", status: 301)

  resources :resources, only: [:edit, :update, :destroy] do
    patch 'update_position', on: :member
    resource :completion, controller: 'resource_completion', only: [:create, :destroy]
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end
end
