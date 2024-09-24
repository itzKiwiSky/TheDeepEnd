--[[]]--

--&private&--
local touches = {
    _VERSION = "v0.0.7",
    _AUTHOR = "Ayano the foxy",
    _URL = "",
    _TYPE = "module",
    _NAME = "touches"
} --module
touches.__index = touches --instance

local function math_distance2(_x1, _y1, _x2, _y2)
    return ((_x2 - _x1)*(_x2 - _x1) + (_y2 - _y1)*(_y2 - _y1))^0.5
end

local function math_clamp(_low, _n, _high)
    return math.min(math.max(_low, _n), _high)
end

local function collision_pointRectangle(_point, _rectangle)
    return _point.x <= _rectangle.x + _rectangle.w and
    _point.y <= _rectangle.y + _rectangle.h and 
    _point.x >= _rectangle.x and 
    _point.y >= _rectangle.y
end

--&public&--
--&low level&--
function touches.new(_limitOfTouches) --constructor
    assert(type(_limitOfTouches) ~= "number", "bad argument to #1 in touches.new function (number expected got " .. type(_limitOfTouches) .. ")")
    return setmetatable({
        touches = {},
        areas = {},
        lastDist = 0,
        count = 0,
        limitOfTouches = _limitOfTouches
    }, touches)
end

--%area and hitbox%--
function touches:setHitBox(_xPosition, _yPosition, _width, _height)
    for i, touch in ipairs(love.touch.getTouches()) do
        local touchX, touchY = love.touch.getPosition(touch)
        if collision_pointRectangle({x = touchX, y = touchY}, {x = _xPosition, y = _yPosition, w = _width, h = _height}) then
            return true, self:getTouch(touch)
        end
    end
end

function touches:registerArea(_id, _x, _y, _w, _h)
    table.insert(self.areas, {
        id = _id,
        x = _x,
        y = _y,
        w = _w,
        h = _h
    })
    return self:setHitBox(_x, _y, _w, _h)
end

--#id is a string
function touches:isHit(_id)
    for _, area in ipairs(self.areas) do
        if area.id == _id then
            return self:setHitBox(_x, _y, _w, _h)
        end
    end
end

--#_id is a string
function touches:getTouchesInArea(_id)
    local touches = {}
    for _, area in ipairs(self.areas) do
        if area.id == _id then
            isclicked, touch = self:setHitBox(_x, _y, _w, _h)
            table.insert(touches, touch)
        end
    end
    return touches
end

--%touches%--
function touches:getTouches()
    return self.touches
end

function touches:getNumberOfActivesTouches()
    return #self.touches
end

--#_id is a data type or a number
function touches:getTouch(_id)
    for i, touch in ipairs(self.touches) do
        if i == _id or touch.id == _id then 
            return i, touch
        end
    end
end

--%count%--
function touches:resetCount()
    self.count = 0
end

function touches:getTimesTouched()
    return self.count
end

--#_id is a data type or a number
function touches:update(_id)
    local i, touch = self:getTouch(_id)
    local lastX, lastY = love.touch.getPosition(touch.id)
    self.touches[i].id = touch.id
    for m, moved in ipairs(touch.move) do
        self.touches[i].dx = (touch.dx or 0) + (moved.x - lastX)
        self.touches[i].dy = (touch.dy or 0) + (moved.y - lastY)
        lastX = moved.x
        lastY = moved.y
        self.touches[i].move[m] = nil
    end
    self.touches[i].x = lastX
    self.touches[i].y = lastY
    self.touches[i].pressure = love.touch.getPressure(touch.id)
    return self.touches[i].id, self.touches[i].x, self.touches[i].y, self.touches[i].dx, self.touches[i].dy, self.touches[i].pressure --it forces touch update
end

