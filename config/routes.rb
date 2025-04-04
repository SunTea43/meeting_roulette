Rails.application.routes.draw do
  # Set root path to the roulette index page
  root "roulette#index"
  
  # Roulette routes
  get "spin", to: "roulette#spin"
  
  # Participants routes (RESTful)
  resources :participants do
    collection do
      get 'bulk/new', to: 'participants#bulk_new', as: 'bulk_new'
      post 'bulk/create', to: 'participants#bulk_create', as: 'bulk_create'
      post 'bulk/toggle', to: 'participants#bulk_toggle', as: 'bulk_toggle'
    end
  end
  
  # Health check and PWA routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
