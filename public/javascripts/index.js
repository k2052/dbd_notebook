var converter = new Showdown.converter();   

/** Font Handling **/
font.setup(); // run setup when the DOM is ready      
if(font.isInstalled('Museo') == false) {   
  head.js("http://assets0-notebook.designbreakdown.com/js/cufon.js", "http://assets0-notebook.designbreakdown.com/js/Muse.font.js", function() {     
    Cufon.replace('#posts h1, #post h1, #posts .via .label, #post .via, .label nav li a, .project_title, .date #posts blockquote:before, #post blockquote:before', { fontFamily: 'Muse'});
  });  
}  

$(document).ready(function () {                    
  
  $('.close').click(function() {
    $(this).parent().parent().fadeOut('slow');
  });             
  
  $('nav #contact').click(function() {
    $('#contact_details').fadeIn('slow');    
  });     
  
  $('#switcher a').click(function() { 
    $('#switcher a').not(this).removeClass('active');
    $(this).addClass('active');    
    $('#day_night').removeClass().addClass($(this).attr('id'));
  });    
  $('.nivo_slider').nivoSlider({ pauseTime:5000, pauseOnHover:false });
   
  /**
   * Handles the viewing of notes in task and lists.     
   * @todo Add a loading gif or something. 
   * On certaing clients and wiht large notes parsing the makrdown might noticelably lag.
   **/
  $('.view_note').click(function() {  
    
    /**
     * Overlay div. Dark and Evil goodness. Don't you just love a good oxymoron? 
     * It gives me anaawesome feeling; or is that oxycotin I'm thinking of?  
     * Drug humor -- definitely something you don't expect to find in JS comments.
     **/ 
    var darkness = '<div id="darkness" style="display: none; cursor: pointer; '
                 + ' position: absolute; height: auto; width: 920px; z-index:500;"></div>';  
    $('body').prepend(darkness);  
    
    var offset = $(this).parent().offset();
    offsetTop = offset.top;  
    offsetLeft = offset.left;
    $('#darkness').css({ top : offsetTop + 25, left : offsetLeft - 70})         
    
    /** Note Markup Grabbing **/
    var noteTxt    = $(this).next().html(); 
    noteTxt        = converter.makeHtml(noteTxt);          
    noteTxt = '<div class="note">'+ noteTxt + '</div>';
        
    /** Note Div Markup Created Here cause I was too lazy to use mustache **/
    var noteMarkup = '<div id="note_popup"> <div class="note_wrap"> <div class="top"></div> <div class="middle">' + noteTxt 
      + '</div> <div class="bottom_wrap"> <div class="bottom"></div> </div> </div> <div id="close_popup_wrap">'
      + '<a href="#" id="close_note"><span class="icon hideTxt"></span><span class="label"> Close Note</span></a></div> </div>';  
    
    $('#darkness').append(noteMarkup);
    $('#darkness').fadeIn('slow');    
    $('#close_note').click(function() {   
      $('#darkness').fadeOut('slow').remove();    
      return false;
    });
    return false;
  });  
  
  $('.link_to_top').click(function() { 
	  $.scrollTo('#top', 400, {easing:'easeInQuad'}); 
	  return false;
	});    
	
	$('#read_license').click(function() {
	  $('#license_wrap').fadeIn('slow');  
	  return false;
	});
});