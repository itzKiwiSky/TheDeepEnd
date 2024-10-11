local function getTags(text)
    local result = {}

    for tag, text, c in string.gmatch(text, "({.-})%s?%w+%s?") do
        print(tag, text, c)
        table.insert(result, {tag, text})
    end

    return result
end

return function(text)
    local coloredText = {}
    local splitedText = getTags(text)
    print(debug.formattable(splitedText))

    for s = 1, #splitedText, 1 do
        if string.find(splitedText[s], "({(.-)})") or string.find(splitedText[s], "({rgba?%s*%([%d%s%.,]+%)})") then
            local tagContent = string.match(splitedText[s], "{(.-)}")
            local tagData = string.split(tagContent, "=")
            switch(tagData[1], {
                ["color"] = function()
                    table.insert(coloredText, {lume.color(tagData[2])})
                end
            })
        else
            table.insert(coloredText, splitedText[s])
        end
    end

    return coloredText
end
