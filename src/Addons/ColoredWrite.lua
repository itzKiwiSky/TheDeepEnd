--- Prints a text with format styled
---@param _str string
---@alias Tags
---|'"reset"'
---|'"black"'
---|'"red"'
---|'"green"'
---|'"yellow"'
---|'"blue"'
---|'"magenta"'
---|'"cyan"'
---|'"white"'
---|'"brightBlack"'
---|'"brightRed"'
---|'"brightGreen"'
---|'"brightYellow"'
---|'"brightBlue"'
---|'"brightMagenta"'
---|'"brightCyan"'
---|'"brightWhite"'
---|'"bgBlack"'
---|'"bgRed"'
---|'"bgGreen"'
---|'"bgYellow"'
---|'"bgBlue"'
---|'"bgMagenta"'
---|'"bgCyan"'
---|'"bgWhite"'
---|'"bgBrightBlack"'
---|'"bgBrightRed"'
---|'"bgBrightGreen"'
---|'"bgBrightYellow"'
---|'"bgBrightBlue"'
---|'"bgBrightMagenta"'
---|'"bgBrightCyan"'
---|'"bgBrightWhite"'
---|'"bold"'
---|'"underline"'
---|'"blink"'
---|'"invert"'
---|'"hidden"'
function io.printf(_str)
    for t, c in pairs(termColors) do
        _str = _str:gsub("{" .. t .. "}", c)
    end
    io.write(_str)
end

return io.printf