return function(cmd)
    cmd:newCommand("echo", function(...)
        local args = {...}
        cmd:trace(string.format("[%s] : %s", os.date("%Y-%m-%d %H:%M:%S"), table.concat(args, " ")))
        return
    end)
end