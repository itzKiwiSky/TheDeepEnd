PlayState = {}

function PlayState:init()
    world = require 'src.Components.Modules.Game.World'

    heartsheet, heartquads = love.graphics.getHashedQuads("assets/images/heart_hud")
    harpoonHud = love.graphics.newImage("assets/images/harpoon.png")

    viewcam = camera()

    camScroll = {
        scrollX = 0,
        scrollY = 0,
        x = 0,
        y = 0,
        xMultiplier = 0.04,
        yMultiplier = 0.04
    }
end

function PlayState:enter()
    world:init()
    world:build("assets/data/levels/level4.lua")
    camScroll.x = world.templates.player.x
    camScroll.y = world.templates.player.y
end

function PlayState:draw()
    viewcam:attach()
        world:draw()
    viewcam:detach()

    -- Hud Thing --
    for h = 1, world.templates.player.maxHP, 1 do
        if h <= world.templates.player.HP then
            love.graphics.draw(heartsheet, heartquads["hearton"], h * 40 - 16, 20, 0, 2, 2)
        else
            love.graphics.draw(heartsheet, heartquads["heartoff"], h * 40 - 16, 20, 0, 2, 2)
        end
    end

    for h = 1, world.templates.player.carringHarpoon, 1 do
        love.graphics.draw(harpoonHud, h * 40 , 60, math.rad(45), 0.8, 0.8)
    end

    if registers.user.paused then
        love.graphics.setColor(0, 0, 0, 0.4)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function PlayState:update(elapsed)
    if registers.user.paused then

    elseif registers.user.levelEnded then

    else
        -- camera scroll --
        camScroll.scrollX = camScroll.scrollX - (camScroll.scrollX - world.templates.player.x) * camScroll.xMultiplier
        camScroll.scrollY = camScroll.scrollY - (camScroll.scrollY - world.templates.player.y) * camScroll.yMultiplier
        camScroll.x = camScroll.scrollX
        camScroll.y = camScroll.scrollY
    
        -- cam scroll --
        viewcam:lookAt(camScroll.x, camScroll.y)

        -- camera bounds --
        if viewcam.x < love.graphics.getWidth() / 2 then
            viewcam.x = love.graphics.getWidth() / 2
        end

        if viewcam.y < love.graphics.getHeight() / 2 then
            viewcam.y = love.graphics.getHeight() / 2
        end

        if viewcam.x > world.width - love.graphics.getWidth() / 2 then
            viewcam.x = world.width - love.graphics.getWidth() / 2
        end

        if viewcam.y > world.height - love.graphics.getHeight() / 2 then
            viewcam.y = world.height - love.graphics.getHeight() / 2
        end

        world:update(elapsed)
    end
end

function PlayState:keypressed(k)
    if k == "escape" then
        registers.user.paused = not registers.user.paused
    end
end

return PlayState