-- Edited from: https://github.com/Ape/open-with-cmd.yazi
--- @since 25.5.31

return {
    entry = function(_, job)
        local block = job.args[1] and job.args[1] == "block"

        local value, event = ya.input({
            title = block and "Open with (block):" or "Open with:",
            position = { "hovered", y = 1, w = 50 },
        })

        if event == 1 then
            ya.emit("shell", {
                value .. ' "$@"',
                block = block,
                orphan = true,
                confirm = true,
            })
        end
    end,
}
