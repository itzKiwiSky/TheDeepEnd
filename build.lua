return {
    name = "The Deep End",
    developer = "KiwiStationStudios",
    output = "./export",
    version = "0.0.1",
    love = "11.5",
    ignore = {
        "export", 
        "boot.cmd", 
        ".gitignore", 
        ".gitattribute", 
        ".commitid", 
        "icon_old.png", 
        "docs", 
        ".VSCodeCounter", 
        "project",
        "gjassets"
    },
    icon = "icon.png",
    
    identifier = "com.kiwistationstudios.thedeepend", 
    libs = { 
        windows = {
            "assets/bin/win/https.dll",
            "assets/bin/win/discord-rpc.dll"
        },
        linux = {
            "assets/bin/macos/https.so",
            "assets/bin/macos/discord-rpc.dylib"
        },
        macos = {
            "assets/bin/linux/https.so",
            "assets/bin/linux/discord-rpc.so"
        },
        all = {"LICENSE", "changelog.txt"}
    },
    platforms = {"windows", "linux", "macos"} 
}