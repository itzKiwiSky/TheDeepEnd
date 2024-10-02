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

local function _getObjectByType(this, type)
    for _, c in pairs(this.objects) do
        if c.type == type then
            return _, c
        end
    end
    return nil
end

function World:init(levelfile)
    local levelEnd = require 'src.Components.Modules.Game.Objects.EndHitbox'
    self.templates = {
        player = require 'src.Components.Modules.Game.Objects.Player',
        gamerfish = require 'src.Components.Modules.Game.Objects.Fish',
        geiser = require 'src.Components.Modules.Game.Objects.Geiser',
        pufferfish = require 'src.Components.Modules.Game.Objects.Pufferfish',
        block = require 'src.Components.Modules.Game.Objects.Block',
        pearl = require 'src.Components.Modules.Game.Objects.Pearl',
        bomb = require 'src.Components.Modules.Game.Objects.Bomb',
        explosion = require 'src.Components.Modules.Game.Objects.Explosion'
    }

    self.tiledfile = {}

    self.assets = {}
    self.assets.sheet, self.assets.quads = love.graphics.getQuads("assets/images/blocks_tileset")
    self.assets.endGradient = love.graphics.newGradient("vertical", {255, 255, 255, 255}, {255, 255, 255, 0})
    self.assets.endParticles = require 'src.Components.Modules.Game.Particles.EndParticles'
    self.assets.endParticles:setEmissionArea("uniform", love.graphics.getWidth(), 5, 0, false)

    self.tiles = {}
    self.batches = {}
    self.layer = {}
    self.objects = {}
    self.tilesObj = {}

    self.widthInTiles = 0
    self.heightInTiles = 0
    self.width = 0
    self.height = 0
    self.spawnX = 0
    self.spawnY = 0
end

function World:build(levelfilename)
    local levelEnd = require 'src.Components.Modules.Game.Objects.EndHitbox'
    self.tiledfile = love.filesystem.load(levelfilename)()

    self.widthInTiles = self.tiledfile.width
    self.heightInTiles = self.tiledfile.height
    self.width = self.tiledfile.width * 32
    self.height = self.tiledfile.height * 32

    self.assets.levelEnding = levelEnd(0, self.height + 64, self.width, 32, self.tiledfile.properties["next_phase"])

    lume.clear(self.objects)
    lume.clear(self.tilesObj)

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
                        if layer.name == "tilesfg" and not table.contains({5, 16, 17, 18, 19, 28, 29, 30, 31}, self.tiles[layer.name][y][x]) then
                            table.insert(self.tilesObj, self.templates.block((x - 1) * 32, (y - 1) * 32))
                        end
                    end
                end
            end
        else
            --layer.objects
            for _, o in pairs(layer.objects) do
                if o.name == "PlayerSpawn" then
                    self.spawnX, self.spawnY = o.x, o.y
                    self.templates.player:init(o.x, o.y)
                else
                    if self.templates[o.name] then
                        switch(o.name, {
                            ["gamerfish"] = function()
                                table.insert(self.objects, self.templates.gamerfish(o.x, o.y, o.properties.speed))
                            end,
                            ["geiser"] = function()
                                table.insert(self.objects, self.templates.geiser(o.x, o.y, o.properties.direction, o.properties.attackTime, o.properties.attackCooldown))
                            end,
                            ["pufferfish"] = function()
                                table.insert(self.objects, self.templates.pufferfish(o.x, o.y, o.properties.range))
                            end,
                            ["pearl"] = function()
                                table.insert(self.objects, self.templates.pearl(o.x, o.y, o.properties.points))
                            end,
                            ["bomb"] = function()
                                table.insert(self.objects, self.templates.bomb(o.x, o.y, o.height, o.properties.range))
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
    love.graphics.draw(self.assets.endParticles, 0, self.height)
    love.graphics.draw(self.assets.endGradient, 0, self.height, 0, self.width, -glowAnimValue)
    love.graphics.setBlendMode("alpha")

    love.graphics.draw(self.batches["tilesfg"])
    
    if registers.system.showDebugHitbox then
        for _, b in pairs(self.tilesObj) do
            love.graphics.setColor(1, 0, 0, 0.5)
                love.graphics.rectangle("fill", b.hitbox.x, b.hitbox.y, b.hitbox.w, b.hitbox.h)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

function World:update(elapsed)
    self.assets.endParticles:update(elapsed)
    self.templates.player:update(elapsed)
    for _, o in pairs(self.objects) do
        if o.update then
            o:update(elapsed)
        end

        if not registers.system.freemove then
            switch(o.type, {
                ["geiser"] = function()
                    if o.meta.hitbox then 
                        if collision.rectRect(self.templates.player.hitbox, o.hitbox) then
                            if not self.templates.player.isDamaged then
                                self.templates.player.HP = self.templates.player.HP - 1
                            end
                            self.templates.player.isDamaged = true
                        end
                    end
                end,
                ["pearl"] = function()
                    if collision.rectRect(self.templates.player.hitbox, o.hitbox) then
                        table.remove(self.objects, _)
                    end
                end,
                ["bomb"] = function()
                    if o.hitbox.type == "circle" then
                        if collision.circRect(o.hitbox, self.templates.player.hitbox) then
                            if not self.templates.player.isDamaged then
                                self.templates.player.HP = 0
                                table.remove(self.objects, _)
                                table.insert(self.objects, self.templates.explosion(o.x, o.y))
                            end
                            self.templates.player.isDamaged = true
                        end
                    end
                end,
                ["default"] = function()
                    if o.hitbox then
                        if collision.rectRect(self.templates.player.hitbox, o.hitbox) then
                            if not self.templates.player.isDamaged then
                                self.templates.player.HP = self.templates.player.HP - 1
                            end
                            self.templates.player.isDamaged = true
                        end
                    end
                end
            })
        end

        switch(o.type, {
            ["explosion"] = function()
                if o.lastFrame then
                    table.remove(self.objects, _)
                end
            end
        })
    end

    glowAnimValue = math.cos(math.sin(love.timer.getTime()) * 1.2) * 64
    
    if collision.rectRect(self.assets.levelEnding, self.templates.player.hitbox) then
        registers.user.levelEnded = true
    end
end

return World