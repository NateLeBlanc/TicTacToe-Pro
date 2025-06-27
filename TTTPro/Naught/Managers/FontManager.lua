local FontManager = {}

local defaultFontSize = 14
local defaultFont = nil

function FontManager.Init()
    defaultFont = love.graphics.newFont(defaultFontSize)
    love.graphics.setFont(defaultFont)
end

function FontManager.GetFont()
    if not love.graphics.getFont() then
        love.graphics.setFont(defaultFont)
    end
    return love.graphics.getFont()
end

return FontManager