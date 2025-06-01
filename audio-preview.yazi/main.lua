-- Edited from: https://github.com/gesellkammer/audio-preview.yazi

local M = {}

function M:peek(job)
    local start, url = os.clock(), ya.file_cache(job)

    if not url or not fs.cha(url) then
        return require("file"):peek(job)
    end

    ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

    local _, err = ya.image_show(url, job.area)
    ya.preview_widgets(job, {})
end

function M:preload(job)
    local cache = ya.file_cache(job)
    if not cache or fs.cha(cache) then
        return true
    end

    local sox_command, code = Command("sox")
        :args({
            tostring(job.file.url),
            "-n", "spectrogram",
            "-c", "Yazi (sox)",
            "-o", tostring(cache)
        }):spawn()

    if not sox_command then
        ya.err("sox returned " .. tostring(code))
        return false
    end

    local status = sox_command:wait()

    return status and status.success and true or false
end

function M:seek() end


return M
