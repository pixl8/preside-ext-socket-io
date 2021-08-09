component {

	private boolean function check() {
		if ( isFeatureEnabled( "socketio" ) ) {
			return getModel( "presideSocketIoService" ).healthcheck();
		}
		return true;
	}

}