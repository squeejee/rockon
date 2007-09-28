class AuctionsController < ApplicationController
  # GET /auctions
  # GET /auctions.xml
  
  before_filter :login_required, :except=>[:index]
  
  auto_complete_for :nfl_player, :first_name
  
  helper :sort
  include SortHelper
  
  def index    
    sort_init 'auctions.week_no', 'desc'
    sort_update
    
    @week_no = params[:week_no].nil? ? League.current_week : params[:week_no]

    if @week_no == "all"  
     @auctions = Auction.find(:all, :include => [{:nfl_player=>:position}, {:bids=>:user}], :group => "auctions.id", :order => "#{sort_clause}, position_order" )
    else
      @auctions = Auction.find(:all, :conditions=>["week_no = ?", @week_no], :include => [{:nfl_player=>:position}, {:bids=>:user}], :group => "auctions.id", :order => "#{sort_clause}, position_order" )
    end
    
    
    render :action => "index", :layout => false if request.xhr?
    
  end

  # GET /auctions/1
  # GET /auctions/1.xml
  def show
    @auction = Auction.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @auction.to_xml }
    end
  end

  # GET /auctions/new
  def new  
    if League.active?
      @auction = Auction.new
      @nfl_players = NflPlayer.find_by_position_id(1)
      @positions = Position.find(:all, :order => 'position_order')
    else      
        flash[:error] = "Sorry, Buddy!  No more auctions for the season!!"
        redirect_to auctions_url
    end
  end

  # GET /auctions/1;edit
  def edit
    @auction = Auction.find(params[:id])
  end

  # POST /auctions
  # POST /auctions.xml
  def create
    
    @auction = Auction.new(params[:auction])
    @bid = Bid.new(params[:bid])
    
    @existing_auction = Auction.find(:first, :conditions => ["nfl_player_id = ? and week_no = ?", @auction.nfl_player_id, League.current_week])
    
    if @existing_auction
      flash[:notice] = 'This player already has a bid out.  Please bid again.'
      
      #*************I CANNOT FIGURE OUT HOW TO REDIRECT DIRECTLY TO THE BIDS/CREATE METHOD WHILE APPENDING
      #*************THE PARAMS HASH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      #redirect_to create_bid_url(@existing_auction.id), :controller => 'bids', :action => 'create', :bid => params[:bid]
      #redirect_to :controller => 'bids', :action => 'create', :auction_id => @existing_auction.id, :bid => params[:bid]
      
      redirect_to new_bid_path(@existing_auction.id)
      return false
    end
    
    @positions = Position.find(:all, :order => 'position_order')
    
    @auction.expiration = League.auction_end_date
    @auction.week_no = League.current_week
    
    @bid.user_id = current_user
    
    respond_to do |format|
      if request.post? and @auction.save
        @bid.auction_id = @auction.id
        @bid.price = 1
        
        if @bid.save
          flash[:notice] = 'Auction was successfully created.'
          format.html { redirect_to auction_url(@auction) + "/bids" }
          format.xml  { head :created, :location => auction_url(@auction) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @auction.errors.to_xml }
        end
        
      else        
        format.html { render :action => "new" }
        format.xml  { render :xml => @auction.errors.to_xml }
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.xml
  def update
    @auction = Auction.find(params[:id])

    respond_to do |format|
      if @auction.update_attributes(params[:auction])
        flash[:notice] = 'Auction was successfully updated.'
        format.html { redirect_to auction_url(@auction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auction.errors.to_xml }
      end
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.xml
  def destroy
    @auction = Auction.find(params[:id])
    @auction.destroy

    respond_to do |format|
      format.html { redirect_to auctions_url }
      format.xml  { head :ok }
    end
  end
  
  def position_changed
    render :partial => "nfl_players", :locals => { :position_id => params[:id] }
  end
  
  # This was used when I wanted to allow users to select players from an autocomplete text box.
  # I was not able to add an ID to a hidden field, so this was canned.  
  def auto_complete_for_nfl_player_display_name
    auto_complete_responder_for_nfl_players params[:nfl_player][:display_name]
  end
  
  private
  
  # This was used when I wanted to allow users to select players from an autocomplete text box.
  # I was not able to add an ID to a hidden field, so this was canned.
  def auto_complete_responder_for_nfl_players(value)
    @nfl_players = NflPlayer.find(:all,
                   :conditions => ['LOWER(concat(first_name, last_name)) LIKE ?', '%' + value.downcase + '%'],
                   :order => 'last_name, first_name asc',
                   :limit => 10)
    render :partial => 'nfl_players'
  end
  
end
