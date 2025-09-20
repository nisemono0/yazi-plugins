-- Edited from: https://github.com/gesellkammer/audio-preview.yazi
--- @since 25.5.31

local M = {}

function M:peek(job)
    local cmd = "mediainfo"
    local output, err = Command(cmd):arg( tostring(job.file.url) ):output()

    local text
    if output then
        text = ui.Text.parse("----- Mediainfo -----\n\n" .. output.stdout)
    else
        text = ui.Text(string.format("Failed to start `%s`, error: %s", cmd, err))
    end

    ya.preview_widget(job, text:area(job.area):wrap(ui.Wrap.YES))

end

function M:preload() end

function M:seek() end


return M
