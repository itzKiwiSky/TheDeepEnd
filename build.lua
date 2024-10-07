return {
    name = "The Deep End",
    developer = "KiwiStationStudios",
    output = "export",
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
        "project"},
    icon = "icon.png",
    
    identifier = "com.kiwistationstudios.thedeepend", 
    libs = { 
        windows = {"assets/bin/https.dll"},
        linux = {"assets/bin/https_linux.so"},
        macos = {"assets/bin/https_mac.so"},
        all = {"LICENSE", "ApiStuff.json"}
    },
    platforms = {"windows", "linux", "macos"} 
}