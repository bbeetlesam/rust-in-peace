local Player = require("src.core.player")

local Map = {
    house = {}
}

function Map:loadAllWalls()
    local w = 1.5
    Player:addWall(-w, -w, 32*7 + w*2, w*2) -- top living room
    Player:addWall(-w, -w + w*2, w*2, 32*5) -- left living room

    Player:addWall(32*7 - w, -w - 32*4, w*2, 32*4) -- left bathroom
    Player:addWall(32*7 - w, -w, 32*5 + w*2, w*2) -- bottom bathroom
    Player:addWall(32*7 - w, -w - 32*4, 32*5 + w*2, w*2) -- top bathroom
    Player:addWall(32*12 - w, -w - 32*4, w*2, 32*4 + w*2) -- right bathroom

    Player:addWall(32*12 - w, -w - 32*4, 32*5 + w*2, w*2) -- top bedroom
    Player:addWall(32*17 - w, -w - 32*4, w*2, 32*7 + w*2) -- right bedroom
    Player:addWall(32*12 - w, -w + 32*3, 32*5 + w*2, w*2) -- bottom bathroom
    Player:addWall(32*12 - w, -w + 32*2, w*2, 32*1 + w*2) -- left bathroom small

    Player:addWall(32*12 - w, -w + 32*5, w*2, 32*5 + w*2) -- right kitchen & left entry
    Player:addWall(-w + 32*4, -w + 32*10, 32*8 + w*2, w*2) -- bottom kitchen
    Player:addWall(-w + 32*4, -w + 32*5, w*2, 32*5) -- left kitchen

    Player:addWall(-w + 32*12, -w + 32*9, 32*3 + w*2, w*2) -- bottom entry
    Player:addWall(32*15 - w, -w + 32*5, w*2, 32*4 + w*2) -- right entry

    Player:addWall(-w - 32*4, -w - 32*4 + 32/2, 32*7 + 32*4 + w*2, w*2) -- top backyard
    Player:addWall(-w - 32*4, -w + w*2 - 32*4 +32/2, w*2, 32*17) -- left backyard
    Player:addWall(-w - 32*4, -w + 32*13 + 32/2, 32*7 + 32*2 + w*2, w*2) -- bottom backyard

    Player:addWall(-w + 32*17, -w - 32*4 + 32/2, 32*6 + w*2, w*2) -- top frontyard
    Player:addWall(-w + 32*23, -w + w*2 - 32*4 +32/2, w*2, 32*17) -- right frontyard
    Player:addWall(-w + 32*11, -w + 32*13 + 32/2, 32*12 + w*2, w*2) -- bottom frontyard

    Player:addWall(-w + 32*5, -w + 32*14, 32*6 + w*2, w*2) -- bottom storage
    Player:addWall(32*11 - w, -w + 32*10, w*2, 32*4 + w*2) -- right storage
    Player:addWall(32*5 - w, -w + 32*12, w*2, 32*2 + w*2) -- left storage
end

function Map:loadAllTiles()
    -- add house floors/tiles
    self.house.tileBatch = love.graphics.newSpriteBatch(self.house.tileImage, 500, "static")
    self.house.tiles = {}
    -- living room
    for i = 0,5 - 1 do
        for j = 0,12 - 1 do
            table.insert(self.house.tiles,
            {x = j * 64, y = i * 64})
        end
    end
    -- kitchen
    for i = 0,5 - 1 do
        for j = 0,8 - 1 do
            table.insert(self.house.tiles,
            {x = j * 64 + 64*4, y = i * 64 + 64*5})
        end
    end
    -- kitchen
    for i = 5,9 - 1 do
        for j = 1,7 - 1 do
            table.insert(self.house.tiles,
            {x = j * 64 + 64*4, y = i * 64 + 64*5})
        end
    end
    -- entry area
    for i = -2,4 - 1 do
        for j = 8,11 - 1 do
            table.insert(self.house.tiles,
            {x = j * 64 + 64*4, y = i * 64 + 64*5})
        end
    end
    -- bathroom
    for i = -1,-4,-1 do
        for j = 0,5 - 1 do
            table.insert(self.house.tiles,
            {x = j * 64 + 64*7, y = i * 64})
        end
    end
    -- bedroom
    for i = -1,-7,-1 do
        for j = 0,5- 1 do
            table.insert(self.house.tiles,
            {x = j * 64 + 64*12, y = i * 64 + 64*3})
        end
    end

    for _, pos in ipairs(self.house.tiles) do
        self.house.tileBatch:add(pos.x, pos.y)
    end
end

function Map:load()
    self:loadAllWalls()

    self.house.tileImage = love.graphics.newImage("assets/img/tiletes.png") -- placeholder
    self:loadAllTiles()
end

function Map:update(dt)

end

function Map:draw()
    -- for 0,0 point
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 0, 0, 20)

    -- draw tiles
    love.graphics.draw(self.house.tileBatch, 0, 0, 0, 0.5)
end

return Map