---
layout: page
title: Helpers
nav_order: 2
parent: Reference
has_children: false
---

# Helpers

The extension offers a single helper that can be used to broadcast an event to entire namespace (or to select rooms in the namespace).

## socketIoNsBroadcast()

The `socketIoNsBroadcast()` helper method allows you to broadcast an event to entire namespace (or to select rooms in the namespace). Call it with `socketIoNsBroadcast()` from handlers and `$helpers.socketIoNsBroadcast()` from service components that use [Preside super class](https://docs.preside.org/devguides/presidesuperclass.html).

It accepts the following arguments:

|Name | Required | default | Description|
| --- |   ---    |  ---    |    ---     |
|namespace|`true`|-|The namespace to broadcast to, e.g. `"/myfabns"`|
|event|`true`|-|The event name to broadcast, e.g. "newmessage"|
|args|`false`|`[]`|Array of arguments to send with the event|
|rooms|`false`|`[]`|Array of room names to limit the broadcast to. Broadcast to all rooms if the array is empty (default)|


### Example

An incomplete and rough example to give you an idea:

```cfc
/**
 * @singleton
 * @presideSuperClass
 *
 */
component {

	/**
	 * Save a message in the database and broadcast
	 * the new message to any connected sockets to the 
	 * message room
	 *
	 */
	public string function recordMessage( messageDetails ) {
		var messageId = $getPresideObject( "message" ).insertData( messageDetails );

		$helpers.socketIoNsBroadcast(
			  namespace = "/messageapp"
			, event     = "newmessage"
			, args      = [ messageId, messageDetails ]
			, rooms     = [ messageDetails.room ]
		);

		return messageId;
	}
}
```