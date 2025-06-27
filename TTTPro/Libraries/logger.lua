local Logger = {}

function Logger.log(level, message)
    print(string.format("[%s] %s", level, message))
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