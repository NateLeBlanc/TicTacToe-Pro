local json = require("Libraries.dkjson")
local Logger = require("Libraries.logger")

local GameConfiguration = {}

function GameConfiguration.load()
    local file = io.open("config.json", "r")
    if not file then
        Logger.error("Config file does not exist. Defaults loaded.")
        GameConfiguration.settings = {
            gridOptions = { rows = 3, columns = 3 },
            botSpeed = { easy = 1.0, hard = 0.5 }
        }

        if GameConfiguration.save() then
            Logger.info("Default configuration saved to new file.")
        end
        return
    end

    local content = file:read("*a")
    file:close()
    GameConfiguration.data = json.decode(content)
end

function GameConfiguration.save()
    if not GameConfiguration.settings then
        Logger.error("No settings to save.")
        return false
    end

    local file = io.open("config.json", "w")
    if file then
        local content = json.encode(GameConfiguration.settings, { indent = true })
        if type(content) == "string" then
            file:write(content)
            file:close()
            return true
        else
            Logger.error("Failed to encode configuration to JSON.")
            file:close()
            return false
        end
    else
        Logger.error("Failed to save configuration file")
        return false
    end
end

function GameConfiguration.update(key, value)
    GameConfiguration.settings[key] = value
    if GameConfiguration.save() then
        Logger.info("Settings updated.")
    end
end

return GameConfiguration