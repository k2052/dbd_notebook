require 'nokogiri'
class Default < Post
  include MongoMapper::Document

  # Key
  key :body,      String
  key :body_src,  String
  key :intro,     String
  key :intro_src, String
  
  # Key Settings
  slug_key :title, :unique => true  
  
  # Callbacks
  before_save   :parse_snippets, :generate_rendered
  before_update :parse_snippets, :update_rendered               
  
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
      return if body_src.blank? 
      @doc = Nokogiri::HTML::fragment(self.body_src)      
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
    
    def generate_rendered()         
      return if body_src.blank? || intro_src.blank?      
      if self.body.blank? && @snippet_src.blank?
        self.body = Kramdown::Document.new(self.body_src).to_html           
      elsif self.body.blank? && !@snippet_src.blank?
        self.body = Kramdown::Document.new(@snippet_src).to_html    
      end   
      if self.intro.blank?  
        self.intro = Kramdown::Document.new(self.intro_src).to_html 
      else
        return
      end
    end  
     
    def update_rendered()         
      return if body_src.blank? || intro_src.blank?           
      if @snippet_src.blank?
        self.body = Kramdown::Document.new(self.body_src).to_html           
      else
        self.body = Kramdown::Document.new(@snippet_src).to_html  
      end
      self.intro = Kramdown::Document.new(self.intro_src).to_html   
    end  
  
end