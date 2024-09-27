local EndHitbox = {}
EndHitbox.__index = EndHitbox

local function _new(x, y, w, h, nextLevel)
    local self = setmetatable({}, EndHitbox)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.nextLevel = nextLevel
    return self
end

return setmetatable(EndHitbox, { __call = function(_, ...) return _new(...) end })