--&high level&--
--_sheet and _quad are datatypes
function touches:draw(_sheet, _quad, ...)
    local x, y, sx, sy, ox, oy, kx, ky = ...
    if type(quad) == "datatype" then
        x, y, sx, sy, ox, oy, kx, ky = _quad, ...
    end
    for _, touch in ipairs(self.touches) do
        if type(quad) == "datatype" then
            love.graphics.draw(_sheet, _quad, touch.x + x, touch.y + y, r, sx, sy, ox, oy, kx, ky)
            return
        end
        love.graphics.draw(_sheet, touch.x + x, touch.y + y, r, sx, sy, ox or _sheet:getWidth() / 2, oy or _sheet:getHeight() / 2, kx, ky)
    end
end

function touches:display()
    local font = love.graphics.getFont()
    local r, g, b, a = love.graphics.getColor()
    for _, touch in ipairs(self.touches) do
        love.graphics.setColor(1, 1, 1, 0.75)
            love.graphics.print("id: " .. _ .. " / x: " .. touch.x .. " / y: " .. touch.y .. " / dx: " .. touch.dx .. " / dy: " .. touch.dy .. " / pressure: " .. touch.pressure, 0, (_ - 1) * font:getHeight(" "))
            love.graphics.circle("fill", touch.x , touch.y, 32)
        love.graphics.setColor(0, 0, 0, 0.75)
            love.graphics.print(_, touch.x, touch.y, 0, 16 / font:getWidth(_), 16 / font:getHeight(" "), font:getWidth(_) / 2, font:getHeight(" ") / 2)
        love.graphics.setColor(r, g, b, a)
    end
end

function touches:swipe(_callback1, _callback2, _callback3, _callback4, _callback5)
    if #self.touches > 0 then
        local touch = self.touches[1]
        local id, x, y, dx, dy, pressure = self:update(touch.id)
        if dx > 0 and math.abs(dx) > math.abs(dy) then
            if _callback1 then
                return _callback1(id, x, y, dx, dy, pressure)
            end
            return "right"
        elseif dy > 0 and math.abs(dx) < math.abs(dy) then
            if _callback2 then
                return _callback2(id, x, y, dx, dy, pressure)
            end
            return "down"
        elseif dx < 0 and math.abs(dx) > math.abs(dy) then
            if _callback3 then
                return _callback3(id, x, y, dx, dy, pressure) 
            end
            return "left"
        elseif dy < 0 and math.abs(dx) < math.abs(dy) then
            if _callback4 then
                return _callback4(id, x, y, dx, dy, pressure)
            end
            return "up"
        end
    end
    if _callback5 then
        return _callback5(id, x, y, dx, dy, pressure)
    end
    return "none"
end

function touches:pinch(_low, _n, _high)
    local r = _n
    if #self.touches >= 2 then
        local touchesDist = math_distance2(self.touches[1].x, self.touches[1].y, self.touches[2].x, self.touches[2].y)
        r = math_clamp(_low, _n*(touchesDist/self.lastDist), _high)
        self.lastDist = touchesDist
    end
    return r
end

function touches:isTapped(_times)
    return self.count == _times
end

function touches:wasTapped(_times)
    return self.count >= _times 
end

function touches:distance(_touch1, _touch2)
    local _, touch1 = self:getTouch(_touch1)
    local _, touch2 = self:getTouch(_touch2)
    return math_distance2d(touch1.x, touch1.y, touch2.x, touch2.y)
end

--&exteral API&--
function touches:touchpressed(id, x, y, dx, dy, pressure)
    if self.limitOfTouches ~= nil then
        if #self.touches > self.limitOfTouches then
            return 
        end
    end
    table.insert(self.touches, {
        id = id,
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        pressure = pressure,
        move = {}
    })
    self.count = self.count + 1
end

function touches:touchmoved(id, x, y, dx, dy, pressure)
    local i, touch = self:getTouch(id)
    self.touches[i].id = id
    self.touches[i].x = x
    self.touches[i].y = y
    self.touches[i].dx = dx
    self.touches[i].dy = dy
    self.touches[i].pressure = pressure
    table.insert(self.touches[i].move, self.touches[i])
end

function touches:touchreleased(id, x, y, dx, dy, pressure)
    table.remove(self.touches, self:getTouch(id))
end

return touches