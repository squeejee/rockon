ActionController::Routing::Routes.draw do |map|
  map.resources :leagues

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  map.resources :auctions do |auction|
    auction.resources :bids
  end
  
  map.resources :nfl_players, :collection => {:search => :get }

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.home '', :controller => 'auctions'  
  
  map.resource :admin do |admin|
    admin.resources :users, :name_prefix => 'admin_', :controller => 'admin/user'
    admin.resources :nfl_players, :name_prefix => 'admin_', :controller => 'admin/nfl_players'
  end
  
  map.resources :leagues
  
  map.resources :users
  #easier routes for restful_authentication
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.forgot_password '/forgot_password', :controller => 'user', :action => 'forgot_password'
  map.reset_password '/reset_password', :controller => 'users', :action => 'reset_password'

  map.connect '/:short_name/', :controller => 'stores', :action => 'show'
    
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
