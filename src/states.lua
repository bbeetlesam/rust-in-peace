local Act = require("src.acts")

local states = {}

states.fullscreen = love.window.getFullscreen()
states.width, states.height = love.graphics.getDimensions()
states.currentAct = Act:getAct()

-- update states
states.update = function(dt)
    states.width, states.height = love.graphics.getDimensions()
    states.currentAct = Act:getAct()
end

return states