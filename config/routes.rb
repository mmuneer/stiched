Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create] do
    collection do
      post :scan
    end
  end

  resources :reports, only: [] do
    collection do
      get :successful_clearances
      get :failed_clearances
    end
  end
  root to: "clearance_batches#index"
end
