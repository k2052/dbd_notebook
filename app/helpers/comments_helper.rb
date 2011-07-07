DbdNotebook.helpers do    
  
  # Recursively loops over comments. 
  # Used for outputting the comment threads. 
  # You need to make sure you have set a instance var called @comments_render before using this method.
  # Then to output the comments jsut use %elem= @comments_render
  def loop_comments(comments)  
    comments.each_with_index do |@comment, index|     
      @comments_render += "<li id='#{@comment.id}' class='comment'>"
      @comments_render += partial "comments/comment"     
      if !@comment['comments'].empty?   
        @comments_render += "<ul class='depth_#{@comment.depth}'>"
        loop_comments(@comment['comments'])     
        @comments_render += '</ul>'   
        @comments_render += '</li>'   
      else 
        @comments_render += '</li>'   
      end
    end
  end       
  
  def gen_request_hash()
    ret_hash = { 
      :remote_ip => @env['REMOTE_ADDR'], 
      :headers => { 
        'USER_AGENT'      => @env['USER_AGENT'],  
        'REFERER'         => @env['REFERER'],  
        'REMOTE_ADDR'     => @env['REMOTE_ADDR'],  
        'CLIENT_IP'       => @env['CLIENT_IP'],  
        'X_FORWARDED_FOR' => @env['CONNECTION'],  
        'CONNECTION'      => @env['CONNECTION'], 
      }
    }  
    return ret_hash
  end
end