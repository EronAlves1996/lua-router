require("router.init")
local routes = require "router.router"
local headers = require "http.headers"

routes.add("GET", "/", function(stream)
    local file = io.open("./hello.html")
    assert(stream:write_body_from_file(file, 1000))
end, function()
    local response_headers = headers.new()
    response_headers:append(":status", "200")
    response_headers:append("content-type", "text/html")
    return response_headers
end)

require("router.server")