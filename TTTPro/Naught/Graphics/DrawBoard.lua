local _config = require("Naught.Configuration.GameConfiguration")
_config.load()

local FontManager = require("Naught.Managers.FontManager")

local DrawBoard = {}

function DrawBoard.CreateBoard(screenWidth, screenHeight, GridOptions)
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
                placedPiece = "" -- Holds 'X', 'O', or ''
            }
        end
    end
    return gameBoard
end

function DrawBoard.DrawBoard(gameBoard, GridOptions)
    for row = 1, GridOptions.gridSize do
        for col = 1, GridOptions.gridSize do
            local cell = gameBoard[row][col]

            print("Rectangle values:", cell.x, cell.y, GridOptions.cellSize, GridOptions.cellSize)
            -- Draw cell border
            love.graphics.rectangle("line", cell.x, cell.y, GridOptions.cellSize, GridOptions.cellSize)

            if not cell.placedPiece then
                print("Warning: cell.value is nil at row:", row, "col:", col)
            end

            -- Draw X or O centered
            if cell.placedPiece and cell.placedPiece ~= "" then
                local font = FontManager.GetFont()
                local textWidth = font:getWidth(cell.placedPiece or "")
                local textHeight = font:getHeight()

                love.graphics.print(
                    cell.placedPiece,
                    cell.x + (GridOptions.cellSize - textWidth) / 2,
                    cell.y + (GridOptions.cellSize - textHeight) / 2
                )
            end
        end
    end
end

function DrawBoard.WinningText(winnerPlayer)
    if winnerPlayer == "Tie" then
        love.graphics.printf("It's a tie!", 0, 20, love.graphics.getWidth(), "center")
    elseif winnerPlayer then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Winner: " .. winnerPlayer, 0, 20, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1)
    end
end

return DrawBoard