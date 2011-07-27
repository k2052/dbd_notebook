require 'nokogiri'
class Default < Post
  include MongoMapper::Document

  # Keys      
  key :body,  String      
  key :intro, String

  # Key Settings
  slug_key :title, :unique => true
  markdown :body, :intro, :parser => 'kramdown'   
  
  # Callbacks
  before_save   :parse_snippets
  before_update :parse_snippets           
  
  private         
    # Parses a <snippet> tag in the body and creates code posts for each one.
    # A snippet tag should take the following structure
    # <snippet title="Snippet Title" type="type of code to process">
    # </snippet>
    # The attributes are required. 
    # There is no graceful failing on missing attributes so this is definitely not ready for end users.
    # Plus its not sanitized and vulnerable to XSS, 
    # but you already knnew that because your not throwing random github code einto production without checking it first right? 
    def parse_snippets()  
      @doc = Nokogiri::HTML::fragment(self.body)      
      snippets = @doc.css("snippet") 
      return if snippets.empty?    
      new_snippets = []
      snippets.each do |snippet|  
        snippet_push = {:type => snippet['type'], :title => snippet['title'], :content => snippet.content, :end_tag => '</snippet>'}    
        new_snippets.push(snippet_push)
      end             
      snippets = nil  
      new_snippets.each_with_index do |snippet, index|    
        find = Post.first(:title => "#{self.title}: Snippet - #{snippet[:title]}")       
        if find == nil
          snippet_obj       = Code.new  
          snippet_obj.title = "#{self.title}: Snippet - #{snippet[:title]}"   
          snippet_obj.type  = snippet[:type]      
          snippet_obj.raw   = snippet[:content]
          snippet_obj.save
          new_snippets[index][:obj] = snippet_obj 
        else 
          new_snippets[index][:obj] = find 
        end
      end 
      new_snippets.each do |snippet|   
        prepend = "<div class='snippet'><div class='snippet_top'></div><div class='snippet_middle'>"
        prepend << "<div class='tools'><div class='copy_wrap'>"   
        prepend << "<a href='/codes/"
        prepend << snippet[:obj]['slug']
        prepend << "/raw'" 
        prepend << "class='copy_snippet'>Copy</a>"
        prepend << "<a href='#' class='expand_snippet hideTxt'>Expand</a>"
        prepend << "</div></div>"     
        append = "</div><div class='snippet_bottom_wrap'><div class='snippet_bottom'></div></div></div>"   
        snippetdoc = @doc.css("snippet[title='#{snippet[:title]}']").first     
        snippetdoc.replace prepend + snippet[:obj]['processed'] + append    
      end        
      @snippet_src = @doc.to_html   
      @doc = nil
    end
end