local lvlup = {}
lvlup.__index = lvlup

local utf8 = require 'utf8'

local function utf8Sub(s, i, j)
    i = utf8.offset(s, i)
    j = utf8.offset(s, j + 1) - 1
    return string.sub(s, i, j)
end

local function _updateChar(terminal, x, y, newChar)
    terminal.buffer[y][x] = newChar
    local charColor = terminal.cursorColor
    local charBackColor = terminal.cursorBackColor
    terminal.stateBuffer[y][x].color = {charColor[1], charColor[2], charColor[3], charColor[4]}
    terminal.stateBuffer[y][x].backcolor = {charBackColor[1], charBackColor[2], charBackColor[3], charBackColor[4]}
    terminal.stateBuffer[y][x].reversed = terminal.cursor_reversed
    terminal.stateBuffer[y][x].dirty = true
end

local function _wrapBottom()
    if self.cursorY >= self.height then
        self_roll_up(self, self.cursorY - self.height)
        self.cursorY = self.height
        self.dirty = true
    end
end

local function _updateScreen(terminal)
    local charColor = terminal.cursorColor
    local charBackColor = terminal.cursorBackColor
    terminal.dirty = true
    for _y = 1, terminal.height, 1 do
        for _x = 1, terminal.width, 1 do
            terminal.stateBuffer[_y][_x].color = charColor
            terminal.stateBuffer[_y][_x].backcolor = charBackColor
            terminal.stateBuffer[_y][_x].dirty = true
        end
    end
end

local function _new(width, height, font, customCharWidth, customCharHeight, useScheme)
    local self = setmetatable({}, lvlup)
    local charWidth = customCharWidth or font:getwidth('█')
    local charHeight = customCharHeight or font:getHeight()
    local numColumns = math.floor(width / charwidth)
    local numRows = math.floor(height / charHeight)

    self.useScheme = useScheme or false

    self.width = math.floor(numColumns)
    self.height = math.floor(numRows)
    self.font = font

    self.showCursor = true
    self.cursorX = 1
    self.cursorY = 1
    self.savedCursorX = 1
    self.savedCursorY = 1
    self.cursorColor = {1,1,1,1}
    self.cursorBackColor = {0,0,0,1}
    self.cursorReversed = false

    self.dirty = false
    self.char_width = charWidth
    self.char_height = charHeight

    self.speed = 800
    self.charCost = 1
    self.accumulator = 0
    self.stdin = {}

    self.clearColor = {0, 0, 0}

    self.canvas = love.graphics.newCanvas(width, height)
    self.buffer = {}
    self.stateBuffer = {}

    for i=1,numRows do
        local row = {}
        local state_row = {}
        for j=1,numColumns do
            row[j] = ' '
            state_row[j] = {
                color = {1,1,1,1},
                backcolor = {0,0,0,1},
                dirty = true
            }
        end
        self.buffer[i] = row
        self.stateBuffer[i] = state_row
    end

    self.schemes = {
        basic = basic_scheme
    }

    local previous_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(instance.canvas)
    love.graphics.clear(instance.clear_color)
    love.graphics.setCanvas(previous_canvas)
    return self
end

