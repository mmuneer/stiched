Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create] do
  end

  resources :reports, only: [] do
    collection do
      get :successful_clearances
      get :failed_clearances
    end
  end
  root to: "clearance_batches#index"
end
