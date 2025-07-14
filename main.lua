local Acts = require("src.acts")
local states = require("src.states")

function love.load()
    Acts:load("beginning")
end

function love.update(dt)
    Acts:update(dt)
    states.update(dt)

    -- print(states.width, states.height)
    -- print("current act: " .. states.currentAct)
end

function love.draw()
    Acts:draw()
end

function love.keypressed(key, _, isrepeat)
    Acts:keypressed(key, isrepeat)
end

function love.mousepressed(x, y, button, _, presses)
    Acts:mousepressed(x, y, button, _, presses)
end

function love.keyreleased(key, _, _)
    if key == "escape" then
        love.event.quit()
    elseif key == "f11" then
    end
end

function love.resize(w, h)
    Acts:resize(w, h)
end