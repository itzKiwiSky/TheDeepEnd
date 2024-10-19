local PatchPanel = {}
PatchPanel.__index = PatchPanel

local function _new(texturepath, x, y, w, h)
    local self = setmetatable({}, PatchPanel)
    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads(texturepath)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 32
    self.h = h or 32
    return self
end

function PatchPanel:draw()
    -- corner --
    love.graphics.draw(self.assets.sheet, self.assets.quads[1], self.x, self.y)
    love.graphics.draw(self.assets.sheet, self.assets.quads[3], self.x + self.w, self.y)
    love.graphics.draw(self.assets.sheet, self.assets.quads[7], self.x, self.y + self.h)
    love.graphics.draw(self.assets.sheet, self.assets.quads[9], self.x + self.w, self.y + self.h)


    -- faces --
    --love.graphics.draw(self.assets.sheet, self.assets.quads[2], self.x + 32, self.y, 0, (self.w - 32) / 32, 1)
    --love.graphics.draw(self.assets.sheet, self.assets.quads[4], self.x, self.y + 32, 0, 1, (self.h - 32) / 32)
    --love.graphics.draw(self.assets.sheet, self.assets.quads[6], self.x + self.w, self.y + 32, 0, 1, (self.h - 32) / 32)
    --love.graphics.draw(self.assets.sheet, self.assets.quads[8], self.x + 32, self.y + self.h, 0, (self.w - 32) / 32, 1)

    for lf = self.x + 32, (self.x + self.w) - 32, 32 do
        love.graphics.draw(self.assets.sheet, self.assets.quads[2], lf, self.y)
    end
    for lb = self.x + 32, (self.x + self.w) - 32, 32 do
        love.graphics.draw(self.assets.sheet, self.assets.quads[8], lb, self.y + self.h)
    end

    for ll = self.y + 32, (self.y + self.h) - 32, 32 do
        love.graphics.draw(self.assets.sheet, self.assets.quads[4], self.x, ll)
    end

    for lr = self.y + 32, (self.y + self.h) - 32, 32 do
        love.graphics.draw(self.assets.sheet, self.assets.quads[6], self.x + self.w, lr)
    end

    -- middle
    love.graphics.draw(self.assets.sheet, self.assets.quads[5], self.x + 32, self.y + 32, 0, (self.w - 32) / 32, (self.h - 32) / 32)
end

return setmetatable(PatchPanel, { __call = function(_, ...) return _new(...) end })