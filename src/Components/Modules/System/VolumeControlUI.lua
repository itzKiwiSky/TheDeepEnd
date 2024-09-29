local volController = {}
volController.__index = volController

local function _new()
    local self = setmetatable({}, volController)
    self.camera = camera(love.graphics.getWidth() / 2, love.graphics.getHeight())
    self.visible = false
    self.value = 2
    self.state = "volIcon_mute"
    self.assets = {}
    self.assets.volIconSheet, self.assets.volIconQuads = love.graphics.getHashedQuads("assets/images/system/volIcons")
    self.camera:zoom(0.5)
    self.assets.sndBlip = love.audio.newSource("assets/sounds/volumePlay.ogg", "static")

    self.pos = {
        x = love.graphics.getWidth() / 2 - 256,
        y = 0,
    }

    self.visible = false
    self.waitTimer = 0

    self.muted = false
    self.lastValue = self.value

    return self
end

function volController:draw()
    if self.visible then
        self.camera:attach()
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", self.pos.x, self.pos.y, 512, 128, 10, 10)
            love.graphics.setColor(1, 1, 1, 1)

            for i = 1, 10, 1 do
                if i <= self.value then
                    love.graphics.setColor(1, 1, 1, 1)
                else
                    love.graphics.setColor(0, 0, 0, 1)
                end
                love.graphics.rectangle("fill", (self.pos.x + 76) + 38 * i, self.pos.y + 24, 32, 86, 10, 10)
                love.graphics.setColor(1, 1, 1, 1)
            end

            love.graphics.draw(self.assets.volIconSheet, self.assets.volIconQuads[self.state], self.pos.x + 64, self.pos.y + 64, 0, 1, 1, 64, 64)
        self.camera:detach()
    end
end

function volController:update(elapsed)
    love.audio.setVolume(0.1 * self.value)

    if self.value < 0 then
        self.value = 0
    end
    if self.value > 10 then
        self.value = 10
    end

    if self.visible then
        self.waitTimer = self.waitTimer + elapsed

        if self.waitTimer >= 4 then
            self.visible = false
        end
    end

    if self.value <= 0 then
        self.state = "volIcon_mute"
    elseif self.value >= 3 and self.value <= 5 then
        self.state = "volIcon_vol1"
    elseif self.value >= 5 and self.value <= 7 then
        self.state = "volIcon_vol2"
    elseif self.value >= 8 then
        self.state = "volIcon_vol3"
    end
end

function volController:keypressed(k)
    if k == "0" then
        self.visible = true
        self.waitTimer = 0
        self.value = 0
        self.assets.sndBlip:play()
    end
    if k == "-" then
        self.visible = true
        self.waitTimer = 0
        self.value = self.value - 1
        self.assets.sndBlip:play()
    end
    if k == "=" or k == "+" then
        self.visible = true
        self.waitTimer = 0
        self.value = self.value + 1
        self.assets.sndBlip:play()
    end
end

return setmetatable(volController, { __call = function(_, ...) return _new(...) end })