local sounds = require("src.sounds")

local clock = {}

function clock:load(hour, minute, timeEachHour, sx, sy)
    self.hour = hour or 6
    self.minute = minute or 0
    self.timeEachHour = timeEachHour or 20

    self.image = love.graphics.newImage("assets/img/clock.png")
    self.tickHour = love.graphics.newImage("assets/img/tick-hour.png")
    self.tickMin = love.graphics.newImage("assets/img/tick-min.png")

    self.image:setFilter("nearest", "nearest")
    self.tickHour:setFilter("nearest", "nearest")
    self.tickMin:setFilter("nearest", "nearest")

    self.timer = 0
    self.x = 0
    self.y = 0
    self.sx = sx or 1
    self.sy = sy or sx
    self.ox = 0
    self.oy = 0
end

function clock:update(dt)
    -- how many 'min in-game' each sec irl
    local gameMinutesPerSecond = 60 / self.timeEachHour

    self.minute = self.minute + gameMinutesPerSecond * dt

    -- if the minute passes 60
    if self.minute >= 60 then
        self.minute = self.minute - 60
        self.hour = self.hour + 1

        if self.hour >= 24 then
            self.hour = 0
        end

        sounds.clockTick:play()
        sounds.clockTick:setVolume(0.5)
    end

    -- print(self.minute, self.hour)
end

function clock:draw()
    local tickx, ticky = self.x + self.image:getWidth()*self.sx/2, self.y + self.image:getHeight()*self.sy/2
    local tickHourRot = ((self.hour % 12) / 12 + self.minute / 720) * 360
    local tickMinRot = (self.minute / 60) * 360

    -- love.graphics.setColor(0, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, 0, self.sx, self.sy, self.ox, self.oy)
    love.graphics.draw(self.tickMin, tickx, ticky, math.rad(tickMinRot), self.sx, self.sy, self.tickMin:getWidth()/2, self.tickMin:getHeight()/2)
    love.graphics.draw(self.tickHour, tickx, ticky, math.rad(tickHourRot), self.sx, self.sy, self.tickHour:getWidth()/2, self.tickHour:getHeight()/2)
    love.graphics.setColor(1, 1, 1)
end

function clock:drawAt(x, y, sx, sy, ox, oy)
    self.x = x
    self.y = y
    self.sx = sx or 1
    self.sy = sy or sx
    self.ox = ox or 0
    self.oy = oy or 0

    self:draw()
end

---@param scale number?
function clock:getSize(scale)
    local s = scale or self.sx or 1
    local w = self.image:getWidth() * s
    local h = self.image:getHeight() * s
    return w, h
end

return clock