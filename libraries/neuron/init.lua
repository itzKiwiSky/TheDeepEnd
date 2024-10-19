NeuronPath = ...

local utils = require(NeuronPath .. ".Utils")
local crypt = require(NeuronPath .. ".Crypt")

local Neuron = {}
Neuron.__index = Neuron

function Neuron.new(name)
    -- create dir if not exist --
    local slotDirectory = love.filesystem.getInfo("slots")
    if not slotDirectory then
        love.filesystem.createDirectory("slots")
    end
    local self = setmetatable({}, Neuron)
    self.save = {}
    self.name = name or love.filesystem.getIdentity():gsub("[%s%-%/]", "_")
    -- interface --
    self.allowBackup = true
    self.isDebugMode = false
    return self
end

function Neuron:initialize()
    -- check if slot exist, if exist load it, else create then load --
    local slotHashedName = love.data.encode("string", "hex", love.data.hash("sha1", self.name))
    local slotFile = love.filesystem.getInfo("slots/" .. slotHashedName .. ".neu")
    if slotFile then
        -- load save process --
        local slotData = love.filesystem.read("slots/" .. slotHashedName .. ".neu")
        local decryptedSlotData = crypt(slotData, slotHashedName)
        local sucess, data = pcall((load or loadstring)("return" .. decryptedSlotData))
        if not sucess then
            local slotBackupFile = love.filesystem.getInfo("slots/" .. slotHashedName .. ".backup.neu")
            if slotBackupFile then
                -- replace the old file --
                local backupData = love.filesystem.read("slots/" .. slotHashedName .. ".backup.neu")
                love.filesystem.remove("slots/" .. slotHashedName .. ".neu")
                love.filesystem.remove("slots/" .. slotHashedName .. ".backup.neu")

                if self.allowBackup then
                    local backupFileSlot = love.filesystem.newFile("slots/" .. slotHashedName .. ".backup.neu", "w")
                    -- serialize data --
                    local data = utils.serialize(self.save)
                    local encryptedData = crypt(data, slotHashedName)
                    backupFileSlot:write(encryptedData)
                    backupFileSlot:close()
                end

                local fileSlot = love.filesystem.newFile("slots/" .. slotHashedName .. ".neu", "w")
                -- serialize data --
                fileSlot:write(backupData)
                fileSlot:close()
            else
                if self.allowBackup then
                    local backupFileSlot = love.filesystem.newFile("slots/" .. slotHashedName .. ".backup.neu", "w")
                    -- serialize data --
                    local data = utils.serialize(self.save)
                    local encryptedData = crypt(data, slotHashedName)
                    backupFileSlot:write(encryptedData)
                    backupFileSlot:close()
                end

                local data = utils.serialize(self.save)
                local encryptedData = crypt(data, slotHashedName)
                love.filesystem.write("slots/" .. slotHashedName .. ".neu", encryptedData)
            end

            local slotData = love.filesystem.read("slots/" .. slotHashedName .. ".neu")
            local decryptedSlotData = crypt(slotData, slotHashedName)
            local sucess, data = pcall((load or loadstring)("return" .. decryptedSlotData))
            self.save = data
        end

        if self.isDebugMode then
            if utils.diffTable(self.save, data) then
                data = self.save
            end
        end

        self.save = data
    else
        if self.allowBackup then
            local backupFileSlot = love.filesystem.newFile("slots/" .. slotHashedName .. ".backup.neu", "w")
            -- serialize data --
            local data = utils.serialize(self.save)
            local encryptedData = crypt(data, slotHashedName)
            backupFileSlot:write(encryptedData)
            backupFileSlot:close()
        end
        local fileSlot = love.filesystem.newFile("slots/" .. slotHashedName .. ".neu", "w")
        -- serialize data --
        local data = utils.serialize(self.save)
        local encryptedData = crypt(data, slotHashedName)
        fileSlot:write(encryptedData)
        fileSlot:close()
    end
end

function Neuron:saveSlot()
    -- check if slot exist, if exist load it, else create then load --
    local slotHashedName = love.data.encode("string", "hex", love.data.hash("sha1", self.name))
    local slotFile = love.filesystem.getInfo("slots/" .. slotHashedName .. ".neu")
    if slotFile then
        if self.allowBackup then
            local data = utils.serialize(self.save)
            local encryptedData = crypt(data, slotHashedName)
            love.filesystem.write("slots/" .. slotHashedName .. ".neu", encryptedData)
        end
        local data = utils.serialize(self.save)
        local encryptedData = crypt(data, slotHashedName)
        love.filesystem.write("slots/" .. slotHashedName .. ".backup.neu", encryptedData)
    else
        local fileSlot = love.filesystem.newFile("slots/" .. slotHashedName .. ".neu", "w")
        -- serialize data --
        local data = utils.serialize(self.save)
        local encryptedData = crypt(data, slotHashedName)
        fileSlot:write(encryptedData)
        fileSlot:close()
    end
end

function Neuron:clear()
    self.save = utils.clear(self.save)
end

return Neuron