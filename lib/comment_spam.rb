# Runs a spam check using defensio   

class CommentSpam
  @queue = :comments 
  
  def self.perform(commentID, request)        
    Akismet.key    = ENV["AKISMET_KEY"]
    Akismet.blog   = 'http://' + ENV['DOMAIN']
    Akismet.logger = Padrino.logger
        
    @comment = Comment.first(:id => commentID)   
    @post    = Post.first(:id => @comment.post_id)     
    @comment.spam = Akismet.spam?(akismet_attributes, request)       
    @comment.checked = true      
    if @comment.spam == false 
      @comment.save 
      @post.comment_count = @post.comment_count + 1  
      @post.save
    else 
      @comment.destroy  
    end
  end  
  
  def self.akismet_attributes
    {
      :comment_author       => @comment.name,
      :comment_author_url   => @comment.url,
      :comment_author_email => @comment.email,
      :comment_content      => @comment.comment,
      :permalink            => "http://notebook.designbreakdown.com/#{@post.slug}"
    }
  end
end