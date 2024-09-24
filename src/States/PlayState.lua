PlayState = {}

function PlayState:init()
    player = require 'src.Components.Modules.Game.Player'
    player:setPos(nil, 100)
end

function PlayState:enter()
    
end

function PlayState:draw()
    player:draw()
end

function PlayState:update(elapsed)
    player:update(elapsed)
end

return PlayState