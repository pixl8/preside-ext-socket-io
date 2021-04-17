component {

	property name="io" inject="presideSocketIoService";

	private void function onNsConnect( namespace, socketIoEventArgs ) {
		var socket = socketIoEventArgs[ 1 ];

		io.onNsConnect( namespace, socket );
	}

	private void function onSocketEvent( namespace, socket, socketIoEventArgs ) {
		// todo
	}

}