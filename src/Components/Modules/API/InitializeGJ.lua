return function()
    local file = love.filesystem.getInfo("src/ApiStuff.json")
    if file then
        local data = json.decode(file ~= nil and love.filesystem.read("src/ApiStuff.json") or "{}")
        gamejolt.init(data.gamejolt.gameID, data.gamejolt.gameKey)
        if gameslot.save.game.user.settings.gamejolt.username ~= "" and gameslot.save.game.user.settings.gamejolt.usertoken ~= "" then
            gamejolt.authUser(
                gameslot.save.game.user.settings.gamejolt.username,
                gameslot.save.game.user.settings.gamejolt.usertoken
            )
            gamejolt.openSession()
            io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Client connected (%s, %s){reset}\n", gamejolt.username, gamejolt.userToken))
        end
    end
end