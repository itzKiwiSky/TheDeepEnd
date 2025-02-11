MenuState = {}

function MenuState:init()
    BGParticles = require 'src.Components.Modules.Game.Particles.BGParticles'
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'

    -- bg objs ---
    bg_fish = require 'src.Components.Modules.Game.MenuObjects.Fish'

    snd_ambientSound = love.audio.newSource("assets/sounds/ambient/underwater.ogg", "static")
    snd_themeOST = love.audio.newSource("assets/sounds/theme.ogg", "static")
    mountainsBG = love.graphics.newImage("assets/images/menu/mountains.png")

    logoGame = love.graphics.newImage("assets/images/menu/logogame.png")
    logoDemo = love.graphics.newImage("assets/images/menu/demoText.png")
    logoGameY = 140
    logoSpeed = 2.1
    logoAmplitude = 1.2
end

function MenuState:enter()
    menuCam = camera()

    bg_gradient = love.graphics.newGradient("vertical", {40, 40, 40, 255}, {0, 0, 0, 255})
    bg_transparentGradient = love.graphics.newGradient("vertical", {255, 255, 255, 0}, {255, 255, 255, 255})

    bgobjects = {}

    effect = moonshine(moonshine.effects.vignette)
    effect.vignette.radius = 1.4

    Presence.largeImageKey = "game_rpc"
    Presence.largeImageText = "Loading..."
    Presence.state = "Checking menus"
    Presence.details = "Looking in the menus"
    Presence.update()

    fnt_menuVersion = fontcache.getFont("phoenixbios", 18)

    -- time sys -- 
    time = 0
    transitionOut = false

    buttons = {}

    -- menu definitions --
    viewElements = {
        container = {
            x = love.graphics.getWidth() / 2 - 128,
            y = love.graphics.getHeight() / 2 - 200,
            w = 280,
            h = 48,
            margins = 32
        },
        elements = {
            {
                text = languageService["menu_buttons_play"],
                locked = false,
                onClick = function()
                    if not transitionOut then
                        camTween = flux.to(menuCam, 5, {y = love.graphics.getHeight()})
                        camTween:ease("backin")
                        camTween:oncomplete(function()
                            snd_themeOST:stop()
                            snd_ambientSound:seek(0)
                            gamestate.switch(MissionSelectionState)
                        end)
                        transitionOut = true
                    end
                end
            },
            {
                text = languageService["menu_buttons_options"],
                locked = true,
                onClick = function()
                    print("cont")
                end
            },
            {
                text = languageService["menu_buttons_achievements"],
                locked = false,
                onClick = function()
                    
                end
            },
            {
                text = languageService["menu_buttons_credits"],
                locked = false,
                onClick = function()
                    if not transitionOut then
                        camTween = flux.to(menuCam, 5, {y = love.graphics.getHeight()})
                        camTween:ease("backin")
                        camTween:oncomplete(function()
                            snd_themeOST:stop()
                            snd_ambientSound:seek(0)
                            gamestate.switch(CreditsState)
                        end)
                        transitionOut = true
                    end
                end
            },
            {
                text = languageService["menu_buttons_exit"],
                locked = false,
                onClick = function()
                    love.event.quit()
                end
            },
        }
    }

    for e = 1, #viewElements.elements, 1 do
        local element = viewElements.elements[e]
        table.insert(buttons, {
            btn = buttonPatch(
                "assets/images/framestyles/frameStyle_linesmooth", element.text, viewElements.container.x, 
                viewElements.container.y + e * 3 * viewElements.container.margins, 
                viewElements.container.w, viewElements.container.h
            ),
            locked = element.locked,
            onClick = element.onClick,
            id = "touch" .. e,
        })

        GlobalTouch:registerArea(
            "touch" .. e,
            viewElements.container.x, viewElements.container.y + e * 3 * viewElements.container.margins, 
            viewElements.container.w, viewElements.container.h
        )
    end

    bg = {
        {
            offset = 640,
            x = 0,
            items = {},
            speed = 15,
            colorLevel = 0.28,
            height = 30,
        },
        {
            offset = 512,
            x = 0,
            items = {},
            speed = 20,
            colorLevel = 0.45,
            height = 20,
        },
        {
            offset = 256,
            x = 0,
            items = {},
            speed = 25,
            colorLevel = 0.7,
            height = 10,
        },
        {
            offset = 0,
            x = 0,
            items = {},
            speed = 30,
            colorLevel = 0.9,
            height = 0,
        },
    }
    
    for l = 1, #bg, 1 do
        for d = 0, 3, 1 do
            table.insert(bg[l].items, {
                y = (love.graphics.getHeight() - mountainsBG:getHeight()) - bg[l].height,
                x = mountainsBG:getWidth() * d - bg[l].offset,
                drawable = mountainsBG
            })
        end
    end

    for f = 1, math.random(5, 15), 1 do
        table.insert(bgobjects, bg_fish(math.random(100, 500), math.random(200, 600), math.random(1, 2) == 1 and "left" or "right"))
    end

    -- sounds --
    if not snd_ambientSound:isPlaying() then
        snd_ambientSound:setLooping(true)
        snd_ambientSound:setVolume(0.3)
        snd_ambientSound:play()
    end
    snd_themeOST:setLooping(true)
    snd_themeOST:play()
