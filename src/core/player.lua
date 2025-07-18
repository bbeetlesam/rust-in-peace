local utils = require("src.utils")
local sounds = require("src.sounds")

local Player = {}

-- Eyes funcs
function Player:setEyes()
    self.eyesOffsetX = 0
    self.eyesOffsetY = 0
    self.eyesOffsetStrength = 3.5
    self.eyesEasing = 0.2
end

function Player:updateEyes()
    local targetEyesX = (self.dx or 0) * self.eyesOffsetStrength
    local targetEyesY = (self.dy or 0) * self.eyesOffsetStrength
    self.eyesOffsetX = self.eyesOffsetX + (targetEyesX - self.eyesOffsetX) * self.eyesEasing
    self.eyesOffsetY = self.eyesOffsetY + (targetEyesY - self.eyesOffsetY) * self.eyesEasing
end

-- Hand funcs
function Player:setHands()
    self.handRot = 0
    self.handRotStrength = 0.4
    self.handRotEasing = 0.1
end

function Player:updateHands()
    local targetRot = (self.dx or 0) * self.handRotStrength
    self.handRot = self.handRot + (targetRot - self.handRot) * self.handRotEasing
end

function Player:load(x, y, speed, playable)
    self.x = x or 0
    self.y = y or 0
    self.speed = speed or 1
    self.playable = (playable ~= nil) and playable or false

    -- hitbox
    self.width = 40
    self.height = 55

    -- init boundary
    self.boundary = nil

    -- player's visual components
    self.head = love.graphics.newImage("assets/img/head.png")
    self.eyes = love.graphics.newImage("assets/img/eyes.png")
    self.eyelash = love.graphics.newImage("assets/img/eyelash.png")
    self.hands = love.graphics.newImage("assets/img/hand.png")

    self.wheel = {}
    self.wheelAtlas = love.graphics.newImage("assets/img/wheel.png")
    for i = 0, 3 do
        self.wheel[i + 1] = love.graphics.newQuad(i * 60, 0, 60, 60, self.wheelAtlas:getDimensions())
    end
    self.wheelId = 1
    self.wheelDir = 1

    self:setEyes()
    self:setHands()
    self.frame = 0

    -- Walls
    self.walls = {}
end

function Player:update(dt)
    self.frame = self.frame + 1
    self.dx, self.dy = 0, 0
    local left, right, up, down

    -- move based on key pressed
    if self.playable then
        left  = love.keyboard.isDown("a")
        right = love.keyboard.isDown("d")
        up = love.keyboard.isDown("w")
        down = love.keyboard.isDown("s")
    end

    -- add movement to dx and dy
    if up then self.dy = self.dy - 1 end
    if down then self.dy = self.dy + 1 end
    if left then self.dx = self.dx - 1 end
    if right then self.dx = self.dx + 1 end

    -- normalize vector (for diagonal movement)
    local length = math.sqrt(self.dx * self.dx + self.dy * self.dy)
    if length > 0 then
        self.dx = self.dx / length
        self.dy = self.dy / length
    end

    local nextX = self.x + self.dx * self.speed * dt
    local nextY = self.y + self.dy * self.speed * dt

    -- check walls on x axis
    for _, wall in ipairs(self.walls) do
        nextX = self:collideAxis(nextX, self.y, wall, "x")
    end
    -- check for y axis then
    for _, wall in ipairs(self.walls) do
        nextY = self:collideAxis(nextX, nextY, wall, "y")
    end

    -- clamp to boundary if set
    if self.boundary then
        local minX = self.boundary.x + self.width / 2
        local minY = self.boundary.y + self.height / 2
        local maxX = self.boundary.x + self.boundary.w - self.width / 2
        local maxY = self.boundary.y + self.boundary.h - self.height / 2
        nextX = math.max(minX, math.min(nextX, maxX))
        nextY = math.max(minY, math.min(nextY, maxY))
    end

    -- update final position
    self.x = nextX
    self.y = nextY

    -- update components
    self:updateEyes()
    self:updateHands()

    -- wheel sprites
    if self.frame % 3 == 0 and (self.dx ~= 0 or self.dy ~= 0) then
        self.wheelId = self.wheelId + 1
        if self.wheelId > 4 then
            self.wheelId = 1
        end
    end
    if self.dx ~= 0 then self.wheelDir = utils.round(self.dx) end

    -- sounds
    if self.dx ~= 0 or self.dy ~= 0 then
        sounds.rollingSolid:play()
        sounds.rollingSolid:setVolume(0.3)
    else
        sounds.rollingSolid:stop()
    end
