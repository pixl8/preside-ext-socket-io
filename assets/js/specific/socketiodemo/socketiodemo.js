( function( $ ){
	var socket = io( "/demo" )
	  , user;

	function setUsername() {
		socket.emit('setUsername', document.getElementById('name').value);
	};


	socket.on('userExists', function(data) {
		document.getElementById('error-container').innerHTML = data;
	});

	socket.on('userSet', function(username) {
		user = username;
		document.getElementById( 'demo-chat-interaction-container' ).innerHTML = '<input type="text" id="message">\
		    <button type="button" name="button" id="send-message-button">Send</button>\
		    <div id="message-container" class="well"></div>';

		$( "#send-message-button" ).on( "click", sendMessage );
	});

	function sendMessage() {
		var msg = document.getElementById('message').value;
		if(msg) {
			socket.emit('msg', {message: msg, user: user});
		}
	}

	socket.on('newmsg', function(data) {
		if(user) {
			document.getElementById('message-container').innerHTML += '<div><b>' + data.user + '</b>: ' + data.message + '</div>';
		}
	} );

	$( "#start-button" ).on( "click", setUsername );
} )( jQuery );