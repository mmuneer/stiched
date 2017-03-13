Rails.application.routes.draw do
  resources :clearance_batches, only: [:index] do
    collection do
      post :scan
      post :batch_process
    end
  end

  resources :reports, only: [] do
    collection do
      get :successful_clearances
    end
  end
  root to: "clearance_batches#index"
end
