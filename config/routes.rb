Rails.application.routes.draw do
  devise_for :users
  
  get "/posts", to: "posts#index"
  post "/posts", to: "posts#create"

  root "posts#index"
end
