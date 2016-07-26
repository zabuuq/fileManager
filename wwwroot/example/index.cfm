
<cfsavecontent variable="request.bodyContent">
	<div class="jumbotron">
		<p>This is a simple file manager application written in ColdFusion. It is designed as a stand alone module that can be downloaded as is and dropped into a sub-folder of your application. The SQL files in the "db" folder will need to be run for the database storage to work.</p>

		<p>Currently the file manager application is designed to work with the jQuery blueimp file upload widget which requires jQuery to run. These demo pages are designed using Bootstrap CSS. Links to the sites for jQuery, blueimp and Bootstrap are available in the "EXTERNAL LINKS" nav above.</p>

		<p>
			<!--- Click the ADMIN link above to manipulate the database back-end of the file manager. You will be able to see a list of the file manager 'keys' and will be able to define what mime types are accepted for each 'key.' For the purposes of this sample, only one 'key' is available to be manipulated. Updating its mime types will affect the FILE MANAGER page. --->
		</p>
	</div>
</cfsavecontent>

<cfinclude template="layout.cfm" />
