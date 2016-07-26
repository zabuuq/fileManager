component {
	// Application properties
	this.name = hash( getCurrentTemplatePath() );
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,1,0,0);
	this.setClientCookies = true;
	
	// Application start
	public boolean function onApplicationStart(){
		return true;
	}

	// request start
	public boolean function onRequestStart(String targetPage){
		if(structKeyExists(url, "doReset") && url.doReset == 1){
			applicationStop();
			ormReload();
		}

		if(structKeyExists(url, "hideDebug") ){
			session.hideDebug = (url.hideDebug == 0) ? false : true;
		}
		
		return true;
	}
}