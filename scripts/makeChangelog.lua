local entries = require 'docs.entries'
local template = [[
[Changelog]

All notable changes is listed here.

{version:%s} | {date:%s}
    {%s}
]]

local function main()
    local t = [[
    :(Unreleased):
        {%s}
    :(Added):
        {%s}
    :(Changed):
        {%s}
    :(Removed):
        {%s}
    ]]
end

return main()