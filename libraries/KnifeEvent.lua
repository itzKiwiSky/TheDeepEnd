-- KnifeEvent module
local KnifeEvent = {}

-- KnifeEvent handler registry
KnifeEvent.handlers = {}

-- Remove an KnifeEvent handler from the registry
local function remove (self)
    if not self.isRegistered then
        return self
    end
    if self.prevHandler then
        self.prevHandler.nextHandler = self.nextHandler
    end
    if self.nextHandler then
        self.nextHandler.prevHandler = self.prevHandler
    end
    if KnifeEvent.handlers[self.name] == self then
        KnifeEvent.handlers[self.name] = self.nextHandler
    end
    self.prevHandler = nil
    self.nextHandler = nil
    self.isRegistered = false

    return self
end

-- Insert an KnifeEvent handler into the registry
local function register (self)
    if self.isRegistered then
        return self
    end
    self.nextHandler = KnifeEvent.handlers[self.name]
    if self.nextHandler then
        self.nextHandler.prevHandler = self
    end
    KnifeEvent.handlers[self.name] = self
    self.isRegistered = true

    return self
end

-- Create an KnifeEvent handler
local function Handler (name, callback)
    return {
        name = name,
        callback = callback,
        isRegistered = false,
        remove = remove,
        register = register
    }
end



-- Create and register a new KnifeEvent handler
function KnifeEvent.on (name, callback)
    return register(Handler(name, callback))
end

-- Dispatch an KnifeEvent
function KnifeEvent.dispatch (name, ...)
    local handler = KnifeEvent.handlers[name]

    while handler do
        if handler.callback(...) == false then
            return handler
        end
        handler = handler.nextHandler
    end
end

local function isCallable (value)
    return type(value) == 'function' or
        getmetatable(value) and getmetatable(value).__call
end

-- Inject a dispatcher into a table.
local function hookDispatcher (t, key)
    local original = t[key]

    if isCallable(original) then
        t[key] = function (...)
            original(...)
            return KnifeEvent.dispatch(key, ...)
        end
    else
        t[key] = function (...)
            return KnifeEvent.dispatch(key, ...)
        end
    end
end

-- Inject dispatchers into a table. Examples:
-- KnifeEvent.hook(love.handlers)
-- KnifeEvent.hook(love, { 'load', 'update', 'draw' })
function KnifeEvent.hook (t, keys)
    if keys then
        for _, key in ipairs(keys) do
            hookDispatcher(t, key)
        end
    else
        for key in pairs(t) do
            hookDispatcher(t, key)
        end
    end
end

return KnifeEvent