module AuctionsHelper
  
  def display_nfl_player_dropdown(position_id)
    @nfl_players = NflPlayer.find_by_position_id(position_id)
    collection_select(:auction, :nfl_player_id, @nfl_players, :id, :display_name, options ={:prompt => "--Select a player--"} ) 
  end
  
  def display_drop_player_dropdown(current_user)  
    @fantasy_players = NflPlayer.find_by_user_id(current_user)
    collection_select(:bid, :nfl_player_id, @fantasy_players, :id, :display_name, options ={:prompt => "--Select a player to drop--"} )
  end
  
end
