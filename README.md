## Lua HTTP Server router implementation

This is a rudimentar router implementation for http server in lua and was build only for fun purposes

### Dependencies

It depends on http. Ensure that luarocks is configured properly for your version of lua. Then:

```bash
sudo luarocks install http
```
### Running

Create a new file and declare like below:

```lua
require("router.init")

--Your code here

require("router.server")
```

Just run the file you created!

### Adding routes

The router actually depends on the stream that the http server receives to output responses back. By the way, you should implement a high order function with the stream as parameter and use the stream to output what is intended.

```lua
require("router.init")
local router = require "routes"

router.add(method, path, handler)
require("router.server")
```

The init.lua archive has an complete example declaring a route with customized headers. Also, you can create another archive with routes and require them from your init archive.

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

### Exposing env variables

You can customize some env variables, like host, port, and to not make any conflict in installation of http dependency from luarocks, you can customize package_path and package_cpath. Just make an archive called "env" returning a table with the parameters:

- host
- port
- package_path
- package_cpath

Example:

```lua
return {
    host = "localhost",
    port = "5000"
}
```

The router will automatically detect them. If any variable has not been declared, the router will automatically run with default parameters.

### Warrant

This was builded only for fun and with no purpose to run on production. Use carefully