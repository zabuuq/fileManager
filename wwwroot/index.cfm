
<cfsavecontent variable="request.bodyContent">
	<div class="jumbotron">
		<p>Click the FILE MANAGER link above to see a simple example the file manager at work.  On the front end it utilizes the jQuery blueimp file upload widget (git: <a href="https://github.com/blueimp/jQuery-File-Upload">https://github.com/blueimp/jQuery-File-Upload</a>) (demo: <a href="https://blueimp.github.io/jQuery-File-Upload/">https://blueimp.github.io/jQuery-File-Upload/</a>). In the example you can upload, view and delete files.</p>

		<p>Click the ADMIN link above to manipulate the database back-end of the file manager. You will be able to see a list of the file manager 'keys' and will be able to define what mime types are accepted for each 'key.' For the purposes of this sample, only one 'key' is available to be manipulated. Updating its mime types will affect the FILE MANAGER page.
	</div>
</cfsavecontent>

<cfinclude template="example/layout.cfm" />