end

function MenuState:draw()
    menuCam:attach()
        effect(function()
            love.graphics.draw(bg_gradient, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            for _, o in pairs(bgobjects) do
                o:draw()
            end

            love.graphics.draw(BGParticles, 340, love.graphics.getHeight())
            for _, l in ipairs(bg) do
                for _, m in ipairs(l.items) do
                    love.graphics.setColor(l.colorLevel, l.colorLevel, l.colorLevel)
                    love.graphics.draw(m.drawable, m.x + l.speed, m.y)
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end

            love.graphics.draw(logoGame, love.graphics.getWidth() / 2, 20 + logoGameY, 0, 1.2, 1.2, logoGame:getWidth() / 2, logoGame:getHeight() / 2)
            love.graphics.draw(logoDemo, logoGame:getWidth() + 60, logoGameY - 40, 0, 0.8, 0.8, logoDemo:getWidth() / 2, logoDemo:getHeight() / 2)

            for _, e in ipairs(buttons) do
                if e.btn:hover() then
                    love.graphics.setColor(0.7, 0.7, 0.7, 1)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end
                if e.locked then
                    love.graphics.setColor(0.4, 0.4, 0.4, 1)
                end
                e.btn:draw()
                love.graphics.setColor(1, 1, 1, 1)
            end

            love.graphics.setBlendMode("alpha")
            love.graphics.setColor(0, 0, 0, 1)
                love.graphics.draw(bg_transparentGradient, 0, love.graphics.getHeight() - 128, 0, love.graphics.getWidth(), 128)
                love.graphics.draw(bg_transparentGradient, 0, 128, 0, love.graphics.getWidth(), -128)
                love.graphics.rectangle("fill", 0, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight() * 2)
                love.graphics.rectangle("fill", 0, -256, love.graphics.getWidth(), 256)
            love.graphics.setColor(1, 1, 1, 1)

            love.graphics.setColor(0.6, 0.6, 0.6, 1)
                love.graphics.print("version " .. buildValues.version, fnt_menuVersion, 10, love.graphics.getHeight() - fnt_menuVersion:getHeight())
            love.graphics.setColor(1, 1, 1, 1)
        end)
    menuCam:detach()
end

function MenuState:update(elapsed)
    for _, e in ipairs(buttons) do
        e.btn.mx, e.btn.my = menuCam:mousePosition()
        if GlobalTouch:isHit(e.id) and not e.locked then
            e.onClick()
        end
    end
    time = time + elapsed
    logoGameY = logoGameY + math.sin(time * logoSpeed) * logoAmplitude

    -- bg move -- 
    BGParticles:update(elapsed)

    -- tween --
    if transitionOut then
        flux.update(elapsed)
    end

    for _, o in pairs(bgobjects) do
        o:update(elapsed)

        if o.x <= -128 then
            table.remove(bgobjects, _)
            table.insert(bgobjects, bg_fish(-96, math.random(200, 600), "right"))
        end
        if o.x >= love.graphics.getWidth() + 128 then
            table.remove(bgobjects, _)
            table.insert(bgobjects, bg_fish(love.graphics.getWidth() + 128, math.random(200, 600), "left"))
        end
    end

    for _, l in ipairs(bg) do
        for _, m in ipairs(l.items) do
            m.x = m.x - l.speed * elapsed

            if m.x + m.drawable:getWidth() <= -m.drawable:getWidth() - l.offset then
                table.remove(l.items, _)
                table.insert(l.items, {
                    y = (love.graphics.getHeight() - mountainsBG:getHeight()) - l.height,
                    x = mountainsBG:getWidth() * 2 - l.offset,
                    drawable = mountainsBG
                })

            end
        end
    end
end

function MenuState:mousepressed(x, y, button)
    for _, e in ipairs(buttons) do
        if e.btn:clicked() and not e.locked then
            e.onClick()
        end
    end
end

function MenuState:touchpressed(id, x, y, dx, dy, pressure)
    GlobalTouch:touchpressed(id, x, y, dx, dy, pressure)
end

function MenuState:touchmoved(id, x, y, dx, dy, pressure)
    GlobalTouch:touchmoved(id, x, y, dx, dy, pressure)
end

function MenuState:touchreleased(id, x, y, dx, dy, pressure)
    GlobalTouch:touchreleased(id, x, y, dx ,dy, pressure)
end

return MenuState