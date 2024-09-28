local Pufferfish = {}
Pufferfish.__index = Pufferfish

local function _new(x, y, range)
    local self = setmetatable({}, Pufferfish)
    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads("assets/images/pufferfish")
    self.x = x or 0
    self.y = y or 0
    self.targetX = 0
    self.targetY = 0
    self.range = range or 100
    self.speed = 10
    self.direction = "right"

    self.frameTimer = 0
    self.frameSpeed = 0.2
    self.frame = 1
    self.state = "idle"
    return self
end

function Pufferfish:draw()
    local qx, qy, qw, qh = self.assets.quads[1]:getViewport()
    love.graphics.draw(
        self.assets.sheet, self.assets.quads[self.frame], 
        self.x, self.y, 0, self.direction == "right" and 2 or -2, 2, 2, qw / 2, qh / 2
    )
end

function Pufferfish:update(elapsed)
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

return setmetatable(Pufferfish, { __call = function(_, ...) return _new(...) end })