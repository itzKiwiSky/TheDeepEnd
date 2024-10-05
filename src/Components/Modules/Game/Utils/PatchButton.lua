local PatchButton = {}
PatchButton.__index = PatchButton

local function _new(texturepath, text, x, y, w, h)
    local self = setmetatable({}, PatchButton)
    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads(texturepath)
    self.font = fontcache.getFont("phoenixbios", 26)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 32
    self.h = h or 32
    self.text = text or "sample"
    return self
end

function PatchButton:draw()
    -- corner --
    love.graphics.draw(self.assets.sheet, self.assets.quads[1], self.x, self.y)
    love.graphics.draw(self.assets.sheet, self.assets.quads[3], self.x + self.w, self.y)
    love.graphics.draw(self.assets.sheet, self.assets.quads[7], self.x, self.y + self.h)
    love.graphics.draw(self.assets.sheet, self.assets.quads[9], self.x + self.w, self.y + self.h)


    -- faces --
    love.graphics.draw(self.assets.sheet, self.assets.quads[2], self.x + 32, self.y, 0, (self.w - 32) / 32, 1)
    love.graphics.draw(self.assets.sheet, self.assets.quads[4], self.x, self.y + 32, 0, 1, (self.h - 32) / 32)
    love.graphics.draw(self.assets.sheet, self.assets.quads[6], self.x + self.w, self.y + 32, 0, 1, (self.h - 32) / 32)
    love.graphics.draw(self.assets.sheet, self.assets.quads[8], self.x + 32, self.y + self.h, 0, (self.w - 32) / 32, 1)

    -- middle
    love.graphics.draw(self.assets.sheet, self.assets.quads[5], self.x + 32, self.y + 32, 0, (self.w - 32) / 32, (self.h - 32) / 32)

    -- text --
    love.graphics.printf(self.text, self.font, self.x , self.y + self.h / 2, self.w + 32, "center")

    --love.graphics.rectangle("line", self.x, self.y, self.w + 32, self.h + 32)
end

function PatchButton:hover(elapsed)
    local mx, my = love.mouse.getPosition()

    if collision.pointRect({x = mx, y = my}, {x = self.x, y = self.y, w = self.w + 32, h = self.h + 32}) then
        return true
    end
    return false
end

function PatchButton:clicked()
    local mx, my = love.mouse.getPosition()

    if collision.pointRect({x = mx, y = my}, {x = self.x, y = self.y, w = self.w + 32, h = self.h + 32}) then
        if love.mouse.isDown(1) then
            return true
        end
    end
    return false
end

return setmetatable(PatchButton, { __call = function(_, ...) return _new(...) end })