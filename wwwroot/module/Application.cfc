component {
	// Application properties
	this.name = hash( getCurrentTemplatePath() );
	
	// Enable ORM
	this.ormEnabled = true;

	// ORM Datasource
	this.datasource = "FileManager";

	// ORM configuration settings
	this.ormSettings = {
		cfclocation = ["/module/model/entities"]	// Location of entities
		,eventHandling = true						// Use active ORM events
	};

	// Application start
	public boolean function onApplicationStart(){
		return true;
	}
}