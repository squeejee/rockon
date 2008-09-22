# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # add div, label, and help text layout for each field
  def detail_text_field(object_name, method, caption, helptext="", options={})
    render :partial => "layouts/detail_field", :locals => {:object_name => object_name, :method => method, :caption => caption, :helptext => helptext, :field => text_field(object_name, method, options)}
  end
  
  def detail_password_field(object_name, method, caption, helptext="", options={})
    render :partial => "layouts/detail_field", :locals => {:object_name => object_name, :method => method, :caption => caption, :helptext => helptext, :field => password_field(object_name, method, options)}
  end

  def detail_collection_select(object_name, method, collection, value_method, text_method, caption, helptext="", options={}, html_options={})
    render :partial => "layouts/detail_field", 
           :locals => 
                    {:object_name => object_name, 
                     :method => method, 
                     :collection => collection,
                     :value_method => value_method,
                     :text_method => text_method,
                     :caption => caption, 
                     :helptext => helptext, 
                     :field => collection_select(object_name, method, collection, value_method, text_method, options, html_options)
                     }
  end
  
  def display_bid_link()
    render :inline => "<%=link_to bid.top_bidder.user.id == current_user ? 'Edit Bid' : 'New bid', new_auction_bid_path(@auction) if @auction.active? %>"
  end
    
  def breadcrumbs
    r = []
    r << link_to("Home", "/")
    url = request.path.split(';')
    segments = url[0].split('/') 
    segments << url[1].humanize unless url[1].nil?
    segments.shift
    
    #segments.delete_if {|s| %w(users stores).include?(s); segments.delete}
    
    segments.each_with_index do |segment, i|   
          
      if logged_in?                        
          case segments[i]
           when "stores"
             next
           when "users"
             next 
            when "memberships"
              if !current_user.store_owner?
                next
              end
          end
            
          if segment.to_i > 0               
            
            case segments[i-1]
              when "memberships"
                segment = @membership.user.full_name
              when "stores"
                if !current_user.store_owner?
                  next
                else
                  segment = @store.name
                end
              when "users"
                segment = @user.full_name
             end            
          end
       else                             
           case segments[i-1]
             when "pickup"
               next
           end
       end
            
      title = segment.gsub(/-/, ' ').titleize
      r << link_to_unless_current(title, "/" + 
           (0..(i)).collect{|seg| segments[seg]}.join("/"))
           
    end

    return content_tag("div", r.join(" &raquo; "), :id => "breadcrumbs") 
           
  end   

end
