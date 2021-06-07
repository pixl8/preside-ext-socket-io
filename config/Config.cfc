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
			  host                     = settings.env.SOCKET_IO_HOST                     ?: ListFirst( cgi.http_host, ":" )
			, port                     = settings.env.SOCKET_IO_PORT                     ?: 3000
			, enableCorsHandling       = settings.env.SOCKET_IO_ENABLE_CORS              ?: false
			, pingInterval             = settings.env.SOCKET_IO_PING_INTERVAL            ?: 5000
			, pingTimeout              = settings.env.SOCKET_IO_PING_TIMEOUT             ?: 25000
			, maxTimeoutThreadPoolSize = settings.env.SOCKET_IO_TIMEOUT_THREAD_POOL_SIZE ?: 20
			, allowedCorsOrigins       = ListToArray( settings.env.SOCKET_IO_CORS_ORIGINS ?: "*" )
		};

		settings.socketio      = settings.socketio ?: {};
		settings.socketio.host                     = settings.socketio.host                     ?: defaults.host;
		settings.socketio.port                     = settings.socketio.port                     ?: defaults.port;
		settings.socketio.enableCorsHandling       = settings.socketio.enableCorsHandling       ?: defaults.enableCorsHandling;
		settings.socketio.allowedCorsOrigins       = settings.socketio.allowedCorsOrigins       ?: defaults.allowedCorsOrigins;
		settings.socketio.pingInterval             = settings.socketio.pingInterval             ?: defaults.pingInterval;
		settings.socketio.pingTimeout              = settings.socketio.pingTimeout              ?: defaults.pingTimeout;
		settings.socketio.maxTimeoutThreadPoolSize = settings.socketio.maxTimeoutThreadPoolSize ?: defaults.maxTimeoutThreadPoolSize;
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
