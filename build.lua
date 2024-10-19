return {
    name = "The Deep End",
    developer = "KiwiStationStudios",
    output = "./export",
    version = "0.0.2",
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
        "gjassets",
        "README.md",
        "icon.png"
    },
    icon = "icon.png",
    
    identifier = "com.kiwistationstudios.thedeepend", 
    libs = { 
        windows = {
            "assets/bin/win/https.dll",
            "assets/bin/win/discord-rpc.dll"
        },
        macos = {
            "assets/bin/macos/https.so",
            "assets/bin/macos/libdiscord-rpc.dylib"
        },
        linux = {
            "assets/bin/linux/https.so",
            "assets/bin/linux/libdiscord-rpc.so"
        },
        all = {"LICENSE", "CHANGELOG.md"}
    },
    platforms = {"windows", "linux", "macos"} 
}