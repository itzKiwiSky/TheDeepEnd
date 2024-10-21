local Pufferfish = {}
Pufferfish.__index = Pufferfish

local function _new(x, y, range)
    local self = setmetatable({}, Pufferfish)
    self.type = "pufferfish"
    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads("assets/images/game/props/pufferfish")
    self.x = x or 0
    self.y = y or 0
    self.targetX = 0
    self.targetY = 0
    self.range = range or 100
    self.speed = 10
    self.direction = "right"

    self.hitbox = {
        x = 0,
        y = 0,
        offsetX = 16,
        offsetY = 16,
        w = 32,
        h = 32,
        range = {
            x = self.x,
            y = self.y,
            r = self.range
        }
    }

    self.frameTimer = 0
    self.frameSpeed = 0.1
    self.frame = 1
    self.state = "idle"
    return self
end

function Pufferfish:draw()
    local qx, qy, qw, qh = self.assets.quads[1]:getViewport()
    love.graphics.draw(
        self.assets.sheet, self.assets.quads[self.frame], 
        self.x, self.y, 0, self.direction == "right" and 2 or -2, 2, qw / 2, qh / 2
    )
    if registers.system.showDebugHitbox then
        love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
        love.graphics.circle("line", self.hitbox.range.x, self.hitbox.range.y, self.hitbox.range.r)
    end
end

function Pufferfish:update(elapsed)
    local qx, qy, qw, qh = self.assets.quads[1]:getViewport()

    if self.state == "idle" then
        self.hitbox.x = self.x - self.hitbox.offsetX
        self.hitbox.y = self.y - self.hitbox.offsetY
        self.hitbox.range.x = self.x
        self.hitbox.range.y = self.y

        switch(self.direction, {
            ["left"] = function()
                self.x = self.x - self.speed * elapsed
            end,
            ["right"] = function()
                self.x = self.x + self.speed * elapsed
            end
        })

        -- check bounds --
        if self.x - self.hitbox.offsetX <= 0 then
            self.direction = "right"
        end
        if self.x + qw >= love.graphics.getWidth() then
            self.direction = "left"
        end

        
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

        --[[
        for _, o in ipairs(world.tilesObj) do
            if collision.rectRect(self.hitbox, o.hitbox) then
                self.direction = self.direction == "right" and "left" or "right"
            end
        end
        ]]--
        
        if collision.circRect(self.hitbox.range, world.templates.player.hitbox) then
            self.state = "transform"
        end
    elseif self.state == "transform" then
        self.frameTimer = self.frameTimer + elapsed
        if self.frameTimer >= self.frameSpeed then
            self.frameTimer = 0
            self.frame = self.frame + 1
        end
        if self.frame >= #self.assets.quads then
            self.state = "static"
        end
    elseif self.state == "static" then
        self.hitbox.offsetX = 32
        self.hitbox.offsetY = 32
        self.hitbox.w = 64
        self.hitbox.h = 64
        self.hitbox.x = self.x - self.hitbox.offsetX
        self.hitbox.y = self.y - self.hitbox.offsetY
        self.frame = #self.assets.quads
    end
end

return setmetatable(Pufferfish, { __call = function(_, ...) return _new(...) end })