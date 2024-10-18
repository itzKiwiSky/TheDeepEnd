---@class MissionController
local MissionController = {
    packs = {}
}

--- Register a new mission package
---@param name string
---@param locked boolean
---@param maps table
---@return nil
function MissionController.registerPack(name, locked, maps)
    local pack = {
        name = name,
        locked = locked or false,
        maps = maps or {},
        difficultyAverage = 0,
    }

    -- calculate the average --

    local sum = 0
    for _, map in pairs(pack.maps) do
        local curMap = love.filesystem.load(map)()
        sum = sum + curMap.properties.difficulty
    end

    local average = #pack.maps > 0 and (sum / #pack.maps) or 0
    pack.difficultyAverage = math.floor(average)
    table.insert(missionController.packs, pack)
end

return MissionController