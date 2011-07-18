// Var Declarations
$(document).ready(function() { 
    
  // Ajax and Labelify 
	$('#comment_form input').labelify();         
	$('#comment_form').ajaxForm({   
	  dataType: 'json',
	  success: commentResponse
  });

	$('#switch_vertical').click(function() {
	  $('#comment_form_wrap').removeClass('horizontal');
	  $('#comment_form_wrap').addClass('vertical');     
	  return false;   
	});
	$('#switch_horizontal').click(function() {
	  $('#comment_form_wrap').removeClass('vertical');
	  $('#comment_form_wrap').addClass('horizontal'); 
	  var offset = $('#comment_XXX').offset();
	  offset = offset.top;
	  $('#comment_forms').css( 'top', offset + $('#comment_XXX').height());    
	  return false;
	});       
   
  /**
   ** Auto Complete 
   **/       
   
  // Create the autocomplete data 
	var sourcearray = new Array();
	$('.comment .name').each(function(){
		sourcearray.push('@' + $(this).text());
	});
  sourcearray = unique(sourcearray);
  sourcearray.sort(charOrdA);     
   
  // Declare autocomplete
  $("#comment_author_hidden").autocomplete(sourcearray);  
  
  // Autocompalte callback/main function
  $("#comment_author_hidden").result(function(event, data, formatted) {
    var currenttext = $('#comment_cmnt_src').val();
    var endchar = currenttext.substring(currenttext.length, currenttext.length);
    if (endchar = '@') {
      currenttext = currenttext.substring(0, currenttext.length-1);
    }
    currenttext = currenttext + $('#comment_author_hidden').val();	
    
    $('#comment_cmnt_src').val(currenttext);
    $('#comment_author_hidden').val('');
    $('#comment_cmnt_src').focus();    
  });     
	
	
	/**
	 * Comment Form
	 **/
	$('#comment_cmnt_src').keyup(function(event) {
    var code = (event.keyCode ? event.keyCode : event.which); 
              
    //@ Keypress
    if (code.toString() == '50' && event.shiftKey) 
    {    
      $('#comment_author_hidden').val('@').focus();
      e = $.Event("keydown");
      e.which = 40 ;
      $("#comment_author_hidden").trigger(e);       
    }
    else 
    {     
      var charCountVal = $('#comment_form_wrap .char_count .count').text();
      charCountVal     = 300 - $(this).val().length;  
      $('#comment_form_wrap .char_count .count').text(charCountVal);  
      if(charCountVal < 0) {
        $('#comment_form_wrap .button').attr('disabled', 'disabled'); 
      } 
      else { 
        $('#comment_form_wrap .button').removeAttr('disabled'); 
      }            
      updatePreviewComment();  
    }    
    
    return true;   
	});
	  
  $('.comment_reply_link').click(function() { 
    
    // Removie Preview and store for later     
    var previewComment = $('#comment_XXX');    
    var previewCommentHeight = $('#comment_XXX').height();
    if($('#comment_XXX:visible')) {
      $('#comment_XXX').fadeOut('fast');
    }   
  	$('#comment_XXX').remove();  
  	
  	// Remove class from any active reply.      
  	var currentComment = $(this).parent().parent().parent();    
  	
  	// Prevent removal of preview by clicking reply button multiple times
    $('li.replying').removeClass('replying');  
    
    // Current Comment
    currentComment.addClass('replying');   
    $('#comment_parent_id').val(currentComment.attr('id'));   
    $('#comment_form_wrap:hidden').fadeIn('slow');  
    
    // Reposition Comment Form
    var offset;         
    if($('#comment_form_wrap').hasClass('vertical') == true) { 
      offset = currentComment.offset(); 
      offset = offset.top;   
    } else {
      offset = currentComment.offset(); 
      offset = offset.top + currentComment.children('#comment_wrap').height() + 239; 
    }  
    offset = Math.round(offset);   
    $('#comment_forms').css({ top: offset }); 
      
    /**
     * Preview Output
     **/    
     
		// Add Child UL  
	  if(currentComment.children('ul').length > 0) { 
	    // Do nothig
	  } else {    
	    var depth = currentComment.parent().attr('class'); 
	    if(depth == null) {
	      depth = 0; 
	    } else {
	      depth = depth.substring(6); 
  	    depth = parseInt(depth) + 1;
	    }    
	    var childrenUL = '<ul class="depth_' + depth + '"></ul>';
	    currentComment.append(childrenUL);
	  }  
	  var offset = offset - previewCommentHeight;    
	  $.scrollTo(offset, 300, {easing:'easeInQuad'});        
	  
		// Append Preview
		$('#' + currentComment.attr('id') + ' > ul').prepend(previewComment);  
		$('#comment_XXX').fadeIn('slow');           
		
    return false;      
  });     
  
  $('.write_comment').click(function() {     
    $('#comment_XXX').show().fadeIn('slow'); 
    $('#comment_parent_id').val('');          
    var commentPreviewOffset = $('#comment_XXX').offset();
    commentPreviewOffset = commentPreviewOffset.top;      
    if($('#comment_form_wrap').hasClass('horizontal'))  {    
      $('#comment_forms').css('top', commentPreviewOffset + 50 );
    } else {
      $('#comment_forms').css('top', commentPreviewOffset);  
    }
    $('#comment_form_wrap:hidden').fadeIn('slow');  
    return false;      
  });  
  
  $('#comment_close').click(function() {
    $(this).parent().parent().parent().fadeOut('slow'); 
    $('#comment_XXX').fadeOut('fast');
    $('#comment_parent_id').val(''); 
    console.log($('li.replying'));      
    if($('li.replying').hasClass('replying'))  {
      var previewComment = $('li.replying #comment_XXX');  
      $('li.replying').removeClass('replying'); 
      $('#comment_XXX').remove();
      $('ul#comments_list').prepend(previewComment);
    }
    return false;
  });  
  
  $('.expand_snippet').toggle(function() {  
    var pre = $(this).parent().parent().parent().children('.CodeRay').children().children(); 
    var animate = $(this).parent().parent().parent().children('.CodeRay').children();     
    var toHeight = $(pre).height();   
    $(this).addClass('collapse_snippet');      
    $(animate).animate({
      height: toHeight
    }, 1000, function() {
    });     
    return false;
  }, function() {      
    $(this).removeClass('collapse_snippet');
    var animate = $(this).parent().parent().parent().children('.CodeRay').children();     
    $(animate).animate({
      height: 300
    }, 1000, function() {
    }); 
    return false;
  }); 
});   

