local Block = {}
Block.__index = Block

local function _new(x, y)
    local self = setmetatable({}, Block)
    self.type = "block"
    self.hitbox = {
        x = x,
        y = y,
        w = 32,
        h = 32,
    }
    return self
end

return setmetatable(Block, { __call = function(_, ...) return _new(...) end })