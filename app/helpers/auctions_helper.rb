module AuctionsHelper
  
  def display_nfl_player_dropdown(position_id)
    @nfl_players = NflPlayer.find_by_position_id(position_id)
    detail_collection_select(:auction, :nfl_player_id, @nfl_players, :id, :display_name, "NFL Players", "Choose One", options ={:prompt => "--Select a player--"} ) 
  end
  
  def display_drop_player_dropdown(current_user)  
    @fantasy_players = NflPlayer.find_by_user_id(current_user)
    detail_collection_select(:bid, :nfl_player_id, @fantasy_players, :id, :display_name, "Select A Player To Drop", "These are players currently on your roster.", options ={:prompt => "--Select a player to drop--"} )
  end
  
end
