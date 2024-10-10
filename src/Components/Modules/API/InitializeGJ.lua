return function()
    local file = love.filesystem.getInfo("src/ApiStuff.json")
    if file then
        local data = json.decode(file ~= nil and love.filesystem.read("src/ApiStuff.json") or "{}")
        gamejolt.init(data.gamejolt.gameID, data.gamejolt.gameKey)
        if lollipop.currentSave.game.user.settings.gamejolt.username ~= "" and lollipop.currentSave.game.user.settings.gamejolt.usertoken ~= "" then
            gamejolt.authUser(
                lollipop.currentSave.game.user.settings.gamejolt.username,
                lollipop.currentSave.game.user.settings.gamejolt.usertoken
            )
            gamejolt.openSession()
            io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Client connected (%s, %s){reset}\n", gamejolt.username, gamejolt.userToken))
        end
    end
end