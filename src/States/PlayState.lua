PlayState = {}

function PlayState:init()
    player = require 'src.Components.Modules.Game.Player'
    fish = require 'src.Components.Modules.Game.Fish'
    player:init(nil, 100)

    f = fish(90, 300)

    heartsheet, heartquads = love.graphics.getHashedQuads("assets/images/heart_hud")
end

function PlayState:enter()

end

function PlayState:draw()
    player:draw()
    f:draw()

    -- Hud Thing --
    for h = 1, player.maxHP, 1 do
        if h <= player.HP then
            love.graphics.draw(heartsheet, heartquads["hearton"], h * 40 - 16, 20, 0, 2, 2)
        else
            love.graphics.draw(heartsheet, heartquads["heartoff"], h * 40 - 16, 20, 0, 2, 2)
        end
    end
end

function PlayState:update(elapsed)
    if registers.user.paused then
        return
    end
    player:update(elapsed)
    f:update(elapsed)
end

function PlayState:keypressed(k)
    if k == "escape" then
        registers.user.paused = not registers.user.paused
    end
end

return PlayState