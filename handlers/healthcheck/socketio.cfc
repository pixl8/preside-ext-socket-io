component {
	property name="presideSocketIoService" inject="presideSocketIoService";

	private boolean function check() {
		return presideSocketIoService.healthcheck();
	}
}