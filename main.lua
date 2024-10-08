love.filesystem.load("src/Components/Initialization/Run.lua")()
love.filesystem.load("src/Components/Initialization/ErrorHandler.lua")()

--AssetHandler = require("src.Components.Helpers.AssetManager")()
VERSION = {
    ENGINE = "0.0.1",
    FORMATS = "0.0.1",
    meta = {
        commitID = "",
        branch = "",
    }
}

function love.initialize(args)
    fontcache = require 'src.Components.Modules.System.FontCache'
    versionChecker = require 'src.Components.Modules.API.CheckVersion'
    Presence = require 'src.Components.Modules.API.Presence'
    GameColors = require 'src.Components.Modules.Utils.GameColors'
    LanguageController = require 'src.Components.Modules.System.LanguageManager'
    connectGJ = require 'src.Components.Modules.API.InitializeGJ'

    GlobalTouch = multouch.new(128)

    fontcache.init()

    lollipop.currentSave.game = {
        user = {
            settings = {
                shaders = true,
                language = "English",
                gamejolt = {
                    username = "",
                    usertoken = ""
                },
            },
            game = {
                totalPoints = 0,
            },
            achievments = {},
        }
    }

    lollipop.initializeSlot("dive")

    love.graphics.setDefaultFilter("nearest", "nearest")

    languageService = LanguageController(lollipop.currentSave.game.user.settings.language)

    registers = {
        user = {
            roundStarted = false,
            paused = false,
            levelEnded = false,
        },
        system = {
            showDebugHitbox = false,
            freemove = false,
            gameTime = 0,
        }
    }

    local gitStuff = require 'src.Components.Initialization.GitStuff'
    connectGJ()

    if not love.filesystem.isFused() then
        gitStuff.getAll()

        if love.filesystem.getInfo(".commitid") then
            local title = love.window.getTitle()
            love.window.setTitle(title .. " | " .. love.filesystem.read(".commitid"))
        end
    end

    local states = love.filesystem.getDirectoryItems("src/States")
    for s = 1, #states, 1 do
        require("src.States." .. states[s]:gsub(".lua", ""))
    end

    if not love.system.getOS() == "Android" or not love.system.getOS() == "iOS" then
        joysticks = love.joystick.getJoysticks()
    end

    local substates = love.filesystem.getDirectoryItems("src/SubStates")
    for s = 1, #substates, 1 do
        require("src.SubStates." .. substates[s]:gsub(".lua", ""))
    end

    love.filesystem.createDirectory("editor")
    love.filesystem.createDirectory("editor/levels")
    love.filesystem.createDirectory("screenshots")

    gamestate.registerEvents()
    gamestate.switch(SplashState)
end

function love.update(elapsed)
    if gamejolt.isLoggedIn then
        registers.system.gameTime = registers.system.gameTime + elapsed
        if math.floor(registers.system.gameTime) >= 20 then
            gamejolt.pingSession(true)
            registers.system.gameTime = 0
            io.printf(string.format("{bgGreen}{brightWhite}{bold}[Gamejolt]{reset}{brightWhite} : Client heartbeated a session (%s, %s){reset}\n", gamejolt.username, gamejolt.userToken))
        end
    end
end

function love.keypressed(k)
    if DEBUG_APP then
        if k == "f4" then
            registers.system.showDebugHitbox = not registers.system.showDebugHitbox
        end
        if k == "f5" then
            registers.system.freemove = not registers.system.freemove
        end
        if k == "f11" then
            love.graphics.captureScreenshot("screenshots/screen_" .. os.date("%Y-%m-%d %H-%M-%S") .. ".png")
        end
    end
end

function love.quit()
    if gamejolt.isLoggedIn then
        gamejolt.closeSession()
    end
end
