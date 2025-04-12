local menu = {}

local buttonWidth = 200
local buttonHeight = 50
local buttonSpacing = 20
local buttons = {}

function menu.LoadMenu(screenWidth, screenHeight)
    local totalHeight = (buttonHeight * 2) + buttonSpacing
    local startY = (screenHeight - totalHeight) / 2
    local centerX = (screenWidth - buttonWidth) / 2

    buttons = {
        {
            label = "1 Player",
            x = centerX,
            y = startY,
            width = buttonWidth,
            height = buttonHeight,
            action = function()
                print("1 Player selected") -- Placeholder
            end
        },
        {
            label = "2 Players",
            x = centerX,
            y = startY + buttonHeight + buttonSpacing,
            width = buttonWidth,
            height = buttonHeight,
            action = function()
                return "playing"
            end
        }
    }
end

function menu.DrawMenu()
    love.graphics.printf("TIC TAC TOE", 0, 100, love.graphics.getWidth(), "center")

    for _, btn in ipairs(buttons) do
        love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
        love.graphics.printf(btn.label, btn.x, btn.y + 15, btn.width, "center")
    end
end

function menu.MenuSelection(MouseObj)
    for _, btn in ipairs(buttons) do
        if MouseObj.x >= btn.x and MouseObj.x <= btn.x + btn.width and
        MouseObj.y >= btn.y and MouseObj.y <= btn.y + btn.height then
            if btn.action then
                local result = btn.action()
                if result then return result end
            end
        end
    end
    return "menu"
end

return menu