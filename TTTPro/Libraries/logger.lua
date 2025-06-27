local Logger = {}

local logFilePath = "log.txt"

local function writeToFile(message)
    local file = io.open(logFilePath, "a")
    if file then
        file:write(message .. "\n")
        file:close()
    else
        print("ERROR: Unable to open log file.")
    end
end

function Logger.log(level, message)
    print(string.format("[%s] %s", level, message))
    writeToFile(message)
end

function Logger.debug(message)
    Logger.log("DEBUG", message)
end

function Logger.error(message)
    Logger.log("ERROR", message)
end

function Logger.info(message)
    Logger.log("INFO", message)
end

return Logger