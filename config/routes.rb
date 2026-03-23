Rails.application.routes.draw do
  root "dashboard#show"

  # Aliased routes for newsletter vocabulary
  get "/publications", to: "books#index", as: :publications

  resource :first_run, only: %i[ show create ]

  resource :session, only: %i[ new create destroy ] do
    scope module: "sessions" do
      resources :transfers, only: %i[ show update ]
    end
  end

  get "join/:join_code", to: "users#new", as: :join
  post "join/:join_code", to: "users#create"

  resource :account do
    scope module: "accounts" do
      resource :join_code, only: :create
      resource :custom_styles, only: %i[ edit update ]
      resources :sending_domains do
        member do
          post :verify
        end
      end
    end
  end

  resources :books, except: %i[ index show ] do
    resource :publication, controller: "books/publications", only: %i[ show edit update ]
    resource :branding, controller: "books/brandings", only: %i[ edit update ]
    resource :preview, controller: "books/previews", only: %i[ show create ]
    resource :bookmark, controller: "books/bookmarks", only: :show

    scope module: "books" do
      namespace :leaves do
        resources :moves, only: :create
      end

      resource :search
      resources :issues do
        member do
          post :send_campaign
        end
      end
      resources :subscriber_imports, only: %i[ new create ]
      resources :ad_slots
      resources :article_sources
      resources :generated_articles, only: %i[index show] do
        member do
          post :publish
          post :reject
        end
      end
    end

    resources :sections
    resources :pictures
    resources :pages
    resources :adverts
  end

  # Subscriber routes (public)
  get "/s/:handle/subscribe", to: "subscriptions#show", as: :subscription
  post "/s/:handle/subscribe", to: "subscriptions#create"
  get "/s/:handle/confirm/:token", to: "subscriptions#confirm", as: :confirm_subscription
  get "/unsubscribe/:token", to: "unsubscribes#show", as: :unsubscribe
  post "/unsubscribe/:token", to: "unsubscribes#create"

  # Web version of issues
  get "/issues/:slug", to: "issues#show", as: :issue_web

  # Ad marketplace
  resources :marketplace, only: :index
  resources :ad_creatives
  get "/c/:token", to: "click_tracking#show", as: :click_track

  # Billing
  resource :billing, only: :show, controller: "billing" do
    post :create_checkout
    post :portal
  end

  # Admin
  namespace :admin do
    get "/", to: "dashboard#show", as: :dashboard
    resources :accounts, only: %i[index show] do
      member do
        post :impersonate
      end
    end
    resources :campaigns, only: :index
    resources :ad_creatives, only: %i[index show] do
      member do
        post :approve
        post :reject
      end
    end
  end

  # Webhooks
  post "/webhooks/resend", to: "webhooks/resend#create"

  get "/:id/:slug", to: "books#show", constraints: { id: /\d+/ }, as: :slugged_book
  get "/:book_id/:book_slug/:id/:slug", to: "leafables#show", constraints: { book_id: /\d+/, id: /\d+/ }, as: :slugged_leafable

  direct :book_slug do |book, options|
    route_for :slugged_book, book, book.slug, options
  end

  direct :leafable_slug do |leaf, options|
    route_for :slugged_leafable, leaf.book, leaf.book.slug, leaf, leaf.slug, options
  end

  resources :pages, only: [] do
    scope module: "pages" do
      resources :edits, only: :show
    end
  end

  resources :qr_code, only: :show
  resources :users do
    scope module: "users" do
      resource :profile
    end
  end

  direct :leafable do |leaf, options|
    route_for "book_#{leaf.leafable_name}", leaf.book, leaf, options
  end

  direct :edit_leafable do |leaf, options|
    route_for "edit_book_#{leaf.leafable_name}", leaf.book, leaf, options
  end

  namespace :action_text, path: nil do
    get "/u/*slug" => "markdown/uploads#show", as: :markdown_upload
    post "/uploads" => "markdown/uploads#create", as: :markdown_uploads
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
