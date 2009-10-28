ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :profiles
  map.resources :tasks
end
