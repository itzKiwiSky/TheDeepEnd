CreditsState = {}

function CreditsState:init()
    formatText = require 'src.Components.Modules.Utils.FormatText'

    snd_lightLoop = love.audio.newSource("assets/sounds/lights.ogg", "static")

    fnt_creditsFont = fontcache.getFont("phoenixbios", 20)

    BGParticles = require 'src.Components.Modules.Game.Particles.BGParticles'

    logoGame = love.graphics.newImage("assets/images/logogame.png")

    effect = moonshine(moonshine.effects.vignette)
    effect.vignette.radius = 1.4

    GlobalTouch:registerArea("backButton", 20, love.graphics.getHeight() - 96, 96, 32)
end

function CreditsState:enter()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'

    if not snd_lightLoop:isPlaying() then
        snd_lightLoop:play()
        snd_lightLoop:setLooping(true)
        snd_lightLoop:setVolume(0.7)
    end

    creditsText = {
        {0.87, 0.87, 0.87},
        "Created by KiwiStation\n\n\n",
        {1, 190 / 255, 67 / 255},
        "Help with\n\nYosho - Beta tester\nRetrokid - Music\n\n\n",
        {0.87, 0.87, 0.87},
        "Attribuitions\n\nLights (credits menu) - Tsorthan Grove [OpenGameArt]\nAmdre Young\n\n\n",
        {0.6, 0, 0},
        "Dedications\nYosho - Cool helper\nRetrokid - bro makes sick music\nThzao <3\nAmdre young\nand\nYou! :3"
    }

    backButton = buttonPatch("assets/images/patchButton", languageService["credits_buttons_back"], 20, love.graphics.getHeight() - 96, 96, 32)
    backButton.font = fontcache.getFont("phoenixbios", 18)
end

function CreditsState:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(creditsText, fnt_creditsFont, 10, 30, love.graphics.getWidth() - 20, "center")

    backButton:draw()
end

function CreditsState:update(elapsed)
    if GlobalTouch:isHit("backButton") then
        snd_lightLoop:stop()
        snd_ambientSound:seek(0)
        gamestate.switch(MenuState)
    end
end

function CreditsState:mousepressed(x, y, button)
    if backButton:clicked() then
        snd_lightLoop:stop()
        snd_ambientSound:seek(0)
        gamestate.switch(MenuState)
    end
end

return CreditsState