local stats, env = pcall(require, "...env")
local http_headers = require "http.headers"

local router = {
    routes = {},
}

router.execute = function(method, path, stream)
    for idx,route in pairs(router['routes']) do
        if route[1] == method and route[2] == path then
            assert(stream:write_headers(route[4](), false))
            route[3](stream)
            return
        end
    end
    local error404_header = http_headers.new()
    error404_header:append(":status", "404")
    error404_header:append("content-type", "text/plain")
    assert(stream:write_headers(error404_header, false))
    assert(stream:write_chunk("404 - Not Found", true))
    return 
end

router.add = function(method, path, handler, header_def)
    header_def = header_def or function() 
        local res_headers = http_headers.new()
        res_headers:append(":status", "200")
        res_headers:append("content-type", "text/plain")
        return res_headers
    end
    table.insert(router['routes'], {method, path, handler, header_def})
end

return router