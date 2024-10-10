PlayState = {}

PlayState.currentLevel = 0

local function reset()
    -- reset camera --
    viewcam.x = love.graphics.getWidth() / 2
    viewcam.y = love.graphics.getHeight() / 2
    camScroll.x = viewcam.x
    camScroll.y = viewcam.y
    camScroll.scrollX = love.graphics.getWidth() / 2
    camScroll.scrollY = love.graphics.getHeight() / 2

    -- build world --
    world:build("assets/data/levels/level0_" .. PlayState.currentLevel .. ".lua")

    -- set camera to player --
    camScroll.x = world.templates.player.x
    camScroll.y = world.templates.player.y

    --world.templates.player.HP = world.templates.player.maxHP
    world.templates.player:init(world.spawnX, world.spawnY)
end

function PlayState:init()
    world = require 'src.Components.Modules.Game.World'

    heartsheet, heartquads = love.graphics.getHashedQuads("assets/images/heart_hud")
    harpoonHud = love.graphics.newImage("assets/images/harpoon.png")
    pauseButton = love.graphics.newImage("assets/images/pauseButton.png")

    world:init()

    fnt_gameFont = fontcache.getFont("phoenixbios", 30)

    effect = moonshine(moonshine.effects.vignette)
    effect.vignette.radius = 0.8

    viewcam = camera()

    camScroll = {
        scrollX = 0,
        scrollY = 0,
        x = 0,
        y = 0,
        xMultiplier = 0.04,
        yMultiplier = 0.04
    }
    

    GlobalTouch:registerArea("leftTouch", 0, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    GlobalTouch:registerArea("rightTouch", love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    GlobalTouch:registerArea("tap", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    GlobalTouch:registerArea("pauseTap", 32, 32, 64, 64)
end

function PlayState:enter()
    reset()
end

function PlayState:draw()
    effect(function()
        viewcam:attach()
            world:draw()
        viewcam:detach()
    end)
    
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

    if not registers.user.roundStarted then
        if love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X" then
            love.graphics.printf(languageService["game_press_dive"], fnt_gameFont, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
        else
            love.graphics.printf(languageService["game_touch_dive"], fnt_gameFont, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
        end
    end

    if registers.user.levelEnded then
        if love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X" then
            love.graphics.printf(languageService["game_complete_level"], fnt_gameFont, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
        else
            love.graphics.printf(languageService["game_complete_level_touch"], fnt_gameFont, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
        end
    end

    if world.templates.player.HP <= 0 then
        if love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X" then
            love.graphics.printf(languageService["game_player_dead"], fnt_gameFont, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
        else
            love.graphics.printf(languageService["game_player_dead_touch"], fnt_gameFont, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
        end
    end


    if love.system.getOS == "Android" or love.system.getOS == "iOS" then
        love.graphics.draw(pauseButton, 32, 32, 0, 2, 2)
    end

    --GlobalTouch:display()
end

function PlayState:update(elapsed)
    if not registers.user.roundStarted then
        if GlobalTouch:isHit("tap") then
            registers.user.roundStarted = true
        end
        return
    end

    if GlobalTouch:isHit("pauseTap") then
        registers.user.paused = not registers.user.paused
    end

    if registers.user.paused then
        return
    elseif registers.user.levelEnded then
        return
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
    --[[
    if registers.user.levelEnded then
        if k == "space" then
            if PlayState.currentLevel < 4 then
                registers.user.levelEnded = false
                registers.user.roundStarted = false
                PlayState.currentLevel = PlayState.currentLevel + 1
                reset()
            else
                gamestate.switch(EndDemoState)
            end
        end
    end
    ]]--
    if k == "space" then
        if registers.user.levelEnded then
            if PlayState.currentLevel < 4 then
                registers.user.levelEnded = false
                registers.user.roundStarted = false
                PlayState.currentLevel = PlayState.currentLevel + 1
                reset()
            else
                gamestate.switch(EndDemoState)
            end
        elseif not registers.user.roundStarted then
            registers.user.roundStarted = true
        elseif world.templates.player.HP <= 0 then
            registers.user.roundStarted = false
            reset()
        end
    end
end

function PlayState:touchpressed(id, x, y, dx, dy, pressure)
    GlobalTouch:touchpressed(id, x, y, dx, dy, pressure)
end

function PlayState:touchmoved(id, x, y, dx, dy, pressure)
    GlobalTouch:touchmoved(id, x, y, dx, dy, pressure)
end

function PlayState:touchreleased(id, x, y, dx, dy, pressure)
    GlobalTouch:touchreleased(id, x, y, dx ,dy, pressure)
end

return PlayState