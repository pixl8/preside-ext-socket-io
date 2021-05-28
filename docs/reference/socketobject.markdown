---
layout: page
title: The socket object
nav_order: 1
parent: Reference
has_children: false
---

# The socket object

Your message listeners that you define in your namespace CFC will all receive a `socket` argument that represents the connected socket that sent the message.

The base definition of this object can be found here: [https://pixl8.github.io/socket.io-lucee/api/index.html](https://pixl8.github.io/socket.io-lucee/api/index.html).

This extension adds in Preside specific helper methods onto the Socket object that help withidentifying logged in users. The new methods are:

* `socket.isWebUser()`: Whether the socket belongs to a logged in web user
* `socket.isAdminUser()`: Whether the socket belongs to a logged in admin user
* `socket.getAdminLoggedInUserId()`: Returns the ID of the logged in admin user associated with the socket
* `socket.getWebsiteLoggedInUserId()`:  Returns the ID of the logged in web user associated with the socket
* `socket.getWebsiteLoggedInUserDetails()`:  Returns the record as a struct of the logged in web user associated with the socket