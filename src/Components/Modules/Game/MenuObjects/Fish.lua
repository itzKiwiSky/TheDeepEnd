local Fish = {}
Fish.__index = Fish

local function _new(x, y, direction)
    local self = setmetatable({}, Fish)
    self.bubbles = require 'src.Components.Modules.Game.Particles.FishBubbles'
    self.direction = direction
    self.x = x
    self.y = y
    self.speed = math.random(50, 100)
    self.drawable = love.graphics.newImage("assets/images/game/props/gamerfish.png")
    return self
end

function Fish:draw()
    love.graphics.draw(self.bubbles, self.direction == "right" and self.x + 22 or self.x - 22, self.y, 0, 0.5, 0.5)
    love.graphics.draw(self.drawable, self.x, self.y, 0, self.direction == "right" and 2 or -2, 2, self.drawable:getWidth() / 2, self.drawable:getHeight() / 2)
end

function Fish:update(elapsed)
    self.bubbles:update(elapsed)

    switch(self.direction, {
        ["left"] = function()
            self.x = self.x - self.speed * elapsed
        end,
        ["right"] = function()
            self.x = self.x + self.speed * elapsed
        end
    })
end

return setmetatable(Fish, { __call = function(_, ...) return _new(...) end })