ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users', :action => 'index'
  map.resources :users
  map.namespace :good do |good|
    good.namespace :bad do |bad|
      bad.namespace :ugly do |ugly|
        ugly.resources :users
      end
    end
  end
  map.resources :profiles
  map.resources :tasks
  map.connect ":controller/:action/:id"
end
