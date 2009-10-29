ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users', :action => 'index'
  map.resources :users
  map.connect '/good/bad/ugly/users/new', :controller => 'good/bad/ugly/users', :action => 'new'
  map.resources :profiles
  map.resources :tasks
end
