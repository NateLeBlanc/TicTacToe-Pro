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

function player.CheckWin(gameBoard, gridSize)
    local function isWinningLine(values)
        local firstValue = values[1]
        if firstValue == "" then return false end
        for i = 2, #values do
            if values[i] ~= firstValue then
                return false
            end
        end
        return true
    end

    -- check row for win
    for row = 1, gridSize do
        local values = {}
        for col = 1, gridSize do
            table.insert(values, gameBoard[row][col].value)
        end
        if isWinningLine(values) then
            return values[1]
        end
    end

    for col = 1, gridSize do
        local values = {}
        for row = 1, gridSize do
            table.insert(values, gameBoard[row][col].value)
        end
        if isWinningLine(values) then
            return values[1] -- Winner
        end
    end

    -- Check top-left to bottom-right diagonal
    local diag1 = {}
    for i = 1, gridSize do
        table.insert(diag1, gameBoard[i][i].value)
    end
    if isWinningLine(diag1) then
        return diag1[1]
    end

    -- Check top-right to bottom-left diagonal
    local diag2 = {}
    for i = 1, gridSize do
        table.insert(diag2, gameBoard[i][gridSize - i + 1].value)
    end
    if isWinningLine(diag2) then
        return diag2[1]
    end

    -- Check for tie
    local isFull = true
    for row = 1, gridSize do
        for col = 1, gridSize do
            if gameBoard[row][col].value == "" then
                isFull = false
                break
            end
        end
    end

    if isFull then
        return "Tie"
    end

    return nil
end

return player