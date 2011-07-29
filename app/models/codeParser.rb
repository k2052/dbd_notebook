module CodeParser
  
  def parse_codeblocks()
    github_codeblock_match = /(^`{3,3}\s*?(.*?)\n(.*?)^`{3,3})/m      
    snippets = self.body.scan(github_codeblock_match)         
    snippet_replaces = []
    snippets.to_a.each_with_index do |snippet, index|   
      title = "snippet-#{self.title}_#{index}"  
      raw = snippet[2]       
      code = Code.first(:title => title) 
      if code && !code.raw == raw         
         code.raw = raw 
         code.save
      end
      unless code  
        code = Code.new(:raw => raw, :type => snippet[1].rstrip, :title => title) 
        code.save  
      end
      snippet_replaces << [snippet[0], Slim::Template.new('app/views/codes/snippet.slim').render(code)]
    end    
    snippet_replaces.each do |snippet|
      self.body.gsub!(snippet[0], snippet[1])
    end
  end 
end