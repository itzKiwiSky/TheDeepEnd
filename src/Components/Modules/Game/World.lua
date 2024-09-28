local World = {}
local glowAnimValue = 0

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
    local levelEnd = require 'src.Components.Modules.Game.Objects.EndHitbox'
    self.templates = {
        player = require 'src.Components.Modules.Game.Objects.Player',
        gamerfish = require 'src.Components.Modules.Game.Objects.Fish',
        geiser = require 'src.Components.Modules.Game.Objects.Geiser'
    }

    self.tiledfile = {}

    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads("assets/images/blocks_tileset")
    self.assets.endGradient = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {255, 255, 255, 0})

    self.tiles = {}
    self.batches = {}
    self.layer = {}
    self.objects = {}

    self.widthInTiles = 0
    self.heightInTiles = 0
    self.width = 0
    self.height = 0

    --self.assets.levelEnding = levelEnd(0, self.height - 32, self.width, 32, self.tiledfile.properties["next_phase"])

end

function World:addLayer(scale, color)
    table.insert(self.pseudoLayers, {
        scale = scale,
        color = color,
    })
    table.sort(self.pseudoLayers, function(a, b) return a.scale < b.scale end)
end

function World:build(levelfilename)
    local levelEnd = require 'src.Components.Modules.Game.Objects.EndHitbox'
    self.tiledfile = love.filesystem.load(levelfilename)()

    self.widthInTiles = self.tiledfile.width
    self.heightInTiles = self.tiledfile.height
    self.width = self.tiledfile.width * 32
    self.height = self.tiledfile.height * 32

    self.assets.levelEnding = levelEnd(0, self.height + 64, self.width, 32, self.tiledfile.properties["next_phase"])

    for _, layer in pairs(self.tiledfile.layers) do
        if layer.type == "tilelayer" then
            self.batches[layer.name] = love.graphics.newSpriteBatch(self.assets.sheet, nil, "static")
            self.batches[layer.name]:clear()
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
            --layer.objects
            for _, o in pairs(layer.objects) do
                if o.name == "PlayerSpawn" then
                    self.templates.player:init(o.x, o.y)
                else
                    if self.templates[o.name] then
                        switch(o.name, {
                            ["gamerfish"] = function()
                                table.insert(self.objects, self.templates.gamerfish(o.x, o.y, o.properties.speed))
                            end,
                            ["geiser"] = function()
                                table.insert(self.objects, self.templates.geiser(o.x, o.y, o.properties.direction, o.properties.attackTime, o.properties.attackCooldown))
                            end
                        })
                    end
                end
            end
        end
    end
end

function World:draw()
    local layer = self.layer

    local bgColor = layer["tilesbg"].properties.color
    love.graphics.setColor(bgColor, bgColor, bgColor, 1)
        love.graphics.draw(self.batches["tilesbg"])
    love.graphics.setColor(1, 1, 1, 1)

    self.templates.player:draw()
    for _, o in pairs(self.objects) do
        if o.draw then
            o:draw()
        end
    end

    love.graphics.setBlendMode("add")
    love.graphics.draw(self.assets.endGradient, 0, self.height, 0, self.width, -glowAnimValue)
    love.graphics.setBlendMode("alpha")

    love.graphics.draw(self.batches["tilesfg"])
    
end

function World:update(elapsed)
    self.templates.player:update(elapsed)
    for _, o in pairs(self.objects) do
        if o.update then
            o:update(elapsed)
        end
        if o.meta then
            if o.meta.state == "attack" then 
                if collision.rectRect(self.templates.player.hitbox, o.hitbox) then
                    if not self.templates.player.isDamaged then
                        self.templates.player.HP = self.templates.player.HP - 1
                    end
                    self.templates.player.isDamaged = true
                end
            end
        else
            if collision.rectRect(self.templates.player.hitbox, o.hitbox) then
                if not self.templates.player.isDamaged then
                    self.templates.player.HP = self.templates.player.HP - 1
                end
                self.templates.player.isDamaged = true
            end
        end
    end
    glowAnimValue = math.cos(math.sin(love.timer.getTime()) * 1.2) * 64
    
    if collision.rectRect(self.assets.levelEnding, self.templates.player.hitbox) then
        registers.user.levelEnded = true
    end
end

return World