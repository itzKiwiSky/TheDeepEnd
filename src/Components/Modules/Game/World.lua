local World = {}

function World:init(filename)
    local self = setmetatable({}, World)
    --self.blocks = {}
    self.width = 0
    self.height = 0

    self.tiledfile = love.filename.load(filename)

    

    return self
end

function World:draw()
    
end

function World:update(elapsed)
    
end

return World