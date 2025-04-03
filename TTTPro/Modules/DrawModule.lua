local draw = {}

function draw.DrawBoard(screenWidth, screenHeight, GridOptions)
    local grid = {}
    local gridWidth = GridOptions.gridSize * GridOptions.cellSize
    local gridHeight = GridOptions.gridSize * GridOptions.cellSize
    local centerCellX = (screenWidth - gridWidth) / 2
    local centerCellY = (screenHeight - gridHeight) / 2

    for row = 1, GridOptions.gridSize do
        grid[row] = {}
        for col = 1, GridOptions.gridSize do
            grid[row][col] = {
                x = centerCellX + (col - 1) * GridOptions.cellSize,
                y = centerCellY + (row - 1) * GridOptions.cellSize,
                clicked = false
            }
        end
    end
    return grid
end

return draw