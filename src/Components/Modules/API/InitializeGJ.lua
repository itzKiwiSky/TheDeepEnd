return function()
    local file = love.filesystem.getInfo("ApiStuff.json")
    if file then
        local data = json.decode(file ~= nil and love.filesystem.read("ApiStuff.json") or "{}")
        gamejolt.init(data.gamejolt.gameID, data.gamejolt.gameKey)
        if lollipop.currentSave.game.user.settings.misc.gamejolt.username ~= "" and lollipop.currentSave.game.user.settings.misc.gamejolt.usertoken ~= "" then
            gamejolt.authUser(
                lollipop.currentSave.game.user.settings.misc.gamejolt.username,
                lollipop.currentSave.game.user.settings.misc.gamejolt.usertoken
            )
            gamejolt.openSession()
            registers.user.player.gamejoltConnected = true
            io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Client connected (%s, %s){reset}\n", gamejolt.username, gamejolt.userToken))
        end
    end
end