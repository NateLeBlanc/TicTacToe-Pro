local json = require("Libraries.dkjson")
local config = {}

function config.load()
    local file = love.filesystem.read("config.json")
    config.data = json.decode(file)
end

return config