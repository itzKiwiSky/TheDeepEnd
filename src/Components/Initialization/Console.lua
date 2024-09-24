local Console = {}
Console.__index = Console

local function _triggerCommand(self, _command)
    local tokens = string.split(_command, " ")
    local command = tokens[1]
    table.remove(tokens, 1)
    if self.commands[command] then
        self.commands[command](unpack(tokens))
    end
end

local function _new(...)
    local self = setmetatable({}, Console)
    self.slabInstance = require 'libraries.slab'
    self.active = false
    self.input = ""
    self.output = {}
    self.commands = {}

    if self.slabInstance then
        self.slabInstance.SetINIStatePath(nil)
        self.slabInstance.Initialize({"NoDocks"})
    end

    return self
end

function Console:trace(_text)
    table.insert(self.output, _text)
end

function Console:newCommand(_command, _function)
    self.commands[_command] = _function
end

function Console:draw()
    if self.slabInstance then
        if self.active then
            self.slabInstance.Draw()
        end
    end
end

function Console:updateInterface(elapsed)
    if self.slabInstance then
        if self.active then
            self.slabInstance.Update(elapsed)

            self.slabInstance.BeginWindow("ConsoleWindow", {Title = "Console", AllowResize = false})
                self.slabInstance.Input("ConsoleWindowOutputMultiline", {MultiLine = true, ReadOnly = true, Text = table.concat(self.output, "\n"), W = love.graphics.getWidth() / 2 + 48, H = love.graphics.getHeight() / 2})
                if self.slabInstance.Input("ConsoleWindowInput", {Text = self.input, W = love.graphics.getWidth() / 2, H = 24}) then
                    self.input = self.slabInstance.GetInputText()
                end
                self.slabInstance.SameLine()
                if self.slabInstance.Button("OK", {W = 48, H = 24}) then
                    table.insert(self.output, "> " .. self.input)
                    _triggerCommand(self, self.input)
                    self.input = ""
                end
            self.slabInstance.EndWindow()
        end
    end
end

return setmetatable(Console, { __call = function(_, ...) return _new(...) end })