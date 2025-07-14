local Canvas = {}
Canvas.__index = Canvas

function Canvas:new()
    local self = setmetatable({}, Canvas)
    self.canvases = {} -- [id] = { canvas, shaders, scaleX, scaleY, transX, transY, posX, posY }
    return self
end

function Canvas:addNew(id, width, height, shaders)
    self.canvases[id] = {
        canvas = love.graphics.newCanvas(width, height),
        shaders = shaders or {},
        scaleX = 1, scaleY = 1,
        transX = 0, transY = 0,
        posX = 0, posY = 0
    }
end

function Canvas:getSize(id)
    local c = self.canvases[id]
    if c then return c.canvas:getDimensions() end
    return 0, 0
end

function Canvas:setPosition(id, x, y)
    local c = self.canvases[id]
    if c then c.posX = x or 0; c.posY = y or 0 end
end

function Canvas:addShader(id, shadersTable)
    local c = self.canvases[id]
    if c then
        for _, shader in ipairs(shadersTable) do
            table.insert(c.shaders, shader)
        end
    end
end

function Canvas:clearShader(id)
    local c = self.canvases[id]
    if c then c.shaders = {} end
end

function Canvas:scale(id, sx, sy)
    local c = self.canvases[id]
    if c then c.scaleX = sx or 1; c.scaleY = sy or sx or 1 end
end

function Canvas:translate(id, tx, ty)
    local c = self.canvases[id]
    if c then c.transX = tx or 0; c.transY = ty or 0 end
end

function Canvas:setFilter(id, min, mag)
    local c = self.canvases[id]
    if c and c.canvas then
        c.canvas:setFilter(min or "linear", mag or "linear")
    end
end

function Canvas:drawTo(id, drawFunc)
    local c = self.canvases[id]
    if c and drawFunc then
        love.graphics.setCanvas(c.canvas)
        love.graphics.push()
        love.graphics.origin()
        love.graphics.clear(0,0,0,0)
        drawFunc()
        love.graphics.pop()
        love.graphics.setCanvas()
    end
end

-- draw one canvas onto another canvas (or the screen if dstId is nil)
---@param srcId string
---@param dstId string|nil
---@param x number
---@param y number
function Canvas:blit(srcId, dstId, x, y)
    local src = self.canvases[srcId]
    local dst = dstId and self.canvases[dstId] or nil
    if not src then return end

    if dst then
        love.graphics.setCanvas(dst.canvas)
    else
        love.graphics.setCanvas()
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(src.canvas, x or 0, y or 0)
    love.graphics.setCanvas()
end

-- draw a single canvas to the screen (with its transform and shaders) (only used in canvas:drawAll)
function Canvas:present(id)
    local c = self.canvases[id]
    if not c then return end
    love.graphics.push()
    love.graphics.scale(c.scaleX, c.scaleY)
    love.graphics.translate(c.transX, c.transY)
    for _, shader in ipairs(c.shaders) do
        love.graphics.setShader(shader)
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(c.canvas, c.posX or 0, c.posY or 0)
    love.graphics.setShader()
    love.graphics.pop()
end

-- draw particular canvases (works same with blit but can draw multiple canvases at once)
function Canvas:drawAll(ids)
    if not ids then -- draw all canvases if no ids are assigned
        for id, _ in pairs(self.canvases) do
            self:present(id)
        end
    else
        for _, id in ipairs(ids) do
            self:present(id)
        end
    end
end

return Canvas