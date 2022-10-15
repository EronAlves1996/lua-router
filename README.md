## Lua HTTP Server router implementation

This is a rudimentar router implementation for http server in lua and was build only for fun purposes

### Dependencies

It depends on http and lua 5.1. Ensure that luarocks is configured properly for this version of lua. Then:

```bash
sudo luarocks instal http
```
### Running

```bash
lua server.lua
```

### Adding routes

The router actually depends on the stream that the http server receives to output responses back. By the way, you should implement a high order function with the stream as parameter and use the stream to output what is intended.

```lua
local router = require "routes"

router.add(method, path, handler)
```

In server.lua, two examples was already written. One of them is:

```lua
router.add("GET", "/hello", function(stream)
    assert(stream:write_chunk("Hello server!\n", true))
end)
```

You can write all your routes in another archive and execute them with a simple "require".

*Warranty:* This was builded only for fun and with no purpose to run on production. Use carefully