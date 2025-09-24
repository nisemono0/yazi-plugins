-- Edited from: https://github.com/navysky12/comicthumb.yazi
--- @since 25.5.31

local M = {}

function M:peek(job)
    local start, url = os.clock(), ya.file_cache(job)
    if not url or not fs.cha(url) then
        require("archive"):peek(job)
    end

    local ok, err = self:preload(job)
    if not ok or err then
        return
    end

    ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

    local _, err = ya.image_show(url, job.area)
    ya.preview_widget(job, err and ui.Text(tostring(err)):area(job.area):wrap(ui.Wrap.YES))

end

function M:preload(job)
    local cache = ya.file_cache(job)
    if not cache or fs.cha(cache) then
        return true
    end

    local filelist, err = self.get_arch_filelist(job.file.url)
    if not filelist then
        return false, Err("Failed to get archive filelist", err)
    end

    job.skip = job.skip >= #filelist and (#filelist - 1) or job.skip

    if job.skip == -1 then
        return false, Err("No images in archive: " .. tostring(job.file.url))
    end

    local image_filename = filelist[job.skip + 1]
    local image_data, err = self.get_arch_image(job.file.url, image_filename)
    if not image_data then
        return false, Err("Failed to get image data", err)
    end

    write_img, write_img_err = fs.write(cache, image_data)
    if not write_img then
        return false, Err("Failed to write image cache", write_img_err)
    end
    return true

    -- This pre-caches the saved full res image to one based on user max_{width,height}
    -- Returning this instead of true basically does 2 writes on disk
    -- Performance hit is not noticeable
    -- return ya.image_precache(cache, cache)
end

function M:seek(job) require("archive"):seek(job) end

function M.get_arch_filelist(url)
    local arch_child, err = Command("7z")
        :arg({ "-ba", "l", tostring(url) })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()
    if not arch_child then
        return false, Err("Failed to spawn 7z", err)
    end

    local arch_stdout = arch_child:take_stdout()
    if not arch_stdout then
        return false, Err("Failed to list archive with 7z")
    end

    local awk_child, err = Command("awk")
        :arg({
            [[length($0) > 53 && tolower(substr($0, 54)) ~ /\.(jpg|jpeg|png|gif)$/ { print substr($0, 54) }]]
        })
        :stdin(arch_stdout)
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()
    if not awk_child then
        return false, Err("Failed to spawn awk", err)
    end

    local awk_output, err = awk_child:wait_with_output()
    if not awk_output then
        return false, Err("Can't read awk output", err)
    end

    local filenames = {}
    for filename in awk_output.stdout:gmatch("[^\n]+") do
        table.insert(filenames, filename)
    end
    table.sort(filenames)
    return filenames
end

function M.get_arch_image(url, filename)
    local extract_output, err = Command("7z")
        :arg({ "-so", "e", tostring(url), tostring(filename) })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :output()

    if not extract_output then
        return false, Err("Failed to extract image with 7z", err)
    end

    return extract_output.stdout
end

return M
