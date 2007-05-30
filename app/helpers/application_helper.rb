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
  
end
