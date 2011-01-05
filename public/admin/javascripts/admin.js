
function uploader() 
{
  var uploadPath;
  uploadPath = $('#pickfiles').attr('href'); 
  
  var uploader = new plupload.Uploader({
		runtimes : 'html5',
		browse_button : 'pickfiles',
		container : 'file_form',
    url :  uploadPath,
    max_file_size : '50mb',
    chunk_size : '1mb',
    unique_names : true,  
    multipart: true,
		filters : [
			{title : "Image files", extensions : "jpg,gif,png"}, 
			{title : "Video files", extensions : "flv,avi,mov"},  
		],
	}); 
	
	uploader.bind('Init', function(up, params) {
		$('#file_form .filelist').html("<div>Current runtime: " + params.runtime + "</div>");
	});

	$('#file_form .uploadfiles').click(function(e) {
		uploader.start();
		e.preventDefault();
	});

	uploader.init();

	uploader.bind('QueueChanged', function(up) {
		$.each(up.files, function(i, file) {
			$('#file_form .filelist').append(
				'<div id="' + file.id + '">' +
				file.name + ' (' + plupload.formatSize(file.size) + ') <b></b>' +
			'</div>');
		});
	});

	uploader.bind('UploadProgress', function(up, file) {
		$('#' + file.id + " b").html(file.percent + "%");
	});

	uploader.bind('Error', function(up, err) {
		$('#file_form .filelist').append("<div>Error: " + err.code +
			", Message: " + err.message +
			(err.file ? ", File: " + err.file.name : "") +
			"</div>"
		);
	});

	uploader.bind('FileUploaded', function(up, file) {
		$('#' + file.id + " b").html("100%");
	});
  
}



$(document).ready(function() {   
  if($('#file_form')) { 
    uploader();
  }
});
