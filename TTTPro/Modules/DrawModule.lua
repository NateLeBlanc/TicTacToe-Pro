local config = require("Modules.ConfigModule")
config.load()

local draw = {}

function draw.CreateBoard(screenWidth, screenHeight, GridOptions)
    local gameBoard = {}
    local gridWidth = GridOptions.gridSize * GridOptions.cellSize
    local gridHeight = GridOptions.gridSize * GridOptions.cellSize
    local startCellX = (screenWidth - gridWidth) / 2
    local startCellY = (screenHeight - gridHeight) / 2

    for row = 1, GridOptions.gridSize do
        gameBoard[row] = {}
        for col = 1, GridOptions.gridSize do
            gameBoard[row][col] = {
                x = startCellX + (col - 1) * GridOptions.cellSize,
                y = startCellY + (row - 1) * GridOptions.cellSize,
                value = "" -- Holds 'X', 'O', or ''
            }
        end
    end
    return gameBoard
end

function draw.DrawBoard(gameBoard, GridOptions)
    for row = 1, GridOptions.gridSize do
        for col = 1, GridOptions.gridSize do
            local cell = gameBoard[row][col]

            -- Draw cell border
            love.graphics.rectangle("line", cell.x, cell.y, GridOptions.cellSize, GridOptions.cellSize)

            -- Draw X or O centered
            if cell.value ~= "" then
                local font = love.graphics.getFont()
                local textWidth = font:getWidth(cell.value)
                local textHeight = font:getHeight()

                love.graphics.print(
                    cell.value,
                    cell.x + (GridOptions.cellSize - textWidth) / 2,
                    cell.y + (GridOptions.cellSize - textHeight) / 2
                )
            end
        end
    end
end

function draw.WinningText(winnerPlayer)
    if winnerPlayer == "Tie" then
        love.graphics.printf("It's a tie!", 0, 20, love.graphics.getWidth(), "center")
    elseif winnerPlayer then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Winner: " .. winnerPlayer, 0, 20, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1)
    end
end

function draw.DrawGameOverButtons(screenWidth, screenHeight)
    local buttonWidth = config.data.Button.width
    local buttonHeight = config.data.Button.height
    local buttonPadding = config.data.Button.padding

    local centerX = screenWidth / 2
    local startY = screenHeight / 2 + 60

    love.graphics.setColor(0.2, 0.6, 0.9)
    love.graphics.rectangle("fill", centerX - buttonWidth - buttonPadding / 2, startY, buttonWidth, buttonHeight)
    love.graphics.rectangle("fill", centerX + buttonPadding / 2, startY, buttonWidth, buttonHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Main Menu", centerX - buttonWidth - buttonPadding / 2, startY + 15, buttonWidth, "center")
    love.graphics.printf("Restart", centerX + buttonPadding / 2, startY + 15, buttonWidth, "center")
end

return draw