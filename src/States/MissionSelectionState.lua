MissionSelectionState = {}

function MissionSelectionState:enter()
    Presence.largeImageKey = "map_select_rpc"
    Presence.largeImageText = "Selection mission"
    Presence.state = "Missions"
    Presence.details = "Selecting a mission"
    Presence.update()
end

function MissionSelectionState:draw()

end

function MissionSelectionState:update(elapsed)

end

return MissionSelectionState