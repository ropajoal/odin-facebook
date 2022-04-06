Rails.application.routes.draw do
  post 'likes', to: "likes#create"
  delete 'likes', to: "likes#delete"
  get '/user/:username', to: "users#show", as: :user_show
  get '/users/index', to:  "users#index"
  post 'friendships', to: "friendships#create"
  post 'friendships/accept', to: "friendships#accept"
  post 'friendships/decline', to: "friendships#decline"
  post 'comments', to: "comments#create"

  devise_for :users
  
  get "/posts", to: "posts#index"
  post "/posts", to: "posts#create"

  root "posts#index"
end
