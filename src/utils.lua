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

return utils