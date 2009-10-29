ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users', :action => 'index'
  map.resources :users
  map.resources :profiles
  map.resources :tasks
end