end

function Player:draw()
    local y = self.y - 7
    love.graphics.setColor(1, 1, 1)
    -- wheel leg
    love.graphics.draw(self.wheelAtlas, self.wheel[self.wheelId], self.x + 0.5, y + 20, 0, 0.8*self.wheelDir, 1, 30, 0)
    -- right hand
    love.graphics.draw(self.hands, self.x - 14, y + 3, self.handRot, -1, 1, 0, self.hands:getHeight()/2)
    love.graphics.draw(self.hands, self.x + 14, y + 3, self.handRot, 1, 1, 0, self.hands:getHeight()/2)
    -- head
    love.graphics.draw(self.head, self.x, y, 0, 0.7, 0.8, self.head:getWidth()/2, self.head:getHeight()/2)
    -- battery indicator circle
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x - 2, y - 18, 4, 2)
    love.graphics.setColor(1, 1, 1)
    -- eyes
    love.graphics.draw(self.eyes, self.x - 1 + self.eyesOffsetX, y - 4 + self.eyesOffsetY, 0, 0.8, 0.9,
        self.eyes:getWidth()/2,
        self.eyes:getHeight()/2
    )
    -- eyelashes
    love.graphics.draw(self.eyelash, self.x - 1 + self.eyesOffsetX - 6, y - 11 + self.eyesOffsetY, 0, 0.8, 1,
        self.eyelash:getWidth()/2,
        self.eyelash:getHeight()/2
    )
    love.graphics.draw(self.eyelash, self.x - 1 + self.eyesOffsetX + 7, y - 11 + self.eyesOffsetY, 0, 0.8, 1,
        self.eyelash:getWidth()/2,
        self.eyelash:getHeight()/2
    )
end

function Player:getPosition()
    return self.x, self.y
end

function Player:isPosHit(x, y)
    local left   = self.x - self.width / 2
    local right  = self.x + self.width / 2
    local top    = self.y - self.height / 2
    local bottom = self.y + self.height / 2
    return (x >= left and x <= right and y >= top and y <= bottom)
end

function Player:setHitboxSize(w, h)
    self.width = w or 50
    self.height = h or 50
end

function Player:setBoundary(x, y, w, h)
    self.boundary = {x = x, y = y, w = w, h = h}
end

function Player:removeBoundary()
    self.boundary = nil
end

function Player:addWall(x, y, w, h)
    table.insert(self.walls, {x = x, y = y, w = w, h = h})
end

function Player:removeWall(index)
    if self.walls[index] then
        table.remove(self.walls, index)
    end
end

function Player:collideAxis(nextX, nextY, wall, axis)
    local hw = self.width / 2
    local hh = self.height / 2

    local px = nextX
    local py = nextY

    local left   = px - hw
    local right  = px + hw
    local top    = py - hh
    local bottom = py + hh

    local wleft   = wall.x
    local wright  = wall.x + wall.w
    local wtop    = wall.y
    local wbottom = wall.y + wall.h

    local overlapX = right > wleft and left < wright
    local overlapY = bottom > wtop and top < wbottom

    if overlapX and overlapY then
        if axis == "x" then
            if self.x < wleft then
                return wleft - hw
            else
                return wright + hw
            end
        elseif axis == "y" then
            if self.y < wtop then
                return wtop - hh
            else
                return wbottom + hh
            end
        end
    end
    return axis == "x" and nextX or nextY
end

-- for debugging
function Player:drawBoundary()
    if self.boundary then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", self.boundary.x, self.boundary.y, self.boundary.w, self.boundary.h)
        love.graphics.setColor(1, 1, 1)
    end
end

-- for debugging
function Player:drawHitbox()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

-- for debugging
function Player:drawWalls()
    love.graphics.setColor(1, 0, 0, 0.5)
    for _, wall in ipairs(self.walls) do
        love.graphics.rectangle("fill", wall.x, wall.y, wall.w, wall.h)
    end
    love.graphics.setColor(1, 1, 1)
end



return Player