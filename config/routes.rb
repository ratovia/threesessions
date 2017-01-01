Rails.application.routes.draw do
  root 'users#home'
  post "create" => "users#create"
  get "show" => "users#show"
end
