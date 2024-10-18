MissionSelectionState = {}

function MissionSelectionState:init()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'
    missionController = require 'src.Components.Modules.Game.Utils.MissionController'
    
    lume.clear(missionController.packs)

    for i = 1, 20, 1 do
        missionController.registerPack("The basics" .. i, false, {
            "assets/data/levels/the_basics/level1.lua",
            "assets/data/levels/the_basics/level2.lua",
            "assets/data/levels/the_basics/level3.lua",
            "assets/data/levels/the_basics/level4.lua",
            "assets/data/levels/the_basics/level5.lua",
        })
    end

    menuIcons_sheet, menuIcons_quads = love.graphics.getHashedQuads("assets/images/menuIcons")
    fnt_missionSelect = fontcache.getFont("phoenixbios", 26)

    listCam = camera()
    listCamScroll = love.graphics.getHeight() / 2
    listCamY = love.graphics.getHeight() / 2
end

function MissionSelectionState:enter()
    Presence.largeImageKey = "map_select_rpc"
    Presence.largeImageText = "Selection mission"
    Presence.state = "Missions"
    Presence.details = "Selecting a mission"
    Presence.update()

    packButtonList = {}
    lume.clear(packButtonList)

    for _, m in ipairs(missionController.packs) do
        table.insert(packButtonList, {
            btn = buttonPatch(
                "assets/images/patchButton", m.name, 20, 
                128 * _, 
                love.graphics.getWidth() - 76, 96
            ),
            locked = m.locked,
        })
    end

    checkingPack = false
end

function MissionSelectionState:draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.printf(languageService["mission_select_title"], fnt_missionSelect, 0, 52, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(languageService["mission_select_title"], fnt_missionSelect, 0, 48, love.graphics.getWidth(), "center")

    love.graphics.stencil(function()
        love.graphics.rectangle("fill", 10, 118, love.graphics.getWidth() - 20, love.graphics.getHeight() - 150, 5)
    end, "replace", 1)

    love.graphics.rectangle("line", 10, 118, love.graphics.getWidth() - 20, love.graphics.getHeight() - 150, 5) 
    love.graphics.setStencilTest("greater", 0)
    listCam:attach()
    for _, e in ipairs(packButtonList) do
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
    listCam:detach()
    love.graphics.setStencilTest()

end

function MissionSelectionState:update(elapsed)
    listCamY = listCamY - (listCamY - listCamScroll) * 0.05
    listCam.y = listCamY

    if listCamScroll <= love.graphics.getHeight() / 2 then
        listCamScroll = love.graphics.getHeight() / 2
    end
    if listCamScroll >= packButtonList[#packButtonList].btn.y - 214 then
        listCamScroll = packButtonList[#packButtonList].btn.y - 214
    end

    for _, e in ipairs(packButtonList) do
        e.btn.mx, e.btn.my = listCam:mousePosition()
    end

    --listCam.y = math.lerp(listCam.y, listCamScroll, 0.05)
end

function MissionSelectionState:wheelmoved(x, y)
    if y < 0 then
        listCamScroll = listCamScroll + 16
    end
    if y > 0 then
        listCamScroll = listCamScroll - 16
    end
end

return MissionSelectionState