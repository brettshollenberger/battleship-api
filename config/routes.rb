Battleship::Application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :games
    end
  end
end
