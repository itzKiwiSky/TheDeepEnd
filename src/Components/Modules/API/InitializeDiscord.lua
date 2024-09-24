return function()
    local file = love.filesystem.getInfo("ApiStuff.json")
    if file then
        local data = json.decode(file ~= nil and love.filesystem.read("ApiStuff.json") or "{}")
        discordrpc.initialize(data.discord.appID, true)
        Presence.update()
    end
end