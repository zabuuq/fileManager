/**
* Define file manager directory and files.
* 
* @NOTE
* In order for the AJAX calls to work, the variable fileManagerDirectory needs to
* match the www directory where the File Manager application was placed.
**/
fileManagerDirectory = "/module/";
fileManagerComponent = fileManagerDirectory + "FileManager.cfc"
fileManagerFileLoad = fileManagerDirectory + "loadFile.cfm"

// Initialize the file upload plugin
function fileManagerInit(fileUpload, fileManagerBody, fmKeyId, fmUniqueId){
	var $fileUpload = $(fileUpload);

	$fileUpload.fileupload({
		dataType: "json"
		,url: fileManagerComponent + "?method=uploadFile&returnFormat=json"
		,done: function (e, data){
			if(data.result.success){
				fileManagerList(fileManagerBody, fmKeyId, fmUniqueId);
				fileManagerUpload(fileUpload);
			}
			else {
				alert(data.result.message)
			}
		}
	});
}

// Get the list of uploaded files
function fileManagerList(fileManagerBody, fmKeyId, fmUniqueId, allowDelete){
	var $fileManagerBody = $(fileManagerBody);
	var $fmKeyId = $(fmKeyId);
	var $fmUniqueId = $(fmUniqueId);
	var allowDelete = (allowDelete == null) ? true : allowDelete;

	$fileManagerBody.empty();

	$.ajax({
		url: fileManagerComponent
		,type: "post"
		,dataType: "json"
		,data: {
			method: "getUploadedFiles"
			,returnformat: "json"
			,fmKeyId: $fmKeyId.val()
			,fmUniqueId: $fmUniqueId.val()
		}
	}).done(function(d){
		for(x=0; x<d.data.fileList.length; ++x){
			$attClone = $fmRow.clone();
			$attClone.find("td.file-manager-name").html("<a href='" + fileManagerFileLoad + "?fmUploadId=" + d.data.fileList[x].fmUploadId + "'>" + d.data.fileList[x].fmFileName + "</a>");

			if(allowDelete){
				$attClone.find(".file-manager-delete")
					.attr("fm-upload-id", d.data.fileList[x].fmUploadId)
					.click(function(){
						fileManagerDelete($(this).attr("fm-upload-id"), fileManagerBody, fmKeyId, fmUniqueId);
					});
			}
			else {
				$attClone.find(".file-manager-delete").parent().html("");
			}
			$fileManagerBody.append($attClone);
		}
	});
}

function fileManagerDelete(fmUploadId, fileManagerBody, fmKeyId, fmUniqueId){
	$.ajax({
		url: fileManagerComponent
		,type: "post"
		,dataType: "json"
		,data: {
			method: "deleteFile"
			,returnformat: "json"
			,fmUploadId: fmUploadId
		}
	}).done(function(d){
		fileManagerList(fileManagerBody, fmKeyId, fmUniqueId);
	});
}

function fileManagerUpload(fileUpload){
	// Place holder for a function to be called after a file is uploaded.
	// This function can be overwritten if needed.
	var $fileUpload = $(fileUpload);
}
