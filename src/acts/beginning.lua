local Canvas = require("src.canvas")
local Camera = require("src.core.camera")
local Map = require("src.core.map")
local Player = require("src.core.player")

---@class Beginning : Act
local act = {}

function act:load()
    self.time = 0
    self.screenWidth, self.screenHeight = love.graphics.getDimensions()
    self.width, self.height = 1920/2, 1200/2

    Player:load(self.width/2, self.height/2, 250, true)
    Player:setBoundary(0, 0, self.width, self.height)
    self.playerX, self.playerY = Player:getPosition()
    self.camX, self.camY = self.playerX, self.playerY

    Camera:setSize(self.width, self.height)
    Camera:setPosition(self.width/2, self.height/2)

    self.canvas = Canvas:new()
    self.canvas:addNew("main", self.width, self.height)
    self.canvas:setFilter("main", "nearest", "nearest")
    self.canvas:addNew("test", 80, 80)

    self:ReconfMainCanvas()
end

function act:update(dt)
    self.time = self.time + dt
    self.playerX, self.playerY = Player:getPosition()

    Player:update(dt)

    -- easing camera pos (easeOutCubic)
    local speed = 1.2
    local easedT = 1 - (1 - math.min(dt * speed, 1))^3
    self.camX = self.camX + (self.playerX - self.camX) * easedT
    self.camY = self.camY + (self.playerY - self.camY) * easedT
    Camera:setPosition(self.camX, self.camY)

    -- for debugging
    local a, b = Player:getPosition()
    print("player pos: " .. a, b)
end

function act:draw()
    self.canvas:drawTo("test", function()
        love.graphics.clear(1, 0, 1)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 0, 0, 50, 50)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("HELLO FUCKASS", 8, 20)
    end)

    self.canvas:drawTo("main", function()
        love.graphics.clear(0, 1, 1)
        Camera:attach()
            Map:draw()

            love.graphics.setColor(0, 0, 0)
            love.graphics.circle("fill", 200, 300, 100)

            Player:draw()
            Player:drawBoundary()
            Player:drawHitbox()

            love.graphics.points(500, 500)

            self.canvas:blit("test", "main", self.width/2 - 35, 0)
        Camera:detach()
    end)

    self.canvas:drawAll({"main"})
end

function act:keypressed(key, isrepeat)
    if key == "return" then
    end
end

function act:mousepressed(x, y, button, _, presses)
    local LMB, RMB = (button == 1), (button == 2)
end

function act:resize(w, h)
    self.screenWidth, self.screenHeight = love.graphics.getDimensions()

    self:ReconfMainCanvas()
end

function act:ReconfMainCanvas()
    local canvasW, canvasH = self.canvas:getSize("main")
    local scale = math.min(self.screenWidth / canvasW, self.screenHeight / canvasH)
    local offsetX = (self.screenWidth / scale - canvasW) / 2
    local offsetY = (self.screenHeight / scale - canvasH) / 2
    self.canvas:scale("main", scale, scale)
    self.canvas:translate("main", offsetX, offsetY)
end


return act