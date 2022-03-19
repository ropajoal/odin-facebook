Rails.application.routes.draw do
  post 'likes', to: "likes#create"
  delete 'likes', to: "likes#delete"
  get '/user/:username', to: "users#show"
  post 'friendships', to: "friendships#create"
  post 'friendships/accept', to: "friendships#accept"
  post 'friendships/decline', to: "friendships#decline"

  devise_for :users
  
  get "/posts", to: "posts#index"
  post "/posts", to: "posts#create"

  root "posts#index"
end
