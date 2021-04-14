component {

	private void function onConnect( socket ) {
		if ( !isFeatureEnabled( "socketiodemo" ) || !_setupUser( socket ) ) {
			socket.disconnect();
			return;
		}

		socket.on('msg', function( msg ) {
			socket.getNamespace().emit( 'newmsg', {
				  message = msg
				, user    = socket.getWebsiteLoggedInUserDetails().display_name
			});
		});
	}

// helpers
	private boolean function _setupUser( socket ) {
		var user = socket.getWebsiteLoggedInUserDetails();
		if ( !StructCount( user ) ) {
			return false;
		}

		socket.emit('userSet', user.display_name );
		return true;
	}
}