function commentResponse(resp)
{
   var errorMessage = '<div class="form_resp ' + resp.errorCode + '"><div class="message">' + resp.message
                    + '</div><a href="#" class="close_me">X</a></div>';    
  $('#comment_form_wrap form').animate({ "opacity": 0.2 }, 300);    
  $('#comment_form_wrap').prepend(errorMessage);  
  $('.form_resp .close_me').click(function() { 
    $(this).parent().fadeOut(300).remove();   
    $('#comment_form_wrap form').animate({ "opacity": 1.0 }, 300);
  });
}

function updatePreviewComment() {  
  var commentTxt    = $('#comment_cmnt_src').val();
  commentTxt        = converter.makeHtml(commentTxt);  
 	var commentAuthor = $('#comment_name').val();
 	var commentURL = $('#comment_url').val();
  if (!(commentURL=='') && !(commentURL =='Site URL')) {
    $('#comment_XXX .name a.author').attr('href',commentURL);
  }
	$('#comment_XXX .comment').html(commentTxt);  
	
	// Reposition Horizontal Comment Form  
	if($('#comment_form_wrap').hasClass('horizontal')) {    
	  var offset     = $('#comment_XXX .meta_bottom').offset();
	  offset = offset.top + $('#comment_XXX .meta_bottom').height();
	  offset = Math.round(offset);
	  $('#comment_forms').css({ top: offset }); 
	}
} 
