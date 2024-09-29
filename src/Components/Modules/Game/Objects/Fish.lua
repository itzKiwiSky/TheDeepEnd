local Fish = {}
Fish.__index = Fish

local function _new(x, y, speed)
    local self = setmetatable({}, Fish)
    self.bubbles = require 'src.Components.Modules.Game.Particles.FishBubbles'
    self.type = "fish"
    self.x = x or 0
    self.y = y or 0
    self.speed = speed or 80
    self.drawable = love.graphics.newImage("assets/images/gamerfish.png")
    self.hitbox = {
        x = 0,
        y = 0,
        offsetX = 24,
        offsetY = 10,
        w = self.drawable:getWidth() * 2 - 10,
        h = self.drawable:getHeight() - 7, 
    }
    self.direction = "right"
    return self
end

function Fish:draw()
    love.graphics.draw(self.bubbles, self.direction == "right" and self.x + 22 or self.x - 22, self.y, 0, 0.5, 0.5)
    love.graphics.draw(self.drawable, self.x, self.y, 0, self.direction == "right" and 2 or -2, 2, self.drawable:getWidth() / 2, self.drawable:getHeight() / 2)
    if registers.system.showDebugHitbox then
        love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    end
end

function Fish:update(elapsed)
    self.bubbles:update(elapsed)

    --self.x, self.y = self.x - self.hitbox.offsetX, self.y - self.hitbox.offsetY

    self.hitbox.x = self.x - self.hitbox.offsetX
    self.hitbox.y = self.y - self.hitbox.offsetY

    switch(self.direction, {
        ["left"] = function()
            self.x = self.x - self.speed * elapsed
        end,
        ["right"] = function()
            self.x = self.x + self.speed * elapsed
        end
    })
    
    -- check bounds --
    for _, o in ipairs(world.tilesObj) do
        if collision.rectRect(o.hitbox, self.hitbox) then
            --self.direction = self.direction == "right" and "left" or "right"
            if self.hitbox.x + self.hitbox.w >= o.hitbox.x  then
                self.direction = "left"
            end
            if self.hitbox.x + self.hitbox.w >= o.hitbox.x + o.hitbox.w then
                self.direction = "right"
            end
        end 
    end

    if self.x - self.hitbox.offsetX <= 0 then
        self.direction = "right"
    end
    if self.x + self.drawable:getWidth() >= love.graphics.getWidth() then
        self.direction = "left"
    end
end

return setmetatable(Fish, { __call = function(_, ...) return _new(...) end })