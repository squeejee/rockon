class Admin::NflPlayersController < ApplicationController
  include AuthenticatedSystem
  layout "admin"
  before_filter :login_required
  
  active_scaffold :nfl_players

end
