/**
 * @singleton false
 */
component accessors=true {

	property name="sessionData" type="struct";
	property name="socket" type="any";

// CONSTRUCTOR
	public any function init( required any socket ) {
		setSocket( arguments.socket );

		return this;
	}

// PROXY
	public any function onMissingMethod( methodName, args ) {
		var socket = getSocket();

		return socket[ arguments.methodName ]( argumentCollection=args );
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