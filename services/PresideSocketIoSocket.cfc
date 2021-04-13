/**
 * @singleton false
 */
component accessors=true extends="app.extensions.preside-ext-socket-io.socketiolucee.models.SocketIoSocket" {

	property name="sessionData" type="struct";

// CONSTRUCTOR
	public any function init( required any socket ) {
		setId( arguments.socket.getId() );
		setNamespace( arguments.socket.getNamespace() );
		setIoServer( arguments.socket.getIoServer() );
		setHttpRequest( arguments.socket.getHttpRequest() );

		return this;
	}

// PUBLIC API METHODS
	public string function getAdminLoggedInUserId() {
		var sessionData = getSessionData();

		return sessionData.admin_user ?: "";
	}

	public string function getWebsiteLoggedInUserId() {
		var userDetails = getWebsiteLoggedInUserDetails();

		return userDetails.id ?: "";
	}

	public struct function getWebsiteLoggedInUserDetails() {
		var sessionData = getSessionData();

		return sessionData.website_user ?: {};
	}


// PRIVATE HELPERS

// GETTERS AND SETTERS

}