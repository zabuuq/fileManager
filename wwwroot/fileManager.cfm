
<cfsavecontent variable="request.headContent">
	<link rel="stylesheet" type="text/css" href="includes/css/file-manager.css">
</cfsavecontent>

<cfsavecontent variable="request.bodyContent">
	<form action="" method="post" id="fileUploadForm" class="form-default" role="form">
		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="row">
					<h1 class="panel-title col-sm-10">Attachments:</h1>

					<div class="col-sm-2 text-right">
						<span class="btn btn-default btn-file btn-sm">
							Attach File<input type="file" name="fileUpload" id="fileUpload" multiple="multiple" />
						</span>
					</div>

					<input type="hidden" name="fmKeyId" id="fmKeyId" value="1" />
					<input type="hidden" name="fmUniqueId" id="fmUniqueId" value="1" />
	 			</div>
			</div>

			<table class="table table-striped table-hover">
				<tbody id="fileManagerBody">
					<tr class="file-manager-row">
						<td class="col-sm-11 file-manager-name">Attachment 1</td>
						<td class="col-sm-1 text-center file-manager-delete">X</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</cfsavecontent>

<cfsavecontent variable="request.footContent">
	<!--- 
		@NOTE
		JQUERY IS REQUIRED FOR BLUEIMP TO WORK.
		CURRENTLY IT IS LOADED IN LAYOUT.CFM SINCE IT IS NEEDED FOR BOOTSTRAP TO WORK AS WELL.
		THE LINK TO IT IS PROVIDED HERE IN THIS COMMENT AS A REMINDER.

		<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
	--->

	<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.12.4/js/vendor/jquery.ui.widget.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.12.4/js/jquery.iframe-transport.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.12.4/js/jquery.fileupload.min.js"></script>
	<script src="/module/js/file-manager.js"></script>

	<script src="/includes/js/file-manager-example.js"></script>
</cfsavecontent>

<cfinclude template="layout.cfm" />
