component {

	private void function onConnect( socket ) {
		if ( !isFeatureEnabled( "socketiodemo" ) || !arguments.socket.isWebUser() ) {
			socket.emit( 'accessdenied' );
			return;
		}

		var user = socket.getWebsiteLoggedInUserDetails();
		arguments.socket.emit( 'welcome', user.display_name );
	}

	private void function onSocketMsg( namespace, socket, args=[] ) {
		if ( arguments.socket.isWebUser() ) {
			arguments.namespace.emit( "newmsg", {
				  message = arguments.args[ 1 ] ?: ""
				, user    = arguments.socket.getWebsiteLoggedInUserDetails().display_name
			});
		} else {
			arguments.socket.emit( "accessdenied" );
		}
	}

}