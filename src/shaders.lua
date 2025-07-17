local shaders = {}

local path = "assets/shaders/"

function shaders.load()
    shaders.pixelate = love.graphics.newShader(path .. "pixelate.fs")
end

return shaders