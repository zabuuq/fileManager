/**
* @description
* This is a web service file that will be called via AJAX by JavaScript for either uploading
* a file, getting a list of files, or deleting a file. It was designed against the jQuery 
* plugin uploadifive, but should work with any JavaScript AJAX.
* 
* The component loads the Entities related to the database tables that store the path 
* information, acceptable file types, and the uploaded files.
* 
* All methods take a variable called fmKeyName that refers to the calling code or application 
* that is calling this component.  This keyName is stored in the table dbo.FileManagerKey and is
* used to pull the uploaded file path location and the acceptable file mime types from another
* table called dbo.FileManagerMimeType.
* 
* Uploaded file information is stored in the table dbo.FileManagerUpload.
* 
* The some methods also take a variable called fmUniqueId that refers to the unique identifier 
* that the calling code uses to pair the uploaded file(s) to a unique item.
* 
* Example:
* An application stores a person's information and allows you to upload images along with the
* person's information.  In the application's database dbo.Person, each person has an identifier
* dbo.Person.personId.  For this component, that ID is the fmUniqueId used to pair a file with the 
* person.
* For the purposes of this example the application keyName will be "personApp".
* 
* If the application is uploading an image for a person with the personId of 245, the AJAX 
* call would pass the following parameters:
* {
* 	method: "uploadFile"
* 	,returnFormat: "json"
* 	,fmKeyId: 10
* 	,fmUniqueId: 245
* }
*/
component output=false {
	// Grab the root upload path for the server from Config.
	variables.rootUploadDir = getDirectoryFromPath( getCurrentTemplatePath() ) & "storage";
	variables.tempUploadDir = variables.rootUploadDir & "\temp";

	/**
	* This function initializes and returns the object.
	* */
	public function init(){
		// Check for the existence of the default directories.
		checkUploadDirectory(variables.rootUploadDir);
		checkUploadDirectory(variables.tempUploadDir);

		return this;
	}
	
	/**
	* This function uploads the file to its proper location and inserts the information into
	* the database.
	* 
	* AJAX Usage:
	* {
	* 	method: "uploadFile"
	* 	,returnFormat: "json"
	* 	,fmKeyId: [numeric APP_ID]
	* 	,fmUniqueId: [string APP_UNIQUE_ID]
	* }
	* 
	* @arg	required	any		fileUpload	- The file to be uploaded.
	* 										(any is used because there is not a proper data 
	* 										type for "files")
	* @arg	required	numeric	fmKeyId		- The ID the calling code/application.
	* @arg	required	string	fmUniqueId	- The unique identifier number.
	* 		The identifier fmUniqueId is required, but if the application does not have separate
	* 		unique parts that are identified by some sort of ID, then a zero (0) can be passed.
	* */
	remote struct function uploadFile(required any fileUpload, required numeric fmKeyId, required string fmUniqueId){
		// Returns the success, a message, and the new ID if one is created.
		var returnData = {
			"success": true
			,"message": "Upload Complete"
			,"data": {
				"fmUploadId": 0
			}
		};

		/**
		* Wrap everything in a try catch and transaction so if any part of the process fails, 
		* nothing will be stored in the database.  The catch will also check for the existence
		* of the file and delete it to avoid leaving orphaned files on the file server.
		* */
		transaction {
			try {
				/** 
				* Load the information for the application that is calling the File Manager based
				* on the Key Name passed (arguments.fmKeyId).
				* This loads the path information as well as the accepted file types from the database.
				* */
				var fileManagerKey = entityLoadByPK("FileManagerKey", arguments.fmKeyId);

				// Get the upload directory, if one is store, otherwise use the root directory.
				var fileUploadPath = (fileManagerKey.getFmKeyPath() == "") ? variables.rootUploadDir : fileManagerKey.getFmKeyPath();
				
				// Check for the upload directory's existence.
				checkUploadDirectory(fileUploadPath);

				// Get all the accepted file types from the database for the calling application.
				var fileUploadExtensions = "";
				for(mimeType in fileManagerKey.getFmMimeTypes() ){
					fileUploadExtensions = listAppend(fileUploadExtensions, mimeType.getFmMimeType() );
				}

				// Initially load the file in the temp directory, then rename and move it to its final directory later.
				fileUploadStruct = fileUpload(variables.tempUploadDir, "fileUpload", fileUploadExtensions, "MakeUnique");

				/** 
				* Add the file to the database and get the fileManagerUploadId.
				* The ID and the Key Name will be used to rename the file when moving it to its final location. 
				* Since this is in the transaction, if any errors occur, the data will be rolled back.
				* */
				var fileManagerUpload = entityNew("FileManagerUpload");
				fileManagerUpload.setFmUniqueId(arguments.fmUniqueId);
				fileManagerUpload.setFmFileName(cleanFileName(fileUploadStruct.clientFile) );
				fileManagerUpload.setFmFileExt(fileUploadStruct.serverFileExt);

				fileManagerUpload.setFileManagerKey(fileManagerKey);

				entitySave(fileManagerUpload);

				// Move the file from the temp directory to the final directory and rename it.
				var fileName = fileManagerKey.getFmKeyName() & "_" & fileManagerUpload.getFmUploadId() & "." & fileUploadStruct.serverFileExt;
				fileMove(fileUploadStruct.serverDirectory & "\" & fileUploadStruct.serverFile, fileUploadPath & "\" & fileName);

				// Do not place anything after this line that you want the try/catch to catch.
				transactionCommit();

				returnData.data.fmUploadId = fileManagerUpload.getFmUploadId();
			}

			// Errors where the file uploaded was not in the accepted file types.
			catch(coldfusion.tagext.io.FileUtils$InvalidUploadTypeException e){
				// Return the error message that says what file type was attempted and that it is not accepted.
				returnData = handleError(e, "The file type of the uploaded file (" & e.MimeType & ") was not accepted by the server.", "MimeType");
				returnData["acceptedMimeTypes"] = e.Accept;

				// Roll back any database transactions.
				transactionRollback();
			}
			
			// All other errors.
			catch(any e){
				returnData = handleError(e, "There was an error uploading your file.", "Generic");

				/** 
				* Attempt to delete the uploaded file.  If the file does not exist, then this will fail, 
				* therefore this is surrounded by a try catch as to not throw extra errors.
				* */
				try {
					var fileDelete = variables.tempUploadDir & "\" & fileUploadStruct.serverFile;
					fileDelete(fileDelete);
				}
				catch(any er){
					// No need to report error, it is likely due to the file not existing and that is acceptable.

					// Only dump if being run from the local machine.
					if(cgi.remote_host == "127.0.0.1"){
						writeDump(var: [fileDelete]);
						writeDump(var: er);
					}
				}
				
				// Roll back any database transactions.
				transactionRollback();
			}
		}
		
		return returnData;
	}

	/**
	* This function returns a list of files associated with the given Key Name and uniqueId.
	* 
	* See example above for the uploadFile method for an explaination of the uniqueId.
	* 
	* @arg	required	string	fmKeyId	- The name the calling code/application name.
	* @arg	required	string	fmUniqueId	- The unique identifier number.
	* */
	remote struct function getUploadedFiles(required numeric fmKeyId, required string fmUniqueId){
		// Returns the success, a message, and the ID(s) passed.
		var returnData = {
			"success": true
			,"message": "Uploaded file list:"
			,"data": {
				"fileList": []
			}
		};

		// Load the entity.
		returnData.data.fileList = entityLoad(
			"FileManagerUpload"
			,{
				fmKeyId: arguments.fmKeyId
				,fmUniqueId: arguments.fmUniqueId
			}
			,"fmFileName"
		);

		// Return the entity.
		return returnData;
	}

	/**
	* This function returns a list of files associated with the given Key Name and uniqueId.
	* 
	* See example above for the uploadFile method for an explaination of the uniqueId.
	* 
	* @arg	required	string	fmKeyId	- The name the calling code/application name.
	* @arg	required	string	fmUniqueId	- The unique identifier number.
	* */
	remote struct function getFileUploadInfo(required numeric fmUploadId){
		// Returns the success, a message, and the ID(s) passed.
		var returnData = {
			"success": true
			,"message": "Uploaded file:"
			,"data": {
				"fileUploadInfo": {}
			}
		};

		// Load the entity.
		var fileManagerUpload = entityLoadByPK("FileManagerUpload", arguments.fmUploadId);

		// If nothing is loaded, grab an new entity and fill it with empty items.
		if(isNull(fileManagerUpload) ){
			fileManagerUpload = entityNew("FileManagerUpload");

			fileManagerUpload.setFmUploadId(0);
			fileManagerUpload.setFmUniqueId("");
			fileManagerUpload.setFmFileName("");
			fileManagerUpload.setFmFileExt("");
			fileManagerUpload.setFmKeyId(0);
			fileManagerUpload.setFmKeyName("");
			fileManagerUpload.setFmFilePath("");

			fileManagerUpload.setFileManagerKey(entityNew("FileManagerKey") );
		}

		var fmFilePath = (fileManagerUpload.getFmFilePath() == "") ? variables.rootUploadDir : fileManagerUpload.getFmFilePath();
		fileManagerUpload.setFmFilePath(fmFilePath);

		returnData.data.fileUploadInfo = fileManagerUpload;

		// Return the entity.
		return returnData;
	}

	/**
	* This function deletes the file physically and from the database.
	* 
	* @arg	required	numeric	fmUploadId	- The ID of the file to be deleted.
	* */
	remote struct function deleteFile(required numeric fmUploadId){
		// Returns the success, a message, and the ID that was passed.
		var returnData = {
			"success": true
			,"message": "File Deleted."
			,"data": {
				"fmUploadId": arguments.fmUploadId
			}
		};

		/**
		* Wrap everything in a try catch and transaction so if any part of the process fails, 
		* nothing will be deleted from the database.  The catch will ignore errors where the
		* physical file does not exist.
		* */
		transaction {
			try {
				// Load the entity
				var fileManagerUpload = entityLoadByPK("FileManagerUpload", arguments.fmUploadId);

				// Build the file path and delete the file.
				var fileUploadPath = (fileManagerUpload.getFileManagerKey().getFmKeyPath() == "") ? variables.rootUploadDir : fileManagerUpload.getFileManagerKey().getFmKeyPath();
				var fileName = fileManagerUpload.getFileManagerKey().getFmKeyName() & "_" & fileManagerUpload.getFmUploadId() & "." & fileManagerUpload.getFmFileExt();

				// Delete the data from the database.
				entityDelete(fileManagerUpload);

				// Delete the file.
				fileDelete(fileUploadPath & "\" & fileName);

				// Do not place anything after this line that you want the try/catch to catch.
				transactionCommit();
			}
			catch(coldfusion.tagext.io.FileUtils$FileDoesNotExistException e){
				/**
				* This error is a file not found error.
				* In the case of a file not found error, then continue to delete the 
				* data from the database.
				* 
				* The file is already deleted for you!
				* */
				transactionCommit();
			}
			catch(any e){
				returnData = handleError(e, "There was an error deleting your file.", "Generic");
			}
		}

		return returnData;
	}

	/**
	* This function is a private function that checks for the existence of a directory and 
	* creates it if it does not exist.
	* 
	* @arg	required	string	fmUploadDir	- The directory path.
	* */
	private void function checkUploadDirectory(required string fmUploadDir){
		/**
		* Take the stored path and break it up by the "/".
		* Then step through each directory, starting with the root directory to make sure it exists.
		* If it does not exist, then create it.
		* */

		// First replace all "\" with "/" just in case.
		arguments.fmUploadDir = replaceNoCase(arguments.fmUploadDir, "\", "/", "ALL");

		var uploadDirArray = listToArray(arguments.fmUploadDir, "/");

		// Start with an empty string.
		var uploadDirCheck = "";

		// Loop through the path one directory at a time.
		for (dir in uploadDirArray){
			uploadDirCheck = uploadDirCheck & "/" & dir;

			// Check to see if the directory exists and create it if it doesn't.
			if(!directoryExists(uploadDirCheck) ){
				directoryCreate(uploadDirCheck);
			}
		}
	}

	/**
	* This function is a private function removes special characters from a File Name that
	* most operating systems do not like.
	* 
	* Even though the File Name is for display purposes, when a person downloads a file using 
	* this component, the file returned will use the stored File Name rather than the generated
	* one of [KEYNAME][FILEUPLOADID].[EXT].
	* 
	* @arg	required	string	fmFileName	- The File Name to be cleaned.
	* */
	private string function cleanFileName(required string fmFileName){
		// A list of characters to be removed from the File Name.
		var badCharacters = '|\?*<":>+[]/';

		// Initially set the Clean File Name to the name passed.
		cleanFileName = arguments.fmFileName;

		// Step through each bad character, one at a time.
		for(x=1; x<=len(badCharacters); ++x){
			// Replace each bad character with an empty string.
			cleanFileName = replaceNoCase(cleanFileName, mid(badCharacters, x, 1), "", "ALL");
		}

		return cleanFileName;
	}

	/**
	* This function changes the unique ID for a file to a new unique ID.
	* 
	* Can be used to move files from one item to another.  Can also be used to move files from
	* a temporary ID, when creating new items without IDs, to the permanent ID for the new item.
	* 
	* You can move an individual file by passing its fileManagerUploadId or you can move a group
	* of files with the same unique ID by not passing fileManagerUploadId.
	*  
	* @arg	required	string	oldUniqueId	- The current unique ID to move the file from.
	* @arg	required	string	newUniqueId		- The new unique ID to move the file to.
	* @arg	required	string	fmKeyId		- The keyName associated with the file(s).
	* @arg	optional	int		fmUploadId		- An individual file's fileManagerUploadId.
	* */
	remote struct function changeUniqueId(required string oldUniqueId, required string newUniqueId, required string fmKeyId, numeric fmUploadId){
		// Returns the success, a message, and the ID that was passed.
		var returnData = {
			"success": true
			,"message": "Unique ID updated."
			,"data": {
				"oldUniqueId": arguments.oldUniqueId
				,"newUniqueId": arguments.newUniqueId
			}
		};

		transaction {
			try {
				if(structKeyExists(arguments, "fmUploadId") ){
					var fileManagerUpload = entityLoad(
						"FileManagerUpload"
						,{
							fmKeyId: arguments.fmKeyId
							,fmUniqueId: arguments.oldUniqueId
							,fmUploadId: arguments.fmUploadId
						}
					);
				}
				else {
					var fileManagerUpload = entityLoad(
						"FileManagerUpload"
						,{
							fmKeyId: arguments.fmKeyId
							,fmUniqueId: arguments.oldUniqueId
						}
					);
				}

				for(aFile in fileManagerUpload){
					aFile.setFmUniqueId(arguments.newUniqueId);
					entitySave(aFile);
				}
			}
			catch(any e){
				returnData = handleError(e, "There was an error updating the UniqueId.", "Generic");
			}
		}

		return returnData;
	}

	/**
	* This gets information for a key.
	* 
	* @arg	required	numeric	fmKeyId	- The fmKeyId of the key.
	* */
	remote struct function getKeyInfoById(required numeric fmKeyId){
		// Returns the success, a message, and the ID(s) passed.
		var returnData = {
			"success": true
			,"message": "Key Information:"
			,"data": {
				"keyInfo": {}
			}
		};

		transaction {
			try {
					returnData.data.keyInfo = entityToQuery(entityLoad("FileManagerKey", {fmKeyId: arguments.fmKeyId}) );
			}
			catch(any e){
				returnData = handleError(e, "There was an error retrieving the key information.", "Generic");

				// Roll back any database transactions.
				transactionRollback();
			}
		}

		return returnData;
	}

	/**
	* This gets information for a key.
	* 
	* @arg	required	string	fmKeyName	- The fmKeyName of the key.
	* */
	remote struct function getKeyInfoByName(required string fmKeyName){
		// Returns the success, a message, and the ID(s) passed.
		var returnData = {
			"success": true
			,"message": "Key Information:"
			,"data": {
				"keyInfo": {}
			}
		};

		transaction {
			try {
					returnData.data.keyInfo = entityToQuery(entityLoad("FileManagerKey", {fmKeyName: arguments.fmKeyName}) );
			}
			catch(any e){
				returnData = handleError(e, "There was an error retrieving the key information.", "Generic");

				// Roll back any database transactions.
				transactionRollback();
			}
		}

		return returnData;
	}

	/**
	* This function handles logging error messages and returns the returnData structure.
	* 
	* @arg	required	any	errorObj			- The new unique ID to move the file to.
	* @arg	required	string	errorMsg		- The error message to be displayed.
	* @arg	required	string	errorType		- The error type to be displayed.
	* */
	private struct function handleError(required any errorObj, required string errorMsg, required string errorType){

		writeLog(text:"FileManager error. Message: " & arguments.errorObj.message & " details: " & arguments.errorObj.detail, file:"file-manager", type:"error" );

		// If being run from the local machine, add extra to the error message returned.
		if(cgi.remote_host == "127.0.0.1"){
			returnData = {
				"success": false
				,"message": arguments.errorObj.message
				,"data": {
					"errorType": arguments.errorType
					,"errorObj": arguments.errorObj
				}
			};
		}
		// Otherwise, return the passed generic error message.
		else {
			returnData = {
				"success": false
				,"message": arguments.errorMsg
				,"data": {
					"errorType": arguments.errorType
				}
			};
		}

		return returnData;
	}
}
