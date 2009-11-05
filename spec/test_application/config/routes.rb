ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users', :action => 'index'
  map.resources :users
  map.connect '/good/bad/ugly/users/new', :controller => 'good/bad/ugly/users', :action => 'new'
  map.connect '/good/bad/ugly/users', :controller => 'good/bad/ugly/users', :method => 'put'
  map.resources :profiles
  map.resources :tasks
end
