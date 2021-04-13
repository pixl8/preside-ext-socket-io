/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="serverHost" inject="coldbox:setting:socketio.host";
	property name="serverPort" inject="coldbox:setting:socketio.port";

// CONSTRUCTOR
	public any function init() {
		_discoverNamespaces();

		return this;
	}

// PUBLIC API METHODS
	public void function startServer() {
		_setupServer();
		_setupNamespaceListeners();
	}

	public void function shutdown() {
		stopServer();
	}
	public void function stopServer() {
		_getServer().shutdown();
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
		var io = CreateObject( "app.extensions.preside-ext-socket-io.socketiolucee.models.SocketIoServer" ).init(
			  host  = serverHost
			, port  = serverPort
			, start = true
		);

		_setServer( io );
	}

	private void function _setupNamespaceListeners() {
		var io = _getServer();

		for( var namespace in _getNamespaces() ) {
			io.of( "/#namespace#" ).on( "connect", function( socket ){
				var nsName = socket.getNamespace().getName().reReplace( "^/", "" );

				$runEvent(
					  event = "socketio.namespace.#nsName#.onconnect"
					, private = true
					, prepostexempt = true
					, eventArguments = { socket=_getPresideSocket( arguments.socket ) }
				);
			} );
		}

	}

	private any function _getPresideSocket( required any socket ) {
		var wrappedSocket = new PresideSocketIoSocket( arguments.socket );
		var sessionData = _getPresideSessionDataFromSocket( arguments.socket );

		wrappedSocket.setSessionData( sessionData );

		return wrappedSocket;
	}

	private struct function _getPresideSessionDataFromSocket( required any socket ) {
		var socketHttpReq    = arguments.socket.getHttpRequest();
		var reqCookies       = socketHttpReq.getCookies();
		var presideSessionId = "";

		for( var reqCookie in reqCookies ) {
			if ( ( reqCookie.name ?: "" ) == "PSID" ) {
				presideSessionId = reqCookie.value ?: "";
			}
		}

		if ( Len( presideSessionId ) ) {
			var presideSession = $getPresideObject( "session_storage" ).selectData( id=presideSessionId, selectFields=[ "value" ] );

			if ( presideSession.recordCount ) {
				try {
					return DeserializeJson( presideSession.value );
				} catch( any e ) {
					$raiseError( e );
				}
			}
		}

		return {};
	}


// GETTERS AND SETTERS
	private any function _getServer() {
	    return _server;
	}
	private void function _setServer( required any server ) {
	    _server = arguments.server;
	}

	private array function _getNamespaces() {
	    return _namespaces;
	}
	private void function _setNamespaces( required array namespaces ) {
	    _namespaces = arguments.namespaces;
	}

}