MenuState = {}

function MenuState:enter()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'
    btn = buttonPatch("assets/images/patchButton", "sexo", 90, 90, 256, 128)
end

function MenuState:draw()
    btn:draw()
end

function MenuState:update(elapsed)
    
end

return MenuState