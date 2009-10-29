ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.connect '/good/bad/ugly/users/new', :controller => 'good/bad/ugly/users', :action => 'new'
end
