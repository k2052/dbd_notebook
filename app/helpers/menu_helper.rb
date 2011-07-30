DbdNotebook.helpers do   
  
  def menu_builder(page, menuitems = nil)        
    if !@page.blank?
      page = @page
    end
    if menuitems == nil    
      menu_items = [
          { :name => :home,     :id => :blog,     :url => 'http://' + ENV['DOMAIN'], :text => 'Home'}, 
          { :name => :about,    :id => :about,    :url => '/about',                          :text => 'About'}, 
          { :name => :contact,  :id => :contact,  :url => '#contact_popup',                  :text => 'Contact'},
        ]                                  
    else
      menu_items = menuitems
    end                              
    content = ""   
    menu_items.each do |item|  
      content << if page == item[:name]       
        tag('li', :content => tag('a',  :content => item[:text], :id => "#{item[:id]}", :href => nil ),  :class => "active #{item[:id]}")   
      else                                                        
        tag('li', :content => tag('a',  :content => item[:text], :id => "#{item[:id]}", :href => "#{item[:url]}" ), :class => "#{item[:id]}")
      end   
    end
    tag(:ul, :content => content, :class => 'menu')    
  end   
end