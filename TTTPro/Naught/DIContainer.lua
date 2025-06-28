local DIContainer = {}
DIContainer.__index = DIContainer

function DIContainer.new()
    local self = setmetatable({}, DIContainer)
    self._registry = {}
    return self
end

function DIContainer:register(name, factory)
    self._registry[name] = factory
end

function DIContainer:resolve(name)
    local factory = self._registry[name]
    if not factory then
        error("Dependency '" .. name .. "' is not registered.")
    end
    return factory()
end

return DIContainer
