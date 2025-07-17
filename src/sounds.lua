local sounds = {}

local path = "assets/sfx/"

function sounds.load()
    sounds.clockTick = love.audio.newSource(path .. "clock-tick.ogg", "static")
    sounds.rollingSolid = love.audio.newSource(path .. "rolling-wheels-solid.ogg", "static")
end

return sounds