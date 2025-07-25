local utils = {}

function utils.hexToRGB(hex)
    hex = hex:gsub("#","")
    local r, g, b, a

    if #hex == 3 then -- #rgb
        r = tonumber(hex:sub(1,1):rep(2), 16)
        g = tonumber(hex:sub(2,2):rep(2), 16)
        b = tonumber(hex:sub(3,3):rep(2), 16)
        a = 255
    elseif #hex == 6 then -- #rrggbb
        r = tonumber(hex:sub(1,2), 16)
        g = tonumber(hex:sub(3,4), 16)
        b = tonumber(hex:sub(5,6), 16)
        a = 255
    elseif #hex == 8 then -- #aarrggbb
        a = tonumber(hex:sub(1,2), 16)
        r = tonumber(hex:sub(3,4), 16)
        g = tonumber(hex:sub(5,6), 16)
        b = tonumber(hex:sub(7,8), 16)
    else -- fallback to white
        r, g, b, a = 255, 255, 255, 255
    end

    return (r or 0)/255, (g or 0)/255, (b or 0)/255, (a or 255)/255
end

function utils.round(n)
    if n >= 0 then
        return math.floor(n + 0.5)
    else
        return math.ceil(n - 0.5)
    end
end

function utils.isValueAround(val, min, max)
    return val >= min and val <= max
end

-- execute once by giving a unique key for each func
utils.executedKeys = {}
function utils.executeOnce(key, func)
    if not utils.executedKeys[key] then
        utils.executedKeys[key] = true -- store the key id
        func()
    end
end

function utils.lerp(a, b, t)
    return a + (b - a) * t
end

-- calculates the linear parameter t that produces a value within the range [a, b].
function utils.inverseLerp(a, b, value)
    if a == b then return 0 end
    return (value - a) / (b - a)
end

return utils