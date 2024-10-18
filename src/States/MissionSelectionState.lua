MissionSelectionState = {}

function MissionSelectionState:enter()
    missionController = require 'src.Components.Modules.Game.Utils.MissionController'

    missionController.registerPack("The basics", false, {
        "assets/data/levels/thebasics/level1.lua",
        "assets/data/levels/thebasics/level2.lua",
        "assets/data/levels/thebasics/level3.lua",
        "assets/data/levels/thebasics/level4.lua",
        "assets/data/levels/thebasics/level5.lua",
    })

    Presence.largeImageKey = "map_select_rpc"
    Presence.largeImageText = "Selection mission"
    Presence.state = "Missions"
    Presence.details = "Selecting a mission"
    Presence.update()

    menuIcons_sheet, menuIcons_quads = love.graphics.getHashedQuads("assets/image/menuIcons")

    fnt_missionSelect = fontcache.getFont("phoenixbios", 26)
end

function MissionSelectionState:draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.printf(languageService["mission_select_title"], fnt_missionSelect, 0, 52, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(languageService["mission_select_title"], fnt_missionSelect, 0, 48, love.graphics.getWidth(), "center")
end

function MissionSelectionState:update(elapsed)

end

return MissionSelectionState