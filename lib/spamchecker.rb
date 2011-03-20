# Runs a spam check using defensio   

class CommentSpam < Struct.new(:commentID)
  def perform     
    comment = Commend.first(:id => commentID) 
    Defender.api_key = ENV['DEFENSIO_KEY']
    document         = Defender::Document.new  
    
    document.data[:content]        = comment.cmnt_src
    document.data[:type]           = 'comment'
    document.data[:platform]       = 'test' 
    document.data[:author_email]   = comment.email
    document.data[:author_name]    = comment.name
    document.data[:author_url]     = comment.url
    document.data[:async]          = true    
    document.data[:async_callback] = "http://notebook.designbreakdown.com/comments/validate/#{comment.id}"  
  end
end