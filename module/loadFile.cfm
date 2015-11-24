<cftry>
	<cfset fmUploadId = (structKeyExists(URL, "fmUploadId") ) ? URL.fmUploadId : 0 />

	<!--- Load the File Manager --->
	<cfset fileManager = new FileManager() />
	<cfset fileUploadInfo = fileManager.getFileUploadInfo(fmUploadId) />

	<!--- Load the entity --->
	<cfset fmFilePath = fileUploadInfo.data.fileUploadInfo.getFmFilePath() />

	<cfset fmKeyName = fileUploadInfo.data.fileUploadInfo.getFmKeyName() />
	<cfset fmUploadId = fileUploadInfo.data.fileUploadInfo.getFmUploadId() />
	<cfset fmFileExt = fileUploadInfo.data.fileUploadInfo.getFmFileExt() />

	<cfset fmServerFileName = fmKeyName & "_" & fmUploadId & "." & fmFileExt />

	<cfset fmFileName = fileUploadInfo.data.fileUploadInfo.getFmFileName() />

	<cfif fileExists(fmFilePath & "\" & fmServerFileName)>
		<cfheader name="Content-Disposition" value="attachment; filename=""#fmFileName#""" />
		<cfheader name="Expires" value="#now()#" />
		<cfcontent file="#fmFilePath#\#fmServerFileName#" deletefile="No" />
	<cfelse>
		<cfthrow type="Application" message="File Not Found" />
	</cfif>

	<!--- If there is an error, log it and display a generic message. --->
	<cfcatch type="any">
		<div>
			I'm sorry, an error occured when downloading the file.  
			Please try to download it again.  
			If this problem persists, contact the system administrator.
		</div>

		<cfset logMsg = cfcatch.Message & " " />

		<cfif cfcatch.Detail NEQ "">
			<cfset logMsg = listAppend(logMsg, "-|-", "|") />
			<cfset logMsg = listAppend(logMsg, " " & cfcatch.Detail, "|") />
		</cfif>

		<cfloop array="#cfcatch.TagContext#" index="tc">
			<cfset logMsg = listAppend(logMsg, "-|-", "|") />
			<cfset logMsg = listAppend(logMsg, " " & tc.template, "|") />
		</cfloop>

		<cflog type="error" file="fileManager" log="Application" text="#logMsg#" />

		<cfif cgi.remote_addr EQ "127.0.0.1">
			<cfdump var="#cfcatch#">
		</cfif>
	</cfcatch>
</cftry>

