( function( $ ){
	var $chatContainer = $( "#demo-chat-interaction-container" )
	  , socket
	  , setupChatWindow
	  , showChatMessage
	  , submitMessage
	  , showAccessDeniedMessage;

// local functions (not sockio specific)
	setupChatWindow = function( username ) {
		$chatContainer.html( '<p><strong>Welcome to the chat ' + username + '!</strong></p>\
			<form id="chat-form"><input type="text" id="message">\
		    	<button type="submit" name="button">Send</button>\
		    </form>\
		    <div id="message-container" class="well"></div>'
		);
	};

	showChatMessage = function( data ){
		$( "#message-container").append( '<div><b>' + data.user + '</b>: ' + data.message + '</div>' );
	};

	submitMessage = function( e ){
		var msg = $( "#message" ).val();
		if ( msg.length ) {
			socket.emit( 'msg', msg );
			$( "#message" ).val( "" );
		}

		return false;
	};

	showAccessDeniedMessage = function() {
		$chatContainer.html( '<h3>Oops, looks like something went wrong here</h3>\
			<p class="alert alert-error">You don\'t have permission to perform this action. Perhaps you have been timed out or logged out of another session. Please refresh the page to continue.</p>'
		);
	};


// setup socket and listeners
	socket = io( "/demo" ); // connect to socket.io namespace 'demo'
	socket.on( 'welcome', setupChatWindow ); // fired once connection successful
	socket.on( 'newmsg', showChatMessage ); // fired on new incoming messages
	socket.on( 'accessdenied', showAccessDeniedMessage ); // fired on new incoming messages
	$chatContainer.on( "submit", "#chat-form", submitMessage ); // trigger sending messages

} )( jQuery );