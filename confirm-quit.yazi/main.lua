--- @since 25.5.31

local count = ya.sync(function() return #cx.tabs end)

local function entry()
    if count() < 2 then
        return ya.emit("quit", {})
    end

    local yes = ya.confirm {
        pos = { "center", w = 60, h = 10 },
        title = "Quit?",
        content = ui.Text("Multiple tabs open. Quit anyway?"):wrap(ui.Wrap.YES),
    }
    if yes then
        ya.emit("quit", {})
    end
end

return { entry = entry }
