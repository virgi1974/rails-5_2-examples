Rails.application.routes.draw do

	require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq'
	
	resources :movies, only: [:show, :index] do
		get 'search/*query', to: 'movies#index', as: :search, on: :collection
	end

  resources :genres
  resources :movies

  root to: "movies#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
