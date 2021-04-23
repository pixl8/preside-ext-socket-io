/**
 * @singleton      true
 * @presideService true
 *
 */
component extends="app.extensions.preside-ext-socket-io.socketiolucee.models.SocketIoDefaultAdapter" {

	public any function init() {
		return this;
	}

	public void function namespaceBroadcast(
		  required string namespace
		, required string event
		, required array  rooms
		, required array  args
		,          string excludeSocket = ""
	) {
		$announceInterception(
			  state         = "onSocketIoNamespaceBroadcast"
			, interceptData = arguments
		);

		return super.namespaceBroadcast( argumentCollection=arguments );
	}

	public void function socketBroadcast(
		  required string socketId
		, required string event
		, required array  args
		, required array  rooms
	){
		$announceInterception(
			  state         = "onSocketIoSocketBroadcast"
			, interceptData = arguments
		);

		return super.socketBroadcast( argumentCollection=arguments );

	}

}