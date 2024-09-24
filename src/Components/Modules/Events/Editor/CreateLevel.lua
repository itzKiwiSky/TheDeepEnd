return function(lvlname)
        local levelData = {
            meta = {
                title = "Level title",
                description = "Simple description",
                username = "username",
                gameversion = 0,
                requestedDifficulty = 0, -- int range 1 -> 5
                songID = "000000", -- used to download the song from newgrounds
                textures = {}
            },
            level = {
                startPos = {0, 0},
                endPos = {256, 0},
                bgID = 1,
                colorChannels = {
                    reserved = {
                        bg = {128, 128, 128},
                        objs = {255, 255, 255}
                    }
                },
                startGamemode = "cube",
                startSpeed = 2, -- range from 1 to 4
                startDirection = "right",
                startFlipped = false
            },
            objects = {},
            objectThird = {}
        }

end