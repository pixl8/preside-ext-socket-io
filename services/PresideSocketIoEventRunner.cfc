/**
 * @singleton      true
 * @presideService true
 *
 */
component extends="app.extensions.preside-ext-socket-io.socketiolucee.models.SocketIoDefaultEventRunner" {

	property name="sessionStorage" inject="presidecms:object:session_storage";

	public any function init() {
		return this;
	}

	public void function run(
		  required string event
		, required array  args
		, required any    namespace
		, required struct listeners
		,          any    socket
	){
		if ( StructKeyExists( arguments.listeners, arguments.event ) ) {
			return super.execute( argumentCollection=arguments );
		}

		var nsId = arguments.namespace.getName().reReplace( "^/", "" );
		var coldboxEvent = "socketio.namespace.#nsId#.on";
		var coldboxEventArgs = {
			  namespace = arguments.namespace
			, args      = arguments.args
		};

		if ( StructKeyExists( arguments, "socket" ) ) {
			coldboxEventArgs.socket = _wrapSocket( arguments.socket );
			coldboxEvent &= "Socket" & arguments.event;
		} else {
			if ( ArrayLen( arguments.args ) && isInstanceOf( arguments.args[ 1 ] , "SocketIoSocket" ) ) {
				coldboxEventArgs.socket = arguments.args[ 1 ] = _wrapSocket( arguments.args[ 1 ] );
			}
			coldboxEvent &= arguments.event;
		}

		if ( $getColdbox().handlerExists( coldboxEvent ) ) {
			$runEvent(
				  event          = coldboxEvent
				, private        = true
				, prePostExempt  = true
				, eventArguments = coldboxEventArgs
			);
		}
	}

	public any function _wrapSocket( required any socket ) {
		var wrappedSocket = new PresideSocketIoSocket( arguments.socket );
		var sessionData   = _getPresideSessionDataFromSocket( arguments.socket );

		wrappedSocket.setSocketData( sessionData );

		return wrappedSocket;
	}

	private struct function _getPresideSessionDataFromSocket( required any socket ) {
		var socketHttpReq    = arguments.socket.getHttpRequest();
		var reqCookies       = socketHttpReq.getCookies();
		var presideSessionId = "";

		if ( IsNull( local.reqCookies ) ) {
			reqCookies = [];
		}

		for( var reqCookie in reqCookies ) {
			if ( ( reqCookie.name ?: "" ) == "PSID" ) {
				presideSessionId = reqCookie.value ?: "";
			}
		}

		if ( Len( presideSessionId ) ) {
			var presideSession = sessionStorage.selectData( id=presideSessionId, selectFields=[ "value" ] );

			if ( presideSession.recordCount ) {
				sessionStorage.updateData( id=presideSessionId, data={ expiry=( _getUnixTimeStamp() + _getSessionTimeoutInSeconds() ) } );
				try {
					return DeserializeJson( presideSession.value );
				} catch( any e ) {
					$raiseError( e );
				}
			}
		}

		return {};
	}

	private numeric function _getSessionTimeoutInSeconds() {
		var appSettings   = getApplicationSettings();
		var timeout       = appSettings.sessionTimeout ?: CreateTimeSpan( 0, 0, 20, 0 );
		var secondsInADay = 86400;

		return Round( Val( timeout ) * secondsInADay );
	}

	private numeric function _getUnixTimeStamp() {
		var epochInMs = CreateObject( "java", "java.time.Instant" ).now().toEpochMilli();

		return Ceiling( epochInMs / 1000  );
	}

}