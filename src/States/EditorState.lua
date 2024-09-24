EditorState = {}

function EditorState:init()
    slab.Initialize({"NoDocks"})
    slab.SetINIStatePath(nil)
end

function EditorState:enter()
    levelData = {
        meta = {},
        objects = {}
    }
end

function EditorState:draw()
    slab.Draw()
end

function EditorState:update(elapsed)

end

return EditorState