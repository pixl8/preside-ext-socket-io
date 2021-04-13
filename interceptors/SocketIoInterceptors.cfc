component extends="coldbox.system.Interceptor" {

	property name="socketIoService" inject="delayedInjector:presideSocketIoService";
	property name="featureService" inject="delayedInjector:featureService";

// PUBLIC
	public void function configure() {}

	public void function onApplicationStart() {
		if ( featureService.isFeatureEnabled( "socketio" ) ) {
			if ( !featureService.isFeatureEnabled( "presideSessionManagement" ) ) {
				throw( type="preside.socket.io.error", message="The Socket.IO extension for Preside requires that you have Preside Session Management enabled. See https://docs.preside.org/devguides/sessions.html##turning-on-presides-session-management for details on enabling Preside Session Management." );
			}

			socketIoService.startServer();
		}
	}
}