class BidsController < ApplicationController
  # GET /bids
  # GET /bids.xml
  
  before_filter :login_required, :except=>[:index]
  
  require 'date'
  
  helper :auctions
  
  def index
    
    @auction = Auction.find(params[:auction_id], :include => :nfl_player)   
              
    unless @auction.hidden_auction && !@auction.top_bidder?             
      @bids = Bid.find(:all, :conditions => {:auction_id => params[:auction_id]}, 
              :include => [:nfl_player, :user],
              :order => "bids.price desc")

      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @bids.to_xml }
      end
    else
      flash[:notice] = "Yo!  That auction is hidden and not yours!!"
      redirect_to auctions_url
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show
    @bid = Bid.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @bid.to_xml }
    end
  end

  # GET /bids/new
  def new
    @auction = Auction.find(params[:auction_id], :include => :nfl_player)
    
      if @auction.active? 
        @bid = Bid.new 
      else
        flash[:error] = "Sorry, Bro!  This auction has expired!!"
        redirect_to auction_path(@auction) + "/bids"
      end
  end

  # GET /bids/1;edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
            
    @bid = Bid.new(params[:bid])
    @auction = Auction.find(params[:auction_id], :include => :nfl_player)
    @bid.auction_id = @auction.id
    @bid.user_id = current_user

    @top_bid = @auction.bids.find_top_bidder()
    
    @existing_bid = Bid.new(:auction_id => @top_bid.auction_id, :user_id => @top_bid.user_id, 
                       :nfl_player_id => @top_bid.nfl_player_id, :price => @bid.price,
                       :max_price => @top_bid.max_price)

    existing_bidder = false
    
    
    unless @bid.max_price.nil?
      if @auction.top_bidder.user_id == current_user  
        @modified_bid = Bid.find(@top_bid.id)
        if @bid.max_price >= @top_bid.price 
          existing_bidder = true   
          success_display = true
          @modified_bid.update_attributes(params[:bid]) 
          @modified_bid.save ? success_display=true : error_display=true
        else 
          winning_bidder = false   
          success_display = true
        end

      else
        if @bid.max_price <= @top_bid.price   
          winning_bidder = false 
          success_display = true
        elsif @bid.max_price <= @top_bid.max_price  
          winning_bidder = false
          @bid.price = @bid.max_price - 1
          @existing_bid.price = @bid.max_price
          @bid.save && @existing_bid.save ? success_display=true : error_display=true
        else  
          winning_bidder = true
          @bid.price = @top_bid.max_price + 1
          @existing_bid.price = @top_bid.max_price
          @bid.save ? success_display=true : error_display=true
        end
      end
    end
        
    if existing_bidder && success_display
      flash[:notice] = "Your max bid has been updated!"
      redirect_to new_bid_path
    elsif winning_bidder && success_display
      UserNotifier.deliver_auction_outbid(@bid, @top_bid.user, @auction)
      flash[:notice] = "Congratulations!  You are now the top bidder!" 
      redirect_to auction_url(@auction) + "/bids"
    elsif !winning_bidder && success_display
      flash[:notice] = "Whoops!  You are going to have to bid higher than $#{@bid.max_price}!"
      redirect_to new_bid_path
    else
      flash[:error] = "Please fill in all fields!"
      render(:action => 'new')
    end
  end
   
  # PUT /bids/1
  # PUT /bids/1.xml
  def update
    @bid = Bid.find(params[:id])

    respond_to do |format|
      if @bid.update_attributes(params[:bid])
        flash[:notice] = 'Bid was successfully updated.'
        format.html { redirect_to bid_url(@bid) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bid.errors.to_xml }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.xml
  def destroy
    @bid = Bid.find(params[:id])
    @bid.destroy

    respond_to do |format|
      format.html { redirect_to bids_url }
      format.xml  { head :ok }
    end
  end
end
