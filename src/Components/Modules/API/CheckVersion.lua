local VersionModule = {}

function VersionModule.check(url)
    assert(type(url) == "string", "[ERROR] : Invalid parameter type, expected 'string', got: " .. type(url))
    io.printf("{bgBrightWhite}{brightBlack}[SYSTEM]{reset} : Checking for updates...\n")
    local code, serverVersion = https.request(url)
    if code == 200 then
        if serverVersion ~= VERSION.ENGINE then
            io.printf("{bgBrightWhite}{brightBlack}[SYSTEM]{reset} : Need update game\n")
            return true
        else
            io.printf("{bgBrightWhite}{brightBlack}[SYSTEM]{reset} : You're currently running the most recent version of the game. Nice :3\n")
        end
    else
        io.printf("{bgBrightWhite}{brightBlack}[SYSTEM]{reset}{bgRed}{brightWhite}[ERROR]{reset} : Failed to check version\n")
        return false
    end
end

return VersionModule