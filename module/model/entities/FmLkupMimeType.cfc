/**
* @description
* Loads and manipulates data from the dbo.FmLkupMimeType table.
*/
component output=false persistent=true accessors=true {
	property type="numeric"	cfsqltype="int"		name="fmMimeTypeId" fieldtype="id" generator="identity";
	property type="string"	cfsqltype="varchar"	name="fmMimeTypeName" length=255;
	property type="string"	cfsqltype="varchar"	name="fmMimeType" length=255;
}
