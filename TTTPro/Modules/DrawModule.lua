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

return draw