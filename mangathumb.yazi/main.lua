-- Edited from: https://github.com/navysky12/comicthumb.yazi/blob/main/init.lua

local M = {}

function M:peek(job)
    local start, url = os.clock(), ya.file_cache(job)

    if not url or not fs.cha(url) then
        return require("archive"):peek(job)
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

    local arch_command = Command("7z")
        :args({ "-ba", "l", tostring(job.file.url) })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    local awk_command = Command("awk")
        :args({
            [[length($0) > 53 && tolower(substr($0, 54)) ~ /\.(jpg|jpeg|png|gif)$/ { print substr($0, 54) }]]
        })
        :stdin(arch_command:take_stdout())
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    local awk_output, event = awk_command:wait_with_output()
    arch_command:start_kill()

    local filenames = {}
    for filename in awk_output.stdout:gmatch("[^\n]+") do
        table.insert(filenames, filename)
    end
    table.sort(filenames)

    job.skip = job.skip >= #filenames and (#filenames - 1) or job.skip

    if job.skip == -1 then
        return true
    end

    local extract_output = Command("7z")
        :args({ "-so", "e", tostring(job.file.url), filenames[job.skip + 1] })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :output()

    return fs.write(cache, extract_output.stdout) and true or false
end

function M:seek() end

return M
