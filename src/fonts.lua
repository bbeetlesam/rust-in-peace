local fonts = {}

local path = "assets/fonts/"

function fonts.load()
    fonts.messageBox = love.graphics.newFont(path .. "Pixellari.ttf", 20)
end

return fonts