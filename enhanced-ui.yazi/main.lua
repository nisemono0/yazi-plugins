local function headerfile()
    local h = cx.active.current.hovered
    if h then
        return ui.Line{ ui.Span("/"):fg("green"), ui.Span(tostring(h.name)) }
    else
        return ui.Span("/"):fg("green")
    end
end

local function hostname()
    return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end

local function disk_space()
    local df_command = "df -kh --output=avail . | grep -i -v 'Avail' | tr -d '[:space:]'"

    local free_space = io.popen(df_command):read("*all")

    return ui.Line{
        ui.Span(tostring(free_space)),
        ui.Span(" free ")
    }:fg("magenta")
end

local function mtime()
    local h = cx.active.current.hovered
    if not h then
        return ui.Span("")
    end

    if not h.cha.mtime then
        return ui.Span("")
    end

    return ui.Span(os.date("%Y-%m-%d %H:%M", h.cha.mtime // 1)):fg("magenta")
end

local function symlink()
    local h = cx.active.current.hovered
    if h and h.link_to then
        return ui.Span(" -> " .. tostring(h.link_to))
    else
        return ui.Span("")
    end
end

local function usergroup()
    local h = cx.active.current.hovered

    return ui.Line {
        ui.Span(" "), ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ui.Span(":"),
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        ui.Span(" "),
    }
end

local function setup()
    Header:children_add(headerfile, 1200, Header.LEFT)
    Header:children_add(hostname, 200, Header.LEFT)
    -- Header:children_add(disk_space, 900, Header.RIGHT)

    Status:children_add(mtime, 1300, Status.RIGHT)
    Status:children_add(symlink, 3100, Status.LEFT)
    Status:children_add(usergroup, 1100, Status.RIGHT)
end

return { setup = setup }
