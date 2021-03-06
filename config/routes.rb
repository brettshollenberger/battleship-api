Battleship::Application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :games do
        resources :players, only: [:index, :show, :update]
      end

      resources :boards do
        resources :squares, only: [:index, :show, :update]
        resources :ships, only: [:index, :show, :update]
      end
    end
  end
end
