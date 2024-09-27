local Pufferfish = {}
Pufferfish.__index = Pufferfish

local function _new(x, y, range, staticTime)
    local self = setmetatable({}, Pufferfish)
    self.x = x or 0
    self.y = y or 0
    self.range = range or 100
    self.staticTime = staticTime or 300
    return self
end

return setmetatable(Pufferfish, { __call = function(_, ...) return _new(...) end })