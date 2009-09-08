ActionController::Routing::Routes.draw do |map|
  map.resources :kitties

  map.resources :leagues

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  #map.create_bid '/auctions/:auction_id/bid/create', :controller => 'bids', :action => 'create', :method => 'get'
  
  map.resources :auctions do |auction|
    auction.resources :bids
    auction.create_bid '/auctions/:auction_id/bid/create', :controller => 'bids', :action => 'create'
  end
  
  map.resources :nfl_players, :collection => {:search => :get }

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.home '', :controller => 'auctions'  
  
  map.resource :admin do |admin|
    admin.resources :users, :name_prefix => 'admin_', :controller => 'admin/user', :active_scaffold => true
    admin.resources :nfl_players, :name_prefix => 'admin_', :controller => 'admin/nfl_players', :active_scaffold => true
    admin.resources :kitties, :name_prefix => 'admin_', :controller => 'admin/kitty', :active_scaffold => true
  end
  
#  map.admin_kitty 'admin/kitty', :controller => 'admin/kitty'
  map.sync_nfl_players '/admin/sync_nfl_players', :controller => 'admins', :action => 'sync_nfl_players'
  map.sync_rosters '/admin/sync_rosters', :controller => 'admins', :action => 'sync_rosters'
  
  map.resources :leagues
  
  map.resources :users
  #easier routes for restful_authentication
  map.edit_user '/edit/:id', :controller => 'user', :action => 'edit'
  map.update_user '/update/:id', :controller => 'user', :action => 'update'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.forgot_password '/forgot_password', :controller => 'user', :action => 'forgot_password'
  map.reset_password '/reset_password', :controller => 'users', :action => 'reset_password'
    
  map.user_kitty '/kitties/:user_id', :controller => 'kitties', :action => 'show'
      
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
