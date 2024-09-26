PlayState = {}

function PlayState:init()
    world = require 'src.Components.Modules.Game.World'

    heartsheet, heartquads = love.graphics.getHashedQuads("assets/images/heart_hud")
end

function PlayState:enter()
    world:init("assets/data/levels/level_debug.lua")
end

function PlayState:draw()
    world:draw()
    --f:draw()

    -- Hud Thing --
    for h = 1, world.templates.player.maxHP, 1 do
        if h <= world.templates.player.HP then
            love.graphics.draw(heartsheet, heartquads["hearton"], h * 40 - 16, 20, 0, 2, 2)
        else
            love.graphics.draw(heartsheet, heartquads["heartoff"], h * 40 - 16, 20, 0, 2, 2)
        end
    end
end

function PlayState:update(elapsed)
    if registers.user.paused then

    else
        world:update(elapsed)
    end
end

function PlayState:keypressed(k)
    if k == "escape" then
        registers.user.paused = not registers.user.paused
    end
end

return PlayState