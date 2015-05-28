Rails.application.routes.draw do
  get 'map/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'web/page#index'

  get '/features', to: 'web/page#features', as: 'features'
  get '/faq', to: 'web/page#faq', as: 'faq'

  resources :image_search, only: [:index]

  # TODO: Use scopes so that we not bloat our routes.
  resources :trips do
    resources :participants
    resources :map
    resources :equipment_lists do
        resources :equipment_items, only: [:create, :update, :edit, :destroy] do
            resources :equipment_assignments, only: [:create, :destroy]
        end
    end
    resources :events
    resources :articles
    resources :routes do
      resources :waypoints
    end

    resources :discussions do
      resources :comments
    end
    resources :media, only: [:index, :show, :destroy]
  end

  resources :trip_public

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: [:show, :edit, :update] do
    resources :friendships, only: [:destroy]
    resources :requests, only: [:create, :destroy] do
      member do
        post :accept
      end
    end
  end


  get '/dashboard', to: 'dashboard#index', as: 'dashboard'

  # Explore
  get 'explore', to: 'explore#index', as: 'explore'
  get 'api/explore', to: 'explore#list', as: 'api_explore'

  # Search
  get 'search', to: 'search#index', as: 'search'
  get 'search/trips', to: 'search#trips', as: 'search_trips'
  get 'search/users', to: 'search#users', as: 'search_users'

  # Dropbox
  get '/dropbox-connect/:trip_id/:user_id', to: 'media_dropbox#auth_start', as: 'dropbox_connect'
  get '/dropbox-finish', to: 'media_dropbox#auth_finish', as: 'dropbox_finish'

end
