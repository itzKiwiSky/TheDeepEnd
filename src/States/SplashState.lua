SplashState = {}

function SplashState:enter()
    splashTimer = timer.new()

    kiwiLogo = love.graphics.newImage("assets/images/kiwi.png")
    whaleLogo = love.graphics.newImage("assets/images/whaleLove.png")
    whaleLogo:setFilter("linear", "linear")
    fnt_logoText = fontcache.getFont("phoenixbios", 25)
    fnt_loveLogo = fontcache.getFont("phoenixbios", 18)

    snd_logosnd = love.audio.newSource("assets/sounds/logoSplash.ogg", "static")

    kiwiLogoPos = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
    }
    textProps = {
        alpha = 0,
        y = love.graphics.getHeight() / 2
    }

    logoPowered = {
        alpha = 0,
        y = love.graphics.getHeight(),
    }

    fadeConfig = {
        alpha = 1
    }

    logoMoveTween = flux.group()
    logoTextMoveTween = flux.group()
    fadeTween = flux.group()
    loveLogoTween = flux.group()

    fadeTween:to(fadeConfig, 0.4, { alpha = 0 }):ease("sineinout")

    splashTimer:script(function(sleep)
        sleep(1)
            fadeTween:to(fadeConfig, 0.25, { alpha = 0 }):ease("sineinout")
        sleep(1)
            logoMoveTween:to(kiwiLogoPos, 0.5, { y = kiwiLogoPos.y - 50 }):ease("sineinout")
            logoTextMoveTween:to(textProps, 0.5, { y = textProps.y + 50, alpha = 1 }):ease("sineinout")
        sleep(1)
            snd_logosnd:play()
        sleep(1.2)
            loveLogoTween:to(logoPowered, 0.7, { alpha = 1, y = love.graphics.getHeight() - 200 }):ease("backinout")
        sleep(1.5)
            fadeTween:to(fadeConfig, 0.8, { alpha = 1 }):ease("sineinout"):oncomplete(function()
                gamestate.switch(MenuState)
            end)
    end)

end

function SplashState:draw()
    love.graphics.draw(kiwiLogo, kiwiLogoPos.x, kiwiLogoPos.y, 0, 0.4, 0.4, kiwiLogo:getWidth() / 2, kiwiLogo:getHeight() / 2)

    love.graphics.setColor(1, 1, 1, textProps.alpha)
        love.graphics.printf("KiwiStation\nStudios", fnt_logoText, 0, textProps.y, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, logoPowered.alpha)
        love.graphics.draw(whaleLogo, love.graphics.getWidth() / 2, logoPowered.y, 0, 0.4, 0.4, whaleLogo:getWidth() / 2, whaleLogo:getHeight() / 2)
        love.graphics.printf("Powered with LÖVE", fnt_loveLogo, 0, logoPowered.y + 64, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)  

    love.graphics.setColor(0, 0, 0, fadeConfig.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function SplashState:update(elapsed)
    splashTimer:update(elapsed)

    logoMoveTween:update(elapsed)
    logoTextMoveTween:update(elapsed)

    fadeTween:update(elapsed)
    loveLogoTween:update(elapsed)
end

return SplashState