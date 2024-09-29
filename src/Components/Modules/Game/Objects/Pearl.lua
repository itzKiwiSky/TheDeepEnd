local Pearl = {}
Pearl.__index = Pearl

local function _new(x, y, points)
    local self = setmetatable({}, Pearl)
    self.type = "pearl"
    self.x = x or 0
    self.y = y or 0
    self.points = points or 5
    self.hitbox = {
        offsetX = 0,
        offsetY = 0,
        x = 0,
        y = 0,
        w = 32,
        h = 32
    }

    self.drawable = love.graphics.newImage("assets/images/pearl.png")

    self.hitbox.x = self.x - self.hitbox.offsetX
    self.hitbox.y = self.y - self.hitbox.offsetY
    return self
end

function Pearl:draw()
    love.graphics.draw(self.drawable, self.x, self.y, 0, 2, 2)
    if registers.system.showDebugHitbox then
        love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    end
end

return setmetatable(Pearl, { __call = function(_, ...) return _new(...) end })