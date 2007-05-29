class BidsController < ApplicationController
  # GET /bids
  # GET /bids.xml
  def index
    @auction = Auction.find(params[:auction_id], 
            :include => :nfl_player)   
             
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
    @bid = Bid.new
  end

  # GET /bids/1;edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
    @bid = Bid.new(params[:bid])

    respond_to do |format|
      if @bid.save
        flash[:notice] = 'Bid was successfully created.'
        format.html { redirect_to bid_url(@bid) }
        format.xml  { head :created, :location => bid_url(@bid) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bid.errors.to_xml }
      end
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
