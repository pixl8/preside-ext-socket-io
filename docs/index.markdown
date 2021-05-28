---
layout: home
title: Home
nav_order: 1
---

# Socket.IO For Preside

Socket.IO for Preside is an abstraction layer on top of the framework provided by the [socket.io-lucee](https://github.com/pixl8/socket.io-lucee) project. It aims to provide seamless websocket functionality right in your Preside apps. 

**This project is in its infancy. The documentation here is a rough guide and you will need to fully consume the related reading as advised here.**

## Getting started

You should familiarize yourself with the key concepts of working with websockets and socket.io. The [socket.io-lucee documentation](https://pixl8.github.io/socket.io-lucee/) is a great resource to get up to speed. Everything that applies in [socket.io-lucee](https://github.com/pixl8/socket.io-lucee) is knowledge that will be taken through to your Preside implementation.

To get everything ready in your application:

1. Install this extension (it comes bundled with [socket.io-lucee](https://github.com/pixl8/socket.io-lucee)): `box install preside-ext-socket-io`
2. Understand how the websocket servlet runs on a separate port and make hosting provisions for that if you need to: [https://pixl8.github.io/socket.io-lucee/hosting/](https://pixl8.github.io/socket.io-lucee/hosting/)


## What this exension offers

This extension gives you **a server side convention for creating socket.io namespaces and listening to incoming client socket messages**. Rather than having to manually create your socket.io server and register listeners - all you have to do is create a convention based handler with actions using a little convention.

For example, if you wish to create a new socket.io namespace called `/mycoolapp`, you would create a handler cfc at `/handlers/socketio/namespace/MyCoolApp.cfc` and it would look like something this:

```cfc
component {
    /**
     * the onConnect method allows you to run logic
     * when a client socket first connects to your namespace
     *
     */
    private void function onConnect( socket ) {
        if ( !isFeatureEnabled( "mycoolapp" ) ) {
            socket.disconnect();
            return;
        }
    }

    /**
     * any method that starts with onSocket is used 
     * as a listener for client socket initiated events.
     * In this example, the 'helloWorld' event.
     *
     */
    private void function onSocketHelloWorld( namespace, socket, args ) {
        var message = args[ 1 ] ?: "";

        SystemOutput( "A connected client said: " & message );

        socket.emit( "helloworldback", "Hello back from the server!" );
    }
}
```

The javascript for this example might look like this:

```js
( function(){
    var socket = new io( "/mycoolapp" );

    socket.on( "connect", function(){
        socket.emit( "helloworld", "hello from the client!" );
    } );

    socket.on( "helloworldback", function( msg ){
        console.log( "We got a message back: " + msg );
    } );
} )();
```

**NOTE** Any javascript you create to interact with your socket io server should have a StickerBundle dependency on the Sticker asset ID `socketio` that comes bundled with this extension. Besides that, this extension has no opionion on your javascript and offers no javascript helpers.