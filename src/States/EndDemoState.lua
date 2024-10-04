EndDemoState = {}

function EndDemoState:enter()
    fnt_demoEnd = fontcache.getFont("phoenixbios", 28)
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

end

return EndDemoState