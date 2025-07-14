function love.conf(t)
    t.window.title = "Rust in Peace"
    t.window.icon = nil
    t.window.width = 1440
    t.window.height = 1080
    t.window.resizable = true
    t.window.fullscreen = false -- set true on final version
    t.window.minwidth = 0
    t.window.minheight = 0
    t.window.vsync = 1

    -- for debugging
    t.version = "11.5"
    t.console = true -- set false on final version
    t.identity = nil
    t.window.display = 2
end