Rails.application.routes.draw do
  root 'pages#home'

  get "curriculum", to: "pages#curriculum"
  get "front-end-bootcamp", to: "pages#front_end_bootcamp", as: :front_end_bootcamp
  get "full-stack-online", to: "pages#full_stack_online", as: :full_stack_online
  post "full-stack-online", to: "pages#create_full_stack_online_lead"
  get "front-end-online", to: "pages#front_end_online", as: :front_end_online
  post "front-end-online", to: "pages#create_front_end_online_lead"
  get "full-stack-medellin", to: "pages#full_stack_medellin"
  post "full-stack-medellin", to: "pages#create_full_stack_medellin_lead"
  get "full_stack_web_developer", to: redirect('/full-stack-online')
  get "front_end_web_developer", to: redirect('/front-end-online')
  get "faq", to: "pages#faq"
  get "makers", to: "pages#makers"
  get "scholarships", to: "pages#scholarships"
  get "thanks-front-end-bootcamp", to: "pages#thanks_bootcamp"
  get "thanks-front-end-online", to: "pages#thanks_online"
  get "thanks-full-stack-online", to: "pages#thanks_online"
  get "thanks-full-stack-medellin", to: "pages#thanks_full_stack_medellin"
  get "como-convertirte-en-web-developer", to: "pages#web_developer_guide", as: :web_developer_guide
  post "como-convertirte-en-web-developer", to: "pages#send_web_developer_guide"
  get "download-web-developer-guide", to: "pages#download_web_developer_guide", as: :download_web_developer_guide
  get "/terms/job-guarantee", to: "pages#job_guarantee_terms"

  get 'handbook', to: 'pages#handbook', as: :handbook

  get  'login', to: 'sessions#new', as: :login
  get  'on-site/login', to: 'sessions#new_onsite', as: :login_onsite
  post 'login', to: 'sessions#create'
  get  'auth/:provider/callback', to: 'sessions#create_with_omniauth', as: :login_omniauth
  delete 'logout', to: 'sessions#destroy'

  post 'inscription_info', to: 'users#send_inscription_info', as: :inscription_info

  resource :password, only: [:edit, :update]
  resource :password_reset, except: [:index, :show]

  resources :users do
    collection do
      get :activate, action: 'activate_form'
      patch :activate
    end
  end
  # profile
  get '/u/:nickname', to: 'users#profile', as: :user_profile

  get '/dashboard', to: 'dashboard#index', as: :signed_in_root

  resources :phases, only: [:new,:create,:edit,:update]

  resources :courses, except: [:destroy] do
    patch 'update_position', on: :member

    resources :challenges, except: [:index, :destroy] do
      get :discussion, on: :member
      resources :solutions, only: [:create]
    end

    resources :projects, except: [:index] do
      resources :project_solutions, only: [:create,:update, :index, :show] do
        member do
          patch :request_revision
        end
      end
    end

    resources :resources, except: [:index] do
      get :open, on: :member # opens an external resource
      
      resource :completion, controller: 'resource_completion', only: [:create, :destroy]
      resources :sections, except: [:index] do
        resources :lessons, except: [:index] do
          post :complete, on: :member
        end
      end
    end
    namespace :quizer, path: '/' do
      resources :quizzes do
        resources :questions, only: [:index,:new,:create,:edit,:update]
        resources :quiz_attempts, only: [:create, :show] do
          member do
            patch :finish
            get :results
          end
          resources :question_attempts, only: [:update]
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

  namespace :quizer, path: '/' do
    resources :quizzes, only:[] do
      patch 'update_position', on: :member
    end
  end

  # to create a comment we need the commentable resource
  scope '/:commentable_resource' do
    scope '/:id' do
      resources :comments, only: [:create]
    end
  end

  # it is easier to manage comments without the commentable resource in the path
  resources :comments, except: [:index, :create, :new, :show] do
    member do
      get :cancel_edit
      get :response_to
    end
    collection do
      get :preview
    end
  end

  resources :solutions, only: [:show] do
    member do
      put 'update_documents'
      post 'submit'
      get  'preview/:file', action: 'preview', constraints: { file: /[0-z\.]+/ }, as: :preview
      delete 'reset'
    end
  end

  get 'dashboard', to: redirect('/phases', status: 301)
  get 'courses', to: redirect('/phases', status: 301)

  resources :resources, only: [:edit, :update, :destroy] do
    patch 'update_position', on: :member
    resource :completion, controller: 'resource_completion', only: [:create, :destroy]
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :paths, only: [:index, :new, :create, :update, :edit]
    resources :users, only: [:index, :new, :create, :show, :edit, :update] do
      post 'activation/resend-email', action: 'resend_activation_email', on: :member
    end
    resources :solutions, only: [:index]
    resources :comments, only: [:index, :destroy]
    resources :project_solutions, only: [:index] do
      member do
        post 'assign_points'
      end
    end

    resources :badges
    resources :levels
    resources :badge_ownerships, only: [:new, :create]

    resources :courses, only:[:index] do
      patch 'update_position', on: :member
    end
  end

  resources :notifications, only: [:index,:show] do
    collection do
      put :mark_as_read
    end
  end

  # routes to evaluate forms
  match 'forms/hello', to: 'forms#hello', via: [:get, :post]
end
