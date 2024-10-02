local Explosion = {}
Explosion.__index = Explosion

local function _new(x, y)
    local self = setmetatable({}, Explosion)
    self.x = x
    self.y = y
    self.assets = {}
    self.type = "explosion"
    self.assets.sheet, self.assets.quads = love.graphics.getHashedQuads("assets/images/explosion")
    self.frame = 0
    self.explosionId = math.random(1, 3)
    self.frameTimer = 0
    self.frameSpeed = 0.01
    self.lastFrame = false
    self.maxFrames = 11
    return self
end

function Explosion:draw()
    local qx, qy, qw, qh = self.assets.quads["explosion1_0"]:getViewport()
    love.graphics.draw(self.assets.sheet, self.assets.quads["explosion" .. self.explosionId .. "_" .. self.frame], self.x, self.y, 0, 2, 2, qw / 2, qh / 2)
end

function Explosion:update(elapsed)
    self.frameTimer = self.frameTimer + elapsed
    if self.frame < self.maxFrames then
        if self.frameTimer >= self.frameSpeed then
            self.frameTimer = 0
            self.frame = self.frame + 1
        end
    else
        self.lastFrame = true
    end
end

return setmetatable(Explosion, { __call = function(_, ...) return _new(...) end })