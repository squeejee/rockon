class LeaguesController < ApplicationController
  # GET /leagues
  # GET /leagues.xml
  require 'hpricot'
  require 'open-uri'
  
  before_filter :login_required
#  before_filter :commish_required
  
  def index
    @leagues = League.find(:all)

    @players = Hpricot.XML(open("http://football9.myfantasyleague.com/2007/export?TYPE=rosters&L=18664&W=")) 

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @leagues.to_xml }
    end
  end

  # GET /leagues/1
  # GET /leagues/1.xml
  def show
    @league = League.find(params[:id])
#    doc = Hpricot.XML(open("http://football9.myfantasyleague.com/2007/export?TYPE=league&L=18664&W="))
    
#    doc = Hash.from_xml(open("http://football9.myfantasyleague.com/2007/export?TYPE=topAdds&L=18664&W="))
    
#    Hash.create_from_xml open("http://football9.myfantasyleague.com/2007/export?TYPE=league&L=18664&W=")
    
#    (doc/:league).each do |league|
#      league.attributes do |attr|
#        attr
#      end
#    end

#    doc = Hpricot.parse(open("http://football9.myfantasyleague.com/2007/export?TYPE=league&L=18664&W="))
    
#    (doc/:league).each do |xml_league|
#      for fields in FIELDS
#        league[field] = (xml_league/field.intern).first
#      end
#    end
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @league.to_xml }
    end
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1;edit
  def edit
    @league = League.find(params[:id])
  end

  # POST /leagues
  # POST /leagues.xml
  def create
    @league = League.new(params[:league])

    respond_to do |format|
      if @league.save
        flash[:notice] = 'League was successfully created.'
        format.html { redirect_to league_url(@league) }
        format.xml  { head :created, :location => league_url(@league) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league.errors.to_xml }
      end
    end
  end

  # PUT /leagues/1
  # PUT /leagues/1.xml
  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        flash[:notice] = 'League was successfully updated.'
        format.html { redirect_to league_url(@league) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @league.errors.to_xml }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.xml
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url }
      format.xml  { head :ok }
    end
  end
end
