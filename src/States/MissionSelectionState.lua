MissionSelectionState = {}

function MissionSelectionState:init()
    buttonPatch = require 'src.Components.Modules.Game.Utils.PatchButton'
    patchPanel = require 'src.Components.Modules.Game.Utils.patchPanel'
    missionController = require 'src.Components.Modules.Game.Utils.MissionController'

    missionPanel = patchPanel("assets/images/framestyles/frameStyle_oldschool", 32, 256, love.graphics.getWidth() - 96, 384)
    
    lume.clear(missionController.packs)

    -- debug only --
    --[[
    for i = 1, 20, 1 do
        missionController.registerPack("The basics" .. i, false, "the_basics")
    end
    ]]--

    local levelpacks = love.filesystem.getDirectoryItems("assets/data/levels")
    for lv = 1, #levelpacks, 1 do
        local lvltype = love.filesystem.getInfo("assets/data/levels/" .. levelpacks[lv]).type
        if lvltype == "directory" then
            local lvlpackdata = json.decode(tostring(love.filesystem.read("assets/data/levels/" .. levelpacks[lv] .. "/pack.json")))
            missionController.registerPack(lvlpackdata.name, false, lvlpackdata.color,levelpacks[lv])
        end
    end

    menuIcons_sheet, menuIcons_quads = love.graphics.getHashedQuads("assets/images/menu/menuIcons")
    fnt_missionSelect = fontcache.getFont("phoenixbios", 26)

    listCam = camera()
    listCamScroll = love.graphics.getHeight() / 2
    listCamY = love.graphics.getHeight() / 2

    missionDetailsCam = camera(nil, love.graphics.getHeight() * 2)
    missionDetailsFade = 0
    doFade = false
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
                "assets/images/framestyles/frameStyle_dash", m.name, 20, 
                128 * _ * 1.1, -- <---- between the numbers, his name is joe --
                love.graphics.getWidth() - 76, 96
            ),
            locked = m.locked,
            color = m.color,
        })
    end

    checkingPack = false
    currentPack = nil
    canClickOnButtonsList = true
    canClickOnButtonsPanel = false
    isHoldingClick = false

    closeMissionPanelButton = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", languageService["mission_panel_button_back"], 128, 540, 128, 48, 20)
    playMissionPanelButton = buttonPatch("assets/images/framestyles/frameStyle_linesmooth", languageService["mission_panel_button_play"], 360, 540, 128, 48, 20)
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
            love.graphics.setColor(e.color)
            e.btn:draw()
            love.graphics.setColor(1, 1, 1, 1)
            if e.btn:hover() and not doFade then
                love.graphics.setColor(0, 0, 0, 0.4)
            else
                love.graphics.setColor(0, 0, 0, 0)
            end
            if e.locked then
                love.graphics.setColor(0, 0, 0, 0.7)
            end
            love.graphics.rectangle("fill", e.btn.x, e.btn.y, e.btn.w + 32, e.btn.h + 32)
            love.graphics.setColor(1, 1, 1, 1)
        end
    listCam:detach()
    love.graphics.setStencilTest()

    love.graphics.setColor(0, 0, 0, missionDetailsFade)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    missionDetailsCam:attach()
        missionPanel:draw()
        if currentPack ~= nil then
            love.graphics.printf(currentPack.name, fnt_missionSelect, 32, 296, love.graphics.getWidth() - 64, "center")
            love.graphics.printf(languageService["mission_panel_difficulty"], fnt_missionSelect, 32, 356, love.graphics.getWidth() - 64, "center")
            for s = 1, 5, 1 do
                local sx = 96 * s
                if s <= math.floor(currentPack.difficultyAverage / 2) then
                    love.graphics.draw(menuIcons_sheet, menuIcons_quads["star_rate"], sx, 420, 0, 0.08, 0.08)
                elseif s == math.floor(currentPack.difficultyAverage / 2) and currentPack.difficultyAverage % 2 then
                    love.graphics.draw(menuIcons_sheet, menuIcons_quads["star_rate_half"], sx, 420, 0, 0.08, 0.08)
                else
                    love.graphics.draw(menuIcons_sheet, menuIcons_quads["star_rate_hole"], sx, 420, 0, 0.08, 0.08)
                end
            end
        end
        if closeMissionPanelButton:hover() then
            love.graphics.setColor(0.7, 0.7, 0.7, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        closeMissionPanelButton:draw()
        love.graphics.setColor(1, 1, 1, 1)

        if playMissionPanelButton:hover()then
            love.graphics.setColor(0.7, 0.7, 0.7, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        playMissionPanelButton:draw()
        love.graphics.setColor(1, 1, 1, 1)
    missionDetailsCam:detach()
end

function MissionSelectionState:update(elapsed)
    closeMissionPanelButton.mx, closeMissionPanelButton.my = missionDetailsCam:mousePosition()
    playMissionPanelButton.mx, playMissionPanelButton.my = missionDetailsCam:mousePosition()
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
    if doFade then
        missionDetailsFade = math.lerp(missionDetailsFade, 0.7, 0.08)
    else
        missionDetailsFade = math.lerp(missionDetailsFade, 0, 0.08)
    end
    flux.update(elapsed)
end

function MissionSelectionState:mousepressed(x, y, button)
    if canClickOnButtonsList then
        for _, e in ipairs(packButtonList) do
            if e.btn:clicked() then
                local checkPanelTween = flux.to(missionDetailsCam, 2, {y = love.graphics.getHeight() / 2})
                checkPanelTween:ease("backout")
                checkPanelTween:onstart(function()
                    doFade = true
                    canClickOnButtonsList = false
                    currentPack = missionController.packs[_]
                end)
                checkPanelTween:oncomplete(function()
                    checkingPack = true
                    canClickOnButtonsPanel = true
                end)
            end
        end
    elseif canClickOnButtonsPanel then
        if closeMissionPanelButton:clicked() then
            local closePanelTween = flux.to(missionDetailsCam, 2, {y = love.graphics.getHeight() * 2})
            closePanelTween:ease("backin")
            closePanelTween:onstart(function()
                doFade = false
                canClickOnButtonsPanel = false
            end)
            closePanelTween:oncomplete(function()
                currentPack = nil
                checkingPack = false
                canClickOnButtonsList = true
            end)
        end
    end
end

function MissionSelectionState:wheelmoved(x, y)
    if canClickOnButtonsList then
        if y < 0 then
            listCamScroll = listCamScroll + 64
        end
        if y > 0 then
            listCamScroll = listCamScroll - 64
        end
    end
end

return MissionSelectionState