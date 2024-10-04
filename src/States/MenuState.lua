MenuState = {}

function MenuState:enter()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'
    btn = buttonPatch("assets/images/patchButton", "sexo", 90, 90, 128, 64)

    snd_ambientSound = love.audio.newSource("assets/sounds/ambient/underwater.ogg", "static")
    snd_themeOST = love.audio.newSource("assets/sounds/theme.ogg", "static")

    fnt_logoGame = fontcache.getFont("phoenixbios", 40)

    buttons = {}

    viewElements = {
        container = {
            x = love.graphics.getWidth() / 2 - 128,
            y = love.graphics.getHeight() / 2 - 150,
            w = 256,
            h = 48,
            margins = 32
        },
        elements = {
            {
                text = languageService["menu_buttons_new_game"],
                locked = false,
                onClick = function()
                    snd_themeOST:stop()
                    snd_ambientSound:seek(0)
                    gamestate.switch(PlayState)
                end
            },
            {
                text = languageService["menu_buttons_continue"],
                locked = true,
                onClick = function()
                    print("cont")
                end
            },
            {
                text = languageService["menu_buttons_credits"],
                locked = false,
                onClick = function()
                    print("cont")
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
                "assets/images/patchButton", element.text, viewElements.container.x, 
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

    --print(debug.formattable(buttons))

    -- sounds --
    snd_ambientSound:setLooping(true)
    snd_ambientSound:setVolume(0.3)
    snd_ambientSound:play()
    snd_themeOST:setLooping(true)
    snd_themeOST:play()
end

function MenuState:draw()
    love.graphics.printf("The Deep End", fnt_logoGame,0, 200, love.graphics.getWidth(), "center")

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
end

function MenuState:update(elapsed)
    for _, e in ipairs(buttons) do
        if GlobalTouch:isHit(e.id) and not e.locked then
            e.onClick()
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