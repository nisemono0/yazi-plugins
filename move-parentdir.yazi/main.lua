local get_parent_dirpath = ya.sync(function(_, direction)
    local parent = cx.active.parent

    if not parent then
        return nil
    end

    local total_items = #parent.files
    local new_idx = parent.cursor + direction + 1

    local start_idx = new_idx
    local end_idx = direction < 0 and 1 or total_items
    local step = direction < 0 and -1 or 1

    for i = start_idx, end_idx, step do
        local file = parent.files[i]
        if file and file.cha.is_dir then
            return file.url
        end
    end

    return nil

end)

local function entry(_, job)
    local action = job.args[1]

    if action == "next" then
        local next_dirpath = get_parent_dirpath(1)
        if next_dirpath then
            ya.mgr_emit("cd", { next_dirpath })
        end
    end
    if action == "prev" then
        local prev_dirpath = get_parent_dirpath(-1)
        if prev_dirpath then
            ya.mgr_emit("cd", { prev_dirpath })
        end
    end
end

return { entry = entry }
