EndDemoState = {}

function EndDemoState:enter()
    fnt_demoEnd = fontcache.getFont("phoenixbios", 28)

    GlobalTouch:registerArea("demotap", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function EndDemoState:draw()
    love.graphics.printf(languageService["demo_end_text"], fnt_demoEnd, 0, love.graphics.getHeight() / 2 - 128, love.graphics.getWidth(), "center")
    if love.system.getOSType() == "desktop" then
        love.graphics.printf(languageService["demo_continue"], fnt_demoEnd, 0, love.graphics.getHeight() / 2 + 64, love.graphics.getWidth(), "center")
    else
        love.graphics.printf(languageService["demo_continue_touch"], fnt_demoEnd, 0, love.graphics.getHeight() / 2 + 64, love.graphics.getWidth(), "center")
    end
end

function EndDemoState:update(elapsed)
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        if GlobalTouch:isHit("demotap") then
            gamestate.switch(MenuState)
        end
    end
end

function EndDemoState:keypressed(k)
    gamestate.switch(MenuState)
end

return EndDemoState