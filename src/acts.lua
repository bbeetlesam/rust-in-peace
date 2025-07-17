---@class Act
---@field load fun(self:Act)?
---@field update fun(self:Act, dt:number)?
---@field draw fun(self:Act)?
---@field keypressed fun(self:Act, key:string, isrepeat:boolean)?
---@field mousepressed fun(self:Act, x:number, y:number, button:number, _:nil, presses:number)?
---@field resize fun(self:Act, w:number, h:number)?
---@field width number
---@field height number
---@field screenWidth number
---@field screenHeight number

local Act = {
    current = nil ---@type Act
}

function Act:load(name)
    local success, act_or_error = pcall(require, "src.acts." .. name)
    assert(success, "act '" .. tostring(name) .. "' is not found, fool.\n\nOriginal error:\n" .. tostring(act_or_error))

    self.id = name
    self.current = act_or_error
    if self.current.load then
        self.current:load()
    end
end

function Act:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end

function Act:draw()
    if self.current and self.current.draw then
        self.current:draw()
    end
end

function Act:keypressed(key, isrepeat)
    if self.current and self.current.keypressed then
        self.current:keypressed(key, isrepeat)
    end
end

function Act:mousepressed(x, y, button, _, presses)
    if self.current and self.current.mousepressed then
        self.current:mousepressed(x, y, button, _, presses)
    end
end

function Act:resize(w, h)
    if self.current and self.current.resize then
        self.current:resize(w, h)
    end
end

function Act:getAct()
    return self.id
end

return Act