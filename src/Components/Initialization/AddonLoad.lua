return function()
    --% Load addons %--
    local addons = love.filesystem.getDirectoryItems("src/Addons")
    for a = 1, #addons, 1 do
        require("src.Addons." .. addons[a]:gsub(".lua", ""))
    end
end