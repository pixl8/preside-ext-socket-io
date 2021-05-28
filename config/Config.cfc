component {

	public void function configure( required struct config ) {
		var conf     = arguments.config;
		var settings = conf.settings ?: {};

		_setupExtensionSettings( settings );
		_setupFeatures( settings );
		_setupHealthchecks( settings );
		_setupInterceptors( conf );
	}

// private helpers
	private void function _setupExtensionSettings( settings ) {
		var defaults = {
			  host = settings.env.SOCKET_IO_HOST ?: ListFirst( cgi.http_host, ":" )
			, port = settings.env.SOCKET_IO_PORT ?: 3000
		};

		settings.socketio      = settings.socketio ?: {};
		settings.socketio.host = settings.socketio.host ?: defaults.host;
		settings.socketio.port = settings.socketio.port ?: defaults.port;
	}

	private void function _setupFeatures( settings ) {
		settings.features.socketio = settings.features.socketio ?: { enabled=true };
		settings.features.socketiodemo = settings.features.socketiodemo ?: { enabled=false };
	}

	private void function _setupHealthchecks( settings ) {
		settings.healthcheckServices.socketio = {
			interval = CreateTimeSpan( 0, 0, 0, 5 ) // 5 second healthchecks
		};
	}

	private void function _setupInterceptors( conf ) {
		ArrayAppend( arguments.conf.interceptors, {
			  class      = "app.extensions.preside-ext-socket-io.interceptors.SocketIoInterceptors"
			, properties = {}
		});

		ArrayAppend( arguments.conf.interceptorSettings.customInterceptionPoints, [
			  "onSocketIoNamespaceBroadcast"
			, "onSocketIoSocketBroadcast"
		], true );
	}
}
