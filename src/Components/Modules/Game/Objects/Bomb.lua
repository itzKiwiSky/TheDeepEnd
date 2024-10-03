local Bomb = {}
Bomb.__index = Bomb

local function _new(x, y, height, range)
    local self = setmetatable({}, Bomb)
    self.x = x or 0
    self.y = y or 0
    self.type = "bomb"
    self.h = height or 32
    self.assets = {
        bomb = love.graphics.newImage("assets/images/bomb.png"),
        chains = {}
    }
    self.assets.chainSheet, self.assets.chainQuads = love.graphics.getHashedQuads("assets/images/chain")
    self.hitbox = {
        type = "circle",
        x = 64,
        y = 64,
        offsetX = 0,
        offsetY = 0,
        r = 42
    }

    self.hitboxRange = {
        type = "circle",
        x = 64,
        y = 64,
        offsetX = 0,
        offsetY = 0,
        r = range
    }

    for cy = self.y, self.y + self.h, 32 do
        --table.insert(self.assets.chains, {})
        if cy <= self.y then
            table.insert(self.assets.chains, {
                x = self.x,
                y = cy,
                type = "chain_end_top",
                canMove = true
            })
        elseif cy >= self.y + self.h then
            table.insert(self.assets.chains, {
                x = self.x,
                y = cy,
                type = "chain_end",
                canMove = false
            })
        else
            table.insert(self.assets.chains, {
                x = self.x,
                y = cy,
                type = "chain_body",
                canMove = true
            })
        end
    end

    return self
end

function Bomb:draw()
    for _, c in pairs(self.assets.chains) do
        local qx, qy, qw, qh = self.assets.chainQuads["chain_body"]:getViewport()
        love.graphics.draw(self.assets.chainSheet, self.assets.chainQuads[c.type], c.x, c.y + 32, 0, 2, 2, qw / 2, qh / 2)
    end
    love.graphics.draw(self.assets.bomb, self.x, self.y, 0, 2, 2, self.assets.bomb:getWidth() / 2, self.assets.bomb:getHeight() / 2)
    if registers.system.showDebugHitbox then
        if self.hitbox.type == "circle" then
            love.graphics.circle("line", self.hitbox.x, self.hitbox.y, self.hitbox.r)
        end
    end
end

function Bomb:update(elapsed)
    self.hitbox.x = self.x - self.hitbox.offsetX
    self.hitbox.y = self.y - self.hitbox.offsetY

    self.hitboxRange.x = self.x - self.hitboxRange.offsetX
    self.hitboxRange.y = self.y - self.hitboxRange.offsetY

    for _, c in ipairs(self.assets.chains) do
        c.x = math.cos(elapsed)
    end
end

return setmetatable(Bomb, { __call = function(_, ...) return _new(...) end })