local router = {
    routes = {},
}
router.execute = function(method, path, stream)
    for idx,route in pairs(router['routes']) do
        if route[1] == method and route[2] == path then
            print(route[3])
            route[3](stream)
        end
    end
end
router.add = function(method, path, handler)
    table.insert(router['routes'], {method, path, handler})
end

return router