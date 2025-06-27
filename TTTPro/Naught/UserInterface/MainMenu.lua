local GameState = require("Naught.Components.GameState")

local menu = {}

local buttonWidth = 200
local buttonHeight = 50
local buttonSpacing = 20
local buttons = {}

-- TODO: 
-- Encapsulate menu logic with class or table like Menu:draw() or Menu:Update()
-- Encapsulate button creation and rendering into a Button class or utility
-- Use Dependecy Injection by passing screenWidth and screenHeight as parameters to avoid global dependecies
-- Seperate rendering and logic (ie. remove love.graphics) into a Button:draw()

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
                menu.isBotActive = true
                return GameState.PLAYING
            end
        },
        {
            label = "2 Players",
            x = centerX,
            y = startY + buttonHeight + buttonSpacing,
            width = buttonWidth,
            height = buttonHeight,
            action = function()
                menu.isBotActive = false
                return GameState.PLAYING
            end
        }
    }
end

function menu.DrawMainMenu()
    love.graphics.printf("TIC TAC TOE", 0, 100, love.graphics.getWidth(), "center")

    for _, button in ipairs(buttons) do
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
        love.graphics.printf(button.label, button.x, button.y + 15, button.width, "center")
    end
end

function menu.MenuSelection(MouseClickEvent)
    for _, button in ipairs(buttons) do
        if MouseClickEvent.x >= button.x and MouseClickEvent.x <= button.x + button.width and
        MouseClickEvent.y >= button.y and MouseClickEvent.y <= button.y + button.height then
            if button.action then
                local result = button.action()
                if result then return result end
            end
        end
    end
    return GameState.MAINMENU
end

return menu