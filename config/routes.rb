Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create] do
    member do
      get :successful_clearances
      get :failed_clearances
    end
  end
  root to: "clearance_batches#index"
end
