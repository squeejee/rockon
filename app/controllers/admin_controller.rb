class AdminController < ApplicationController 
  require 'hpricot'
  require 'open-uri'
  
  include AuthenticatedSystem
  layout "admin"
  before_filter :login_required
  
  def show
    
  end  
  
  def sync_nfl_players    
    @players = Hpricot.XML(open("http://football9.myfantasyleague.com/2007/export?TYPE=players&L=18664&W=")) 
    
    @players.search(:player).each do |player|
      if (player[:position] == "QB" || player[:position] == "RB" || player[:position] == "WR" \
      || player[:position] == "TE" || player[:position] == "Def" || player[:position] == "PK") \
      && player[:id].to_i > 8000
        nfl_player = NflPlayer.new()
        nfl_player.id = player[:id].to_i 
        player_name = player[:name].split(',')
        nfl_player.last_name = player_name[0].strip
        nfl_player.first_name = player_name[1].strip
        nfl_player.save
      end
    end
    
    flash[:notice] = "NFL Players Successfully Synced. #{NflPlayer.maximum('id')}"
    render(:action => 'show')
  end
  
end
