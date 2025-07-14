local Player = {}

function Player:load(x, y, speed, playable)
    self.x = x or 0
    self.y = y or 0
    self.speed = speed or 1
    self.playable = (playable ~= nil) and playable or false

    -- hitbox
    self.width = 50
    self.height = 50

    self.boundary = nil
end

function Player:update(dt)
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
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x - 25, self.y - 25, 50, 50)
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

return Player