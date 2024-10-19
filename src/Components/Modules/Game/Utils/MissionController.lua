---@class MissionController
local MissionController = {
    packs = {}
}

--- Register a new mission package
---@param name string
---@param locked boolean
---@param maps table
---@return nil
function MissionController.registerPack(name, locked, mapFolder)
    local pack = {
        name = name,
        locked = locked or false,
        maps = {},
        difficultyAverage = 0,
    }
    -- check if folder exist --
    local folder = love.filesystem.getInfo("assets/data/levels/" .. mapFolder)
    assert(folder ~= nil, "[ERROR] : Invalid folder")
    local mapsPaths = love.filesystem.getDirectoryItems("assets/data/levels/" .. mapFolder)
    for f = 1, #mapsPaths, 1 do
        table.insert(pack.maps, "assets/data/levels/" .. mapFolder .. "/" .. mapsPaths[f])
    end

    -- calculate the average --
    local sum = 0
    for _, map in pairs(pack.maps) do
        local curMap = love.filesystem.load(map)()
        sum = sum + curMap.properties.difficulty
    end

    local average = #pack.maps > 0 and (sum / #pack.maps) or 0
    if math.floor(average) >= 10 then
        average = 10
    end
    pack.difficultyAverage = math.floor(average)
    table.insert(missionController.packs, pack)
end

return MissionController