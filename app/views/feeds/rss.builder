xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "Design Breakdown Notebook"   
    xml.description "A daily notebook/blog of notes from the mind of Bookworm AKA Ken Erickson."
    xml.link  "http://#{env['HTTP_HOST']}"
    xml.language "en-en"
    for post in @posts
      xml.item do
        xml.pubDate post.updated_at.rfc822
        xml.title post.title
        xml.link "http://#{env['HTTP_HOST']}" + url(:posts, :show, :slug => post.slug)
        xml.guid "http://#{env['HTTP_HOST']}" + url(:posts, :show, :slug => post.slug)  
        if post.respond_to?('intro')
          xml.description post.intro + "\n <a href='http://#{env['HTTP_HOST'] + url(:posts, :show, :slug => post.slug)}'> Read More </a>"   
        elsif post.respond_to?('quote')
          xml.description post.quote
        elsif post.respond_to?('commentary'
          xml.description post.commentary    
        end  
      end    
    end 
  end   
end