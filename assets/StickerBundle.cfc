component output=false {

	public void function configure( bundle ) {
		bundle.addAsset( id="socketio", path="/js/lib/socketio-2.3.1.min.js" );
		bundle.addAssets(
			  directory   = "/js"
			, match       = function( path ){ return ReFindNoCase( "_[0-9a-f]{8}\..*?\.min.js$", arguments.path ); }
			, idGenerator = function( path ) {
				return ListDeleteAt( path, ListLen( path, "/" ), "/" ) & "/";
			}
		);

		bundle.asset( "/js/specific/socketiodemo/" ).dependsOn( "socketio" );
	}

}
