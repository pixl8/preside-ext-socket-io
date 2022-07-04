/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="serverHost"               inject="coldbox:setting:socketio.host";
	property name="serverPort"               inject="coldbox:setting:socketio.port";
	property name="enableCorsHandling"       inject="coldbox:setting:socketio.enableCorsHandling";
	property name="allowedCorsOrigins"       inject="coldbox:setting:socketio.allowedCorsOrigins";
	property name="pingInterval"             inject="coldbox:setting:socketio.pingInterval";
	property name="pingTimeout"              inject="coldbox:setting:socketio.pingTimeout";
	property name="maxTimeoutThreadPoolSize" inject="coldbox:setting:socketio.maxTimeoutThreadPoolSize";
	property name="eventRunner"              inject="presideSocketIoEventRunner";
	property name="adapter"                  inject="presideSocketIoAdapter";

// CONSTRUCTOR
	public any function init() {
		_discoverNamespaces();

		return this;
	}

// PUBLIC API METHODS
	public void function startServer() {
		_setupServer();
		_registerNamespaces();
	}

	public void function shutdown() {
		stopServer();
	}
	public void function stopServer() {
		$SystemOutput( "Shutting down Socket.IO embededded server at [#serverHost#:#serverPort#]" );
		_getServer().shutdown();
		$SystemOutput( "Socket.IO server shutdown" );
	}

	public boolean function healthcheck() {
		var socketIoServer = _getServer();
		if ( IsNull( socketIoServer ) ) {
			return false;
		}

		var state         = socketIoServer.getState();
		var runningStates = [ "RUNNING", "STARTED", "STARTING" ];

		if ( !socketIoServer.isRunning() && !ArrayFindNoCase( runningStates, state ) ) {
			$SystemOutput( "Socket.IO server is not running. Current state: #state#. Attempting to start now..." );
			startServer();
			return false;
		}

		return true;
	}

	public struct function getStats(){
		var stats = {};
		var namespaces = _getServer().getRegisteredNamespaces();

		stats.namespaceCount = ArrayLen( namespaces );
		stats.namespaces = {};
		for( var namespace in namespaces ) {
			stats.namespaces[ namespace ] = { socketCount=_getServer().namespace( namespace ).getSocketCount() };
		}

		return stats;
	}

	public any function getServer() {
		return _getServer();
	}

	// proxies
	public any function of() {
		return _getServer().namespace( argumentCollection=arguments );
	}

	public any function namespace() {
		return _getServer().namespace( argumentCollection=arguments );
	}


// PRIVATE HELPERS
	private void function _discoverNamespaces() {
		var namespaceHandlers = $getColdbox().listHandlers( thatStartWith="socketio.namespace." );
		var namespaces = {};

		for( var handlerName in namespaceHandlers ) {
			if ( ListLen( handlerName, "." ) == 3 && $getColdbox().handlerExists( handlerName & ".onConnect" ) ) {
				namespaces[ LCase( ListGetAt( handlerName, 3, "." ) ) ] = true;
			}
		}

		_setNamespaces( StructKeyArray( namespaces ) );
	}

	private void function _setupServer() {
		$SystemOutput( "Starting Socket.IO embededded server at [#serverHost#:#serverPort#]" );
		var io = CreateObject( "app.extensions.preside-ext-socket-io.socketiolucee.models.SocketIoServer" ).init(
			  host                     = serverHost
			, port                     = serverPort
			, start                    = true
			, eventRunner              = eventRunner
			, adapter                  = adapter
			, enableCorsHandling       = enableCorsHandling
			, allowedCorsOrigins       = allowedCorsOrigins
			, pingInterval             = pingInterval
			, pingTimeout              = pingTimeout
			, maxTimeoutThreadPoolSize = maxTimeoutThreadPoolSize
		);

		_setServer( io );
	}

	private void function _registerNamespaces() {
		var io = _getServer();

		for( var ns in _getNamespaces() ) {
			io.namespace( "/" & ns );
		}
	}


// GETTERS AND SETTERS
	private any function _getServer() {
	    return variables._socketIoServer ?: NullValue();
	}
	private void function _setServer( required any socketIoServer ) {
	    variables._socketIoServer = arguments.socketIoServer;
	}

	private array function _getNamespaces() {
	    return variables._namespaces;
	}
	private void function _setNamespaces( required array namespaces ) {
	    variables._namespaces = arguments.namespaces;
	}

}