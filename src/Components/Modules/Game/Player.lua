local Player = {}

function Player:init(x, y)
    self.partcles = {}
    self.partcles.bubbles = require 'src.Components.Modules.Game.Particles.bubbles'

    self.partcles.bubbles:start()

    self.x = x or love.graphics.getWidth() / 2
    self.y = y or 75
    self.gravity = 30
    self.moveSpeed = 30
    self.HP = 3
    self.maxHP = 3
    self.harpoon = false
    self.mirrored = false
    
    --  juice later XD --

    --self.diverAsset = love.graphics.newImage("assets/images/diver.png")
    self.diverAssets = {}
    self.diverAssets.image, self.diverAssets.quads = love.graphics.getQuads("assets/images/diver")
end

function Player:draw()
    --love.graphics.draw(self.diverAsset, self.x, self.y, math.rad(45), 1, 1, self.diverAsset:getWidth() / 2, self.diverAsset:getHeight() / 2)
    local qx, qy, qw, qh = self.diverAssets.quads[1]:getViewport()
    love.graphics.setBlendMode("add")
        love.graphics.draw(self.partcles.bubbles, (self.x + qw / 2) - 16, self.y - 8, 0, 0.2, 0.2)
    love.graphics.setBlendMode("alpha")
    love.graphics.draw(
        self.diverAssets.image, 
        self.diverAssets.quads[not self.harpoon and 1 or 2], 
        self.x, self.y, not self.mirrored and math.rad(45) or math.rad(-45),
        not self.mirrored and 1.5 or -1.5, 1.5, 
        qw / 2, qh / 2
    )
end

function Player:update(elapsed)
    self.y = self.y + self.gravity * elapsed
    self.partcles.bubbles:update(elapsed)

    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        -- touch shit --
    else
        if love.keyboard.isDown("left", "a") then
            self.x = self.x - self.moveSpeed * elapsed
            self.mirrored = true
            self.gravity = 30
            self.partcles.bubbles:stop()
        elseif love.keyboard.isDown("right", "d") then
            self.x = self.x + self.moveSpeed * elapsed
            self.mirrored = false
            self.gravity = 30
            self.partcles.bubbles:stop()
        elseif love.keyboard.isDown("down", "space", "s") then
            self.gravity = 70
            self.partcles.bubbles:start()
        else
            self.gravity = 30
            self.partcles.bubbles:stop()
        end
    end
end

return Player