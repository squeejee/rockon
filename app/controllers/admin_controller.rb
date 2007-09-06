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
      if %w[QB RB WR TE Def PK].include?(player[:position]) && player[:id].to_i > NflPlayer.maximum('id').to_i
        nfl_player = NflPlayer.new()
        nfl_player.id = player[:id].to_i 
        player_name = player[:name].split(',')
        nfl_player.last_name = player_name[0].strip
        nfl_player.first_name = player_name[1].strip
        nfl_player.position_id = Position.find_by_position_code(player[:position]).id
        nfl_player.nfl_team_id = NflTeam.find_by_nfl_team_code(player[:team]).id
        nfl_player.save
      end
    end
    
    flash[:notice] = "NFL Players Successfully Synced."
    render(:action => 'show')
  end
  
  def sync_rosters
    @players = Hpricot.XML(open("http://football9.myfantasyleague.com/2007/export?TYPE=rosters&L=18664&W="))   
        
    @players.search(:franchise).each do |franchise| 
        franchise_id = franchise[:id].to_i
        
        franchise.search(:player).each do |player|          
          roster_spot = FantasyPlayer.new()
          roster_spot.user_id = franchise_id
          roster_spot.nfl_player_id = player[:id].to_i
          roster_spot.save
        end
    end 
    
    flash[:notice] = "Fantasy Rosters Successfully Synced."
    render(:action => 'show')
    
  end
  
end
