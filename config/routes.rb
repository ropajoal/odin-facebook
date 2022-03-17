Rails.application.routes.draw do
  post 'likes', to: "likes#create"
  delete 'likes', to: "likes#delete"

  devise_for :users
  
  get "/posts", to: "posts#index"
  post "/posts", to: "posts#create"

  root "posts#index"
end
