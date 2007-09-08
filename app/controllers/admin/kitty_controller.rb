class Admin::KittyController < ApplicationController  
  include AuthenticatedSystem
  layout "admin"
  before_filter :login_required
    
  active_scaffold :kitty #do |config|
#    config.label = "Kitty"
#    config.actions = [:list, :nested, :show, :update, :delete, :subform]
#    config.columns = [:description, :league_due, :league_owes, :league_paid, :league_received, :week_no]
#    list.columns.exclude :created_at
#  end
end
