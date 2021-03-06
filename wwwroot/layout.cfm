<cfset local.hideDebug = (structKeyExists(session, "hideDebug") ) ? session.hideDebug : false />
<cfset request.headContent = (structKeyExists(request, "headContent") ) ? request.headContent : "" />
<cfset request.bodyContent = (structKeyExists(request, "bodyContent") ) ? request.bodyContent : "" />
<cfset request.footContent = (structKeyExists(request, "footContent") ) ? request.footContent : "" />

<html lang="en">
<head>
	<cfif local.hideDebug>
		<cfsetting showdebugoutput="false" />
	</cfif>
	
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

	<title>File Manager Sample</title>

	<meta name="description" content="File Manager Sample">
	<meta name="author" content="Jason C McCoy (zabuuq)">

	<!---css --->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="/includes/css/layout.css">

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->

	<cfoutput>#request.headContent#</cfoutput>
</head>

<body data-spy="scroll">
	<header>
		<div class="container">
			File Manager Sample
		</div>
	</header>

	<nav class="navbar navbar-default">
		<div class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
				<li><a href="/index.cfm">HOME</a></li>
				<li><a href="/fileManager.cfm">FILE MANAGER DEMO</a></li>
				<!--- <li><a href="/admin.cfm">ADMIN</a></li> --->
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
						<span class="glyphicon glyphicon-link"></span> EXTERNAL LINKS <span class="caret"></span>
					</a>

					<ul class="dropdown-menu">
						<li>
							<a target="_blank" href="https://blueimp.github.io/jQuery-File-Upload/">
								<span class="glyphicon glyphicon-new-window"></span> BLUEIMP DEMO
							</a>
						</li>
						<li>
							<a target="_blank" href="https://github.com/blueimp/jQuery-File-Upload">
								<span class="glyphicon glyphicon-new-window"></span> BLUEIMP GITHUB
							</a>
						</li>
						<li>
							<a target="_blank" href="http://getbootstrap.com/">
								<span class="glyphicon glyphicon-new-window"></span> BOOTSTRAP
							</a>
						</li>
						<li>
							<a target="_blank" href="https://jquery.com/">
								<span class="glyphicon glyphicon-new-window"></span> JQUERY
							</a>
						</li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>

	<div class="container main-body">
		<cfoutput>#request.bodyContent#</cfoutput>
	</div>

	<footer>
		<div class="container">
			<div>File Manager Sample</div>
		</div>
	</footer>

	<!---js --->
	<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

	<cfoutput>#request.footContent#</cfoutput>
</body>
</html>
