local config = require("Modules.ConfigModule")

local ButtonModule = {}

local buttonHeight = config.data.Button.height
local buttonWidth = config.data.Button.width
local buttonSpacing = config.data.Button.padding

ButtonModule.buttons = {}

function ButtonModule.CreateButton(label, x, y, width, height, action)
    table.insert(ButtonModule.buttons, {
        label = label,
        x = x,
        y = y,
        width = width or buttonWidth,
        height = height or buttonHeight,
        action = action
    })
end

function ButtonModule.LayoutButtonsBelowBoard()
    local screenWidth = love.graphics.getWidth()
    local gridSize = config.data.Board.gridSize
    local cellSize = config.data.Board.cellSize
    local offsetY = 100
    local totalButtonWidth = #ButtonModule.buttons * buttonWidth + (#ButtonModule.buttons - 1) * buttonSpacing

    local startX = (screenWidth - totalButtonWidth) / 2
    local startY = offsetY + (gridSize * cellSize) + 70

    for i, button in ipairs(ButtonModule.buttons) do
        button.x = startX + (i - 1) * (buttonWidth + buttonSpacing)
        button.y = startY
    end
end

function ButtonModule.DrawButtons()
    for _, button in ipairs(ButtonModule.buttons) do
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
        love.graphics.printf(button.label, button.x, button.y + button.height / 4, button.width, "center")
    end
end

function ButtonModule.HandleClick(x, y)
    for _, button in ipairs(ButtonModule.buttons) do
        if x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height then
            if button.action then
                button.action()
            end
        end
    end
end

function ButtonModule.ClearButtons()
    ButtonModule.buttons = {}
end

return ButtonModule