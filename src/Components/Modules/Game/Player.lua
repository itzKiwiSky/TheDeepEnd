local Player = {}

function Player:setPos(x, y)
    self.x = x or love.graphics.getWidth() / 2
    self.y = y or 75
    self.gravity = 20
    self.moveSpeed = 15
    
    --  juice later XD --

    self.diverAsset = love.graphics.newImage("assets/images/diver.png")
end

function Player:draw()
    love.graphics.draw(self.diverAsset, self.x, self.y, math.rad(45), 1, 1, self.diverAsset:getWidth() / 2, self.diverAsset:getHeight() / 2)
end

function Player:update(elapsed)
    self.y = self.y + self.gravity * elapsed

    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        -- touch shit --
    else
        if love.keyboard.isDown("left", "a") then
            self.x = self.x - self.moveSpeed * elapsed
            self.gravity = 20
        elseif love.keyboard.isDown("right", "d") then
            self.x = self.x + self.moveSpeed * elapsed
            self.gravity = 20
        elseif love.keyboard.isDown("down", "space") then
            self.gravity = 40
        else
            self.gravity = 20
        end
    end
end

return Player