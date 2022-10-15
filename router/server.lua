#!/usr/bin/lua
--[[
A simple HTTP server
If a request is not a HEAD method, then reply with "Hello world!"
Usage: lua examples/server_hello.lua [<port>]
]]
local stats, env = pcall(require, "...env")
local http_server = require "http.server"
local http_headers = require "http.headers"
local router = require("router.router")

local function reply(myserver, stream) -- luacheck: ignore 212
	-- Read in headers
	local req_headers = assert(stream:get_headers())
	local req_method = req_headers:get ":method"
    local req_path = req_headers:get ":path"

	-- Log request to stdout
	assert(io.stdout:write(string.format('[%s] "%s %s HTTP/%g"  "%s" "%s"\n',
		os.date("%d/%b/%Y:%H:%M:%S %z"),
		req_method or "",
		req_headers:get(":path") or "",
		stream.connection.version,
		req_headers:get("referer") or "-",
		req_headers:get("user-agent") or "-"
	)))

	-- Build response headers
	

	if req_method ~= "HEAD" then
		-- Send body, ending the stream
        router.execute(req_method, req_path, stream)
		--assert(stream:write_chunk("Hello world!\n", true))
    else 
        local res_headers = http_headers.new()
	    res_headers:append(":status", "200")
	    res_headers:append("content-type", "text/plain")
        assert(stream:write_headers(res_headers, req_method == "HEAD"))
    end
end

local myserver = assert(http_server.listen {
	host = env.host or "localhost";
	port = env.port or "4200";
	onstream = reply;
	onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
		local msg = op .. " on " .. tostring(context) .. " failed"
		if err then
			msg = msg .. ": " .. tostring(err)
		end
		assert(io.stderr:write(msg, "\n"))
	end;
})

-- Manually call :listen() so that we are bound before calling :localname()
assert(myserver:listen())
do
	local bound_port = select(3, myserver:localname())
	assert(io.stderr:write(string.format("Now listening on port %d\n", bound_port)))
end
-- Start the main serve loop
assert(myserver:loop())