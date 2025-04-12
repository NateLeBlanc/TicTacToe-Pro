local player = {}

function player.OnClick(gameBoard, currentPlayer, GridOptions, MouseObj)
    if MouseObj.button ~= 1 then return gameBoard, currentPlayer end

    for row = 1, GridOptions.gridSize do
        for col = 1, GridOptions.gridSize do
            local cell = gameBoard[row][col]
            if MouseObj.x >= cell.x and MouseObj.x < cell.x + GridOptions.cellSize and
                MouseObj.y >= cell.y and MouseObj.y < cell.y + GridOptions.cellSize then
                if cell.value == "" then
                    cell.value = currentPlayer
                    currentPlayer = (currentPlayer == "X") and "O" or "X"
                end
            end
        end
    end

    return gameBoard, currentPlayer
end

return player