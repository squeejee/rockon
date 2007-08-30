class BidsController < ApplicationController
  # GET /bids
  # GET /bids.xml
  
  require 'date'
  
  helper :auctions
  
  def index
    @auction = Auction.find(params[:auction_id], :include => :nfl_player)   
             
    @bids = Bid.find(:all, :conditions => {:auction_id => params[:auction_id]}, 
            :include => [:nfl_player, :user],
            :order => "bids.price desc")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @bids.to_xml }
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

    unless @bid.max_price.nil?
      if @bid.max_price <= @top_bid.price   
        winning_bidder = false       
      elsif @bid.max_price == @top_bid.max_price  
        winning_bidder = false
        @bid.price = @bid.max_price - 1
        @existing_bid.price = @bid.max_price
        @bid.save and @existing_bid.save
      elsif @bid.max_price < @top_bid.max_price  
        winning_bidder = false
        @bid.price = @bid.max_price
        @existing_bid.price = @bid.max_price + 1
        @bid.save and @existing_bid.save
      else  
        winning_bidder = true
        @bid.price = @top_bid.max_price + 1
        @existing_bid.price = @top_bid.max_price
        @bid.save
      end
    end
    
    respond_to do |format|      
      flash[:notice] = "Congratulations!  You are now the top bidder!" if winning_bidder
      flash[:notice] = "Whoops!  You are going to have to bid higher than $#{@bid.max_price}!" if !winning_bidder
      format.html { redirect_to auction_url(@auction) + "/bids" }
      format.xml  { head :created, :location => bid_url(@bid) }
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
