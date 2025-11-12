local M = {}

local function run_spotify_control(action)
    local cmd = "spotify-control " .. action
    vim.fn.jobstart(cmd, {
        on_exit = function(job_id, code, event)
            local stdout = event.stdout
            local stderr = event.stderr
            if code == 0 then
                vim.notify("Spotify: " .. action .. " successful", vim.log.levels.INFO, { title = "Spotify" })
            else
                local error_msg = "Spotify: " .. action .. " failed (code: " .. code .. ")"
                if stdout and #stdout > 0 then
                    error_msg = error_msg .. "\nStdout: " .. table.concat(stdout, "\n")
                end
                if stderr and #stderr > 0 then
                    error_msg = error_msg .. "\nStderr: " .. table.concat(stderr, "\n")
                end
                vim.notify(error_msg, vim.log.levels.ERROR, { title = "Spotify" })
            end
        end,
        stdout_buffered = true,
        stderr_buffered = true,
    })
end

function M.play_pause()
    run_spotify_control("play-pause")
end

function M.next()
    run_spotify_control("next")
end

function M.previous()
    run_spotify_control("previous")
end

function M.volume_up()
    run_spotify_control("volume-up")
end

function M.volume_down()
    run_spotify_control("volume-down")
end

return M