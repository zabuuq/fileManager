$(document).ready(function(){
	// Grab all the elements on the page that will be used for the application.
	$fileUpload = $("#fileUpload");
	$fileManagerBody = $("#fileManagerBody");

	$fmKeyId = $("#fmKeyId");
	$fmUniqueId = $("#fmUniqueId");

	$fmRow = $(".file-manager-row").first().detach();

	fileManagerInit($fileUpload, $fileManagerBody, $fmKeyId, $fmUniqueId);
	fileManagerList($fileManagerBody, $fmKeyId, $fmUniqueId, true);
});
