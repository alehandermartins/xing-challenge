Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'

  namespace :api, defaults: {format: 'json'} do
    post 'login' => 'sessions#login'
    resources :users
    resources :play_lists do
      post "add_mp3", on: :member
      post "remove_mp3", on: :member
    end
  end
end
