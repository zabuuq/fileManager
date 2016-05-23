/**
* @description
* Loads and manipulates data from the dbo.FileManagerKey table.
*/
component output=false persistent=true accessors=true {
	property type="numeric"	cfsqltype="int"		name="fmKeyId" fieldtype="id" generator="identity";
	property type="string"	cfsqltype="varchar"	name="fmKeyName" length=50;
	property type="string"	cfsqltype="varchar"	name="fmKeyDesc" length=255;
	property type="string"	cfsqltype="varchar"	name="fmKeyPath" length=255;

	property fieldType="many-to-many" name="fmMimeTypes" cfc="FmLkupMimeType" linkTable="FmKeyMimeType" fkColumn="fmKeyId" inverseJoinColumn="fmMimeTypeId";
}
