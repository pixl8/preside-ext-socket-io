component {

	public void function index() {
		if ( !isFeatureEnabled( "socketiodemo" ) ) {
			event.notFound();
		}

		event.include( "/js/specific/socketiodemo/" );
	}
}