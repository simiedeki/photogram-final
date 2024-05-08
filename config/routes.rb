Rails.application.routes.draw do
  devise_for :users
  root to: "users#index"
  get("/", controller: "users", action: "index")
  get("/users", controller: "users", action: "index")
  get("/users/:username", controller: "users", action: "show")
  post("/add_user", controller: "users", action: "create")
  post("/update_user/:user_id", controller: "users", action: "update")
  get("/photos", controller: "photos", action: "index")
  get("/photos/:photo_id", controller: "photos", action: "show")
  get("/delete_photo/:photo_id", controller: "photos", action: "delete")
  post("/insert_photo_record", controller: "photos", action: "create")
  post("/update_photo/:photo_id", controller: "photos", action: "update")
  post("/add_comment", controller: "photos", action: "comment")

post("/users/:id/follow", controller: "users", action: "follow")
post "delete_follow_request", to: "followrequests#delete"
post '/insert_follow_request', to: 'follow_requests#create'
get 'users/:username/feed', to: 'users#feed'

resources :follow_requests, only: [:create]

end
