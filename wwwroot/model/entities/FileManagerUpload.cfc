/**
* @description
* Loads and manipulates data from the dbo.FileManagerUpload table.
*/
component output=false persistent=true accessors=true {
	property type="numeric"	cfsqltype="int"		name="fmUploadId" fieldtype="id" generator="identity";
	property type="string"	cfsqltype="varchar"	name="fmUniqueId" length=255;
	property type="string"	cfsqltype="varchar"	name="fmFileName" length=255;
	property type="string"	cfsqltype="varchar"	name="fmFileExt" length=5;
	property type="numeric"	cfsqltype="int"		name="fmKeyId" insert=false update=false;

	property fieldtype="many-to-one" name="fileManagerKey" cfc="FileManagerKey" fkcolumn="fmKeyId";

	property type="string"	persistent=false name="fmKeyName";
	property type="string"	persistent=false name="fmFilePath";

	public void function postLoad(){
		// Check to see if there is a fund source, otherwise set it to an empty entity.
		if(!structKeyExists(variables, "fileManagerKey") ){
			variables.fileManagerKey = entityNew("FileManagerKey");
		}

		variables.fmKeyName = variables.fileManagerKey.getFmKeyName();
		variables.fmFilePath = variables.fileManagerKey.getFmKeyPath();
	}
}
