ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users', :action => 'index'
  map.resources :users
  map.resources :users, :path_prefix => '/good/bad/ugly'
  map.resources :profiles
  map.resources :tasks
end