function lvlup:update(elapsed)
    self.dirty = true
    if #self.stdin == 0 then return end
    local frameBudget = self.speed * elapsed + self.accumulator
    local stdinIndex = 1
    while frameBudget > self.char_cost do
        local charcmd = self.stdin[stdinIndex]
        if charcmd == nil then break end
        stdinIndex = stdinIndex + 1
        frameBudget = frameBudget - self.char_cost

        if type(charcmd) == "string" then
            if charcmd == '\b' then
                self.cursorX = math.max(self.cursorX - 1, 1)
            elseif charcmd == '\n' then
                self.cursorX = 1
                self.cursorY = self.cursorY + 1
                self.wrapBottom()
                self.dirty = true
            else
                _updateChar(self, self.cursorX, self.cursorY, charcmd)
                self.cursorX = self.cursorX + 1
                if self.cursorX > self.width then
                    self.cursorX = 1
                    self.cursorY = self.cursorY + 1
                    _wrapBottom(self)
                end
                self.dirty = true
            end
        elseif charcmd.type == "clear" then
            local x,y,w,h = charcmd.x or 1, charcmd.y or 1, charcmd.w or self.width, charcmd.h or self.h
            for y=y,y+h-1 do
                for x=x,x+w-1 do
                    _updateChar(self, x, y, " ")
                    self.buffer[y][x] = " "
                end
            end
            self.dirty = true
        elseif charcmd.type == "hide_cursor" then
            self.show_cursor = false
        elseif charcmd.type == "show_cursor" then
            self.show_cursor = true
        elseif charcmd.type == "cursor_color" then
            self.cursor_color[1] =  charcmd.red
            self.cursor_color[2] = charcmd.blue
            self.cursor_color[3] = charcmd.green
            self.cursor_color[4] = charcmd.alpha
        elseif charcmd.type == "cursor_backcolor" then
            self.cursor_backcolor[1] =  charcmd.red
            self.cursor_backcolor[2] = charcmd.blue
            self.cursor_backcolor[3] = charcmd.green
            self.cursor_backcolor[4] = charcmd.alpha
        elseif charcmd.type == "move" then
            self.cursorX = charcmd.x
            self.cursorY = charcmd.y
        elseif charcmd.type == "reverse" then
            self.cursor_reversed = (charcmd.value ~= nil) and charcmd.value or not self.cursor_reversed
        elseif charcmd.type == "save" then
            self.saved_cursor_x = self.cursorX
            self.saved_cursor_y = self.cursorY
        elseif charcmd.type == "load" then
            self.cursorX = self.saved_cursor_x
            self.cursorY = self.saved_cursor_y
        elseif charcmd.type == "fill" then
            local x, y, w, h = charcmd.x, charcmd.y, charcmd.w, charcmd.h
            local style = charcmd.style
            local styles = {
                ["block"] = "█",
                ["semigrid"] = "▓",
                ["halfgrid"] = "▒",
                ["grid"] = "░"
            }

            local charStyle = styles[style]

            if not charStyle then
                assert(false, string.format("Unrecognized style %s", style))
            end

            for cy = y, y + h, 1 do
                for cx = x, x + w, 1 do
                    _updateChar(self, cx, cy, charStyle)
                end
            end
        elseif charcmd.type == "frame" then
            local styles = {
                ["line"] = "┌┐└┘─│",
                ["bold"] = "┏┓┗┛━┃",
                ["text"] = "++++-|",
                ["double"] = "╔╗╚╝═║",
                ["block"] = "██████"
            }

            local curStyle = styles[charcmd.style]
            if not curStyle then
                assert(false, string.format("Unrecognized style %s", charcmd.style))
            end

            local buffer = self.buffer
            local state_buffer = self.state_buffer
            local char_color = self.cursor_color
            local x,y,width,height = charcmd.x, charcmd.y, charcmd.w, charcmd.h

            local left, right = x, x+width - 1
            local top, bottom = y, y+height - 1
            _updateChar(self, left, top, utf8Sub(curStyle,1,1))
            _updateChar(self, right, top, utf8Sub(curStyle,2,2))
            _updateChar(self, left, bottom, utf8Sub(curStyle,3,3))
            _updateChar(self, right, bottom, utf8Sub(curStyle,4,4))


            local horizontal_char = utf8Sub(curStyle, 5, 5)
            local vertical_char = utf8Sub(curStyle, 6, 6)
            for i=left+1, right-1 do
                _updateChar(self, i, top, horizontal_char)
                _updateChar(self, i, bottom, horizontal_char)
            end
            for i=top+1, bottom-1 do
                _updateChar(self, left, i, vertical_char)
                _updateChar(self, right, i, vertical_char)
            end
        elseif charcmd.type == "frame_shadow" then
            local styles = {
                ["line"] = "┌┐└┘─│",
                ["bold"] = "┏┓┗┛━┃",
                ["text"] = "++++-|",
                ["double"] = "╔╗╚╝═║",
                ["block"] = "██████"
            }

            local curStyle = styles[charcmd.style]
            if not curStyle then
                assert(false, string.format("Unrecognized style %s", charcmd.style))
            end

            local buffer = self.buffer
            local state_buffer = self.state_buffer
            local char_color = self.cursor_color
            local x,y,width,height = charcmd.x, charcmd.y, charcmd.w, charcmd.h

            local left, right = x, x + (width - 1)
            local top, bottom = y, y + (height - 1)

            local horizontal_char = utf8Sub(curStyle, 5, 5)
            local vertical_char = utf8Sub(curStyle, 6, 6)

            local lg, sh = charcmd.light, charcmd.shadow
            local lastCursorColor = self.cursor_color

            --self_set_cursor_color(self, basic_scheme[lg])
            print(left, top)
            self.cursor_color = basic_scheme[lg]
            _updateChar(self, left, top, utf8Sub(curStyle, 1, 1))
            for i = left + 1, right - 1, 1 do
                _updateChar(self, i, top, horizontal_char)
            end
            for i = top + 1, bottom - 1, 1 do
                _updateChar(self, left, i, vertical_char)
            end
            _updateChar(self, left, bottom, utf8Sub(curStyle, 3, 3))


            --self_set_cursor_color(self, basic_scheme[sh])
            self.cursor_color = basic_scheme[sh]
            _updateChar(self, right, top, utf8Sub(curStyle, 2, 2))
            for i = left + 1, right - 1, 1 do
                _updateChar(self, i, bottom, horizontal_char)
            end
            for i = top + 1, bottom - 1, 1 do
                _updateChar(self, right, i, vertical_char)
            end
            _updateChar(self, right, bottom, utf8Sub(curStyle, 4, 4))

            self.cursor_color = lastCursorColor
        else
            assert(false, "Unrecognized command", charcmd.type)
        end
    end


    

    self.accumulator = frame_budget
    local rest = {}
    for i=stdin_index,#self.stdin do
        table.insert(rest, self.stdin[i])
    end
    self.stdin = rest
end

function lvlup:rollUp(count)
    for times = 1, count, 1 do
        local first_row = self.buffer[1]
        for y = 2,self.height, 1 do
            self.buffer[y - 1] = self.buffer[y]
        end
        self.buffer[self.height] = first_row
        for i = 1, self.width, 1 do
            first_row[i] = ' '
        end 
    end
    _updateScreen(self)
end

return setmetatable(lvlup, { __call = function(_, ...) return _new(...) end })