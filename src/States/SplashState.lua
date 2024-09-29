SplashState = {}

function SplashState:enter()
    splashTimer = timer.new()
    transitionFade = {
        alpha = 1
    }
    logoSize = 0.3

    transitionIn = flux.to(transitionFade, 1.5, {alpha = 0})
    transitionIn:ease("sineinout")

    transitionOut = flux.to(transitionFade, 1.5, {alpha = 1})
    transitionOut:ease("sineinout")
    transitionOut:delay(3)
    transitionOut:oncomplete(function()
        gamestate.switch(MenuState)
    end)


    logo = love.graphics.newImage("assets/images/logoTransparent.png")
end

function SplashState:draw()
    love.graphics.draw(
        logo, 
        love.graphics.getWidth() / 2, 
        love.graphics.getHeight() / 2, 0, 
        logoSize, logoSize, 
        logo:getWidth() / 2, logo:getHeight() / 2
    )
    love.graphics.setColor(0, 0, 0, transitionFade.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function SplashState:update(elapsed)
    splashTimer:update(elapsed)
    logoSize = logoSize + 0.0003
    flux.update(elapsed)
end

return SplashState