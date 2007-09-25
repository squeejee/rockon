class KittiesController < ApplicationController
  # GET /kitties
  # GET /kitties.xml
  def index
    @kitties = Kitty.balance

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @kitties.to_xml }
    end
  end

  # GET /kitties/1
  # GET /kitties/1.xml
  def show
    @kitty = Kitty.find(:all, :conditions => ["user_id = ?", params[:id]], :order=>"week_no")
        
    @league_due = Kitty.sum_league_due(params[:id])
    @league_owes = Kitty.sum_league_owes(params[:id])
    @league_received = Kitty.sum_league_received(params[:id])
    @league_paid = Kitty.sum_league_paid(params[:id])
    @user_balance = (@league_received.to_i + @league_owes.to_i) - (@league_due.to_i + @league_paid.to_i)
  end

  # GET /kitties/new
  def new
    @kitty = Kitty.new
  end

  # GET /kitties/1;edit
  def edit
    @kitty = Kitty.find(params[:id])
  end

  # POST /kitties
  # POST /kitties.xml
  def create
    @kitty = Kitty.new(params[:kitty])

    respond_to do |format|
      if @kitty.save
        flash[:notice] = 'Kitty was successfully created.'
        format.html { redirect_to kitty_url(@kitty) }
        format.xml  { head :created, :location => kitty_url(@kitty) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kitty.errors.to_xml }
      end
    end
  end

  # PUT /kitties/1
  # PUT /kitties/1.xml
  def update
    @kitty = Kitty.find(params[:id])

    respond_to do |format|
      if @kitty.update_attributes(params[:kitty])
        flash[:notice] = 'Kitty was successfully updated.'
        format.html { redirect_to kitty_url(@kitty) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @kitty.errors.to_xml }
      end
    end
  end

  # DELETE /kitties/1
  # DELETE /kitties/1.xml
  def destroy
    @kitty = Kitty.find(params[:id])
    @kitty.destroy

    respond_to do |format|
      format.html { redirect_to kitties_url }
      format.xml  { head :ok }
    end
  end
end
