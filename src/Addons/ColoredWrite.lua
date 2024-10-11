--- Prints a text with format styled
---@param _str string
function io.printf(_str)
    for t, c in pairs(termColors) do
        _str = _str:gsub("{" .. t .. "}", c)
    end
    io.write(_str)
end

return io.printf