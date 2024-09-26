local World = {}

local function _convert2D(data, w, h)
    local tiledata = {}

    for y = 1, h, 1 do
        tiledata[y] = {}
        for x = 1, w, 1 do
            local i = (y - 1) * w + x
            tiledata[y][x] = data[i]
        end
    end

    return tiledata
end

local function printGrid(grid)
    for i = 1, #grid do
        for j = 1, #grid[i] do
            io.write(grid[i][j] .. " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

local function getObject(data, object)
    for _, o in pairs(data) do
        if o.name == object then
            return o
        end
    end
end

function World:init(levelfile)
    self.templates = {
        player = require 'src.Components.Modules.Game.Player',
        gamerfish = require 'src.Components.Modules.Game.Fish',
    }

    self.width = 0
    self.height = 0

    self.tiledfile = love.filesystem.load(levelfile)()

    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads("assets/images/blocks_tileset")

    self.tiles = {}
    self.batches = {}
    self.layer = {}
    self.objects = {}

    for _, layer in pairs(self.tiledfile.layers) do
        if layer.type == "tilelayer" then
            self.batches[layer.name] = love.graphics.newSpriteBatch(self.assets.sheet, nil, "static")
            self.layer[layer.name] = layer
            self.tiles[layer.name] = _convert2D(layer.data, self.tiledfile.width, self.tiledfile.height)
            for y = 1, self.tiledfile.height, 1 do
                for x = 1, self.tiledfile.width, 1 do
                    if self.tiles[layer.name][y][x] ~= 0 then
                        self.batches[layer.name]:add(self.assets.quads[self.tiles[layer.name][y][x]], (x - 1) * 32, (y - 1) * 32)
                    end
                end
            end
        else
            --ayer.objects
            for _, o in pairs(layer.objects) do
                if o.name == "PlayerSpawn" then
                    self.templates.player:init(o.x, o.y)
                else
                    if self.templates[o.name] then
                        table.insert(self.objects, self.templates[o.name](o.x, o.y, math.random(30, 50)))
                    end
                end
            end
        end
    end
end

function World:draw()
    local layer = self.layer
    love.graphics.setColor(layer["tilesbg"].properties.color, layer["tilesbg"].properties.color, layer["tilesbg"].properties.color, 1)
        love.graphics.draw(self.batches["tilesbg"])
    love.graphics.setColor(1, 1, 1, 1)

    self.templates.player:draw()
    for _, o in pairs(self.objects) do
        o:draw()
    end

    love.graphics.draw(self.batches["tilesfg"])
end

function World:update(elapsed)
    self.templates.player:update(elapsed)
    for _, o in pairs(self.objects) do
        o:update(elapsed)
    end
end

return World