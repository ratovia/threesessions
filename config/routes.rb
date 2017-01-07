Rails.application.routes.draw do
  root 'users#home'
  get  "users/home"     => "users#home"
  post "users/create"   => "users#create"
  get  "users/show/:id" => "users#show"
  post "rooms/create"   => "rooms#create"
  get  "rooms/home/:id" => "rooms#home"
  post "rooms/join"     => "rooms#join"
  post "rooms/delete"   => "rooms#delete"
end
