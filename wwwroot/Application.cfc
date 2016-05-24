component{
	// Application properties
	this.name = hash( getCurrentTemplatePath() );
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,1,0,0);
	this.setClientCookies = true;
	
	// Enable ORM
	this.ormEnabled = true;
	// ORM Datasource
	this.datasource = "FileManager";
	// ORM configuration settings
	this.ormSettings = {
		// Location of your entities, default is your convention model folder
		cfclocation = ["\model\entities"],
		// Log SQL or not
		logSQL = true,
		// Active ORM events
		eventHandling =  true
	};

	// Application start
	public boolean function onApplicationStart(){
		return true;
	}

	// Session start
	public void function onSessionStart(){
	}

	// Request start
	public boolean function onRequestStart(String targetPage){
		return true;
	}
}