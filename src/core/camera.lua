local Camera = {
    x = 0,
    y = 0,
    zoom = 1
}

function Camera:setPosition(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Camera:setSize(width, height)
    self.width = width or 0
    self.height = height or 0
end

function Camera:getPosition()
    return self.x, self.y
end

function Camera:setZoom(zoom)
    self.zoom = zoom or 1
end

function Camera:attach()
    love.graphics.push()

    -- translate to center screen
    love.graphics.translate(self.width / 2, self.height / 2)

    -- scale/zoom based on the point
    love.graphics.scale(self.zoom, self.zoom)

    -- return translate, then move view based on camera position
    love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
    love.graphics.pop()
end

return Camera