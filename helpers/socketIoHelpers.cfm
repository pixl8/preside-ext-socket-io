<cfscript>

	public void function socketIoNsBroadcast(
		  required string namespace
		, required string event
		,          any    args  = []
		,          any    rooms = []
	) {
		getSingleton( "presideSocketIoService" ).namespace( arguments.namespace ).broadcast(
			  event = arguments.event
			, args  = arguments.args
			, rooms = arguments.rooms
		);
	}

</cfscript>