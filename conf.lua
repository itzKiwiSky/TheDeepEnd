local function getOS()
    if jit then
        if jit.os == "Windows" then
            return "Windows"
        elseif jit.os == "Linux" then
            return "Linux"
        elseif jit.os == "OSX" then
            return "OSX"
        elseif jit.os == "BSD" then
            return "BSD"
        elseif jit.os == "POSIX" then
            return "POSIX"
        end
    else
        return "Unknown"
    end
end

function love.conf(w)
    --% Window %--
    w.window.width          =       getOS() == "Android" and 1 or 640
    w.window.height         =       getOS() == "Android" and 2 or 800
    w.window.icon           =       "icon.png"
    w.window.title          =       "The lost deep"
    w.window.x              =       nil
    w.window.y              =       nil
    w.window.borderless     =       false
    w.window.resizable      =       false
    w.window.fullscreen     =       false
    w.window.depth          =       16
    --w.window.vsync          =       0

    --% Debug %--
    w.console               =       love.filesystem.isFused() and false or true

    --% Storage %--
    w.externalstorage       =       true
    w.identity              =       "com.kiwiworlddomination.thedeepend"

    --% Modules %--
    w.modules.audio         =       true
    w.modules.data          =       true
    w.modules.event         =       true
    w.modules.font          =       true
    w.modules.graphics      =       true
    w.modules.image         =       true
    w.modules.joystick      =       true
    w.modules.keyboard      =       true
    w.modules.math          =       true
    w.modules.mouse         =       true
    w.modules.physics       =       true
    w.modules.sound         =       true
    w.modules.system        =       true
    w.modules.thread        =       true
    w.modules.timer         =       true
    w.modules.touch         =       true
    w.modules.video         =       true
    w.modules.window        =       true
end