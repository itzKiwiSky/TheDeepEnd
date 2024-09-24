local Fish = {}
Fish.__index = Fish

local function _new(x, y, speed)
    local self = setmetatable({}, Fish)
    self.x = x or 0
    self.y = y or 0
    self.speed = speed or 150
    self.drawable = love.graphics.newImage("assets/images/gamerfish.png")
    self.hitbox = {
        offsetX = 24,
        offsetY = 10,
        w = self.drawable:getWidth() * 2 - 10,
        h = self.drawable:getHeight() - 7, 
    }
    self.direction = "right"
    return self
end

function Fish:draw()
    love.graphics.draw(self.drawable, self.x, self.y, 0, self.direction == "right" and 2 or -2, 2, self.drawable:getWidth() / 2, self.drawable:getHeight() / 2)
    love.graphics.rectangle("line", self.x - self.hitbox.offsetX, self.y - self.hitbox.offsetY, self.hitbox.w, self.hitbox.h)
end

function Fish:update(elapsed)
    -- check bounds --
    if self.x - self.hitbox.offsetX <= 0 then
        self.direction = "right"
    end
    if self.x + self.drawable:getWidth() >= love.graphics.getWidth() then
        self.direction = "left"
    end


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