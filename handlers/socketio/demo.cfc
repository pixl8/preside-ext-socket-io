component {

	public void function index() {
		if ( !isFeatureEnabled( "socketiodemo" ) ) {
			event.notFound();
		}

		if ( !isLoggedIn() ) {
			event.accessDenied( reason="LOGIN_REQUIRED" );
		}

		event.include( "/js/specific/socketiodemo/" );
	}
}