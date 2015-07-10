Rails.application.routes.draw do

  root 'pages#home'

  get 'handbook', to: 'pages#handbook', as: :handbook

  get  'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  get  'auth/:provider/callback', to: 'sessions#create_with_omniauth', as: :login_omniauth
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new', as: :signup
  post 'signup', to: 'users#create'

  post 'inscription_info', to: 'users#send_inscription_info', as: :inscription_info

  resource :password, only: [:edit, :update]
  resource :password_reset, except: [:index, :show]

  resources :users do
    patch :activate, on: :member
  end

  get '/phases', to: 'phases#index', as: :signed_in_root

  resources :phases, except: [:destroy] do
    patch 'update_position', on: :member
  end

  resources :courses, except: [:destroy,:index] do
    patch 'update_position', on: :member

    resources :challenges, except: [:index, :destroy] do
      get :discussion, on: :member
      resources :solutions, only: [:create]
    end

    resources :projects, except: [:index] do
      resources :project_solutions, only: [:create,:update, :index, :show]
    end

    resources :resources, except: [:index] do
      resource :completion, controller: 'resource_completion', only: [:create, :destroy]
      resources :sections, except: [:index] do
        resources :lessons, except: [:index] do
          post :complete, on: :member
        end
      end
    end
  end

  resources :lessons, only: [] do
    patch 'update_position', on: :member
  end

  resources :projects, only:[] do
    patch 'update_position', on: :member
  end

  resources :challenges, only:[:destroy] do
    patch 'update_position', on: :member
  end

  resources :phases, only:[] do
    patch 'update_position', on: :member
  end

  scope "/:commentable_resource" do
    scope "/:id" do
      resources :comments, only: [:create]
    end
  end

  resources :comments, except: [:index, :create, :new, :show] do
    member do
      get :response_to
      get :cancel_edit
    end
    collection do
      get :preview
    end
  end

  resources :solutions, only: [:show] do
    put 'update_documents', on: :member
    post 'submit', on: :member
    get  'preview/:file', action: 'preview', on: :member, constraints: { file: /[0-z\.]+/ }, as: :preview
    delete 'reset', on: :member
  end

  get 'dashboard', to: redirect("/phases", status: 301)
  get 'courses', to: redirect("/phases", status: 301)

  resources :pair_programming_times, path: :pair_programming

  resources :resources, only: [:edit, :update, :destroy] do
    patch 'update_position', on: :member
    resource :completion, controller: 'resource_completion', only: [:create, :destroy]
  end


  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :show] do
      resources :subscriptions, only: [:create] do
        member do
          patch :cancel
        end
      end
    end
    resources :solutions, only: [:index]
    resources :comments, only: [:index, :destroy]
  end

  # routes to evaluate forms
  match 'forms/hello', to: 'forms#hello', via: [:get, :post]
end
