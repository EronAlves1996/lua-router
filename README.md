## Lua HTTP Server router implementation

This is a rudimentar router implementation for http server in lua and was build only for fun purposes

### Dependencies

It depends on http and lua 5.1. Ensure that luarocks is configured properly for this version of lua. Then:

```bash
sudo luarocks install http
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

### Customizing headers

Headers can be customized, by the way, passing another high order function as parameter, right after the handler of the request. This requires:

- Create a new http_headers object
- Appending the necessary headers to http_headers object
- Return the final http_headers object

The default option for headers is 

- Status Code = 200
- Content-Type = text/plain

Below an example of customized headers for specific route:

```lua
router.add("GET", "/hellotest", function(stream)
    local hello_page = io.open("hello.html", "r")
    assert(stream:write_body_from_file(hello_page, 1000))
end, function()
    local headers = http_headers.new()
    headers:append(":status", "200")
    headers:append("content-type", "text/html")
    return headers
end)
```
In this example, in order to browser parse the html file (and not display the raw version), it needs to set content-type as 'text-html'.

### Warrant

This was builded only for fun and with no purpose to run on production. Use carefully