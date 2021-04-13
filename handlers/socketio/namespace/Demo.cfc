component {

	variables.users = [];
	variables.userMaps = {};

	private void function onConnect( socket ) {
		if ( !isFeatureEnabled( "socketiodemo" ) ) {
			socket.disconnect();
			return;
		}

		socket.on('setUsername', function( username ) {
			if( ArrayFindNoCase( users, username ) ) {
				socket.emit('userExists', username & ' username is taken! Try some other username.');
			} else {
				ArrayAppend( users, username );
				userMaps[ socket.getId() ] = username;
				socket.emit('userSet', username );
			}
		});

		socket.on('msg', function(msg) {
			socket.getNamespace().emit('newmsg', msg);
		});

		socket.on('disconnect', function() {
			if ( Len( userMaps[ socket.getId() ] ?: "" ) ) {
				ArrayDelete( users, userMaps[ socket.getId() ] );
			}
		} );
	}
}