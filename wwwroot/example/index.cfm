
<cfsavecontent variable="request.headContent">
</cfsavecontent>

<cfsavecontent variable="request.bodyContent">
	FM
</cfsavecontent>

<cfsavecontent variable="request.footContent">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.12.4/js/vendor/jquery.ui.widget.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.12.4/js/jquery.iframe-transport.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/9.12.4/js/jquery.fileupload.min.js"></script>
</cfsavecontent>

<cfinclude template="layout.cfm" />
