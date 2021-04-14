( function( $ ){
	var $chatContainer = $( "#demo-chat-interaction-container" )
	  , socket
	  , setupChatWindow
	  , showChatMessage
	  , submitMessage;

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


// setup socket and listeners
	socket = io( "/demo" ); // connect to socket.io namespace 'demo'
	socket.on( 'userSet', setupChatWindow ); // fired once connection successful
	socket.on( 'newmsg', showChatMessage ); // fired on new incoming messages
	$chatContainer.on( "submit", "#chat-form", submitMessage ); // trigger sending messages

} )( jQuery );