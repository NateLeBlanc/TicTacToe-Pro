local CurrentPlayer = require("Naught.Components.CurrentPlayer")

local player = {}

local generateLineCoords
local isWinningLine

function player.PlayerMove(gameBoard, currentPlayer, GridOptions, MouseObj)
    if MouseObj.button ~= 1 then return gameBoard, currentPlayer end

    for row = 1, GridOptions.gridSize do
        for col = 1, GridOptions.gridSize do
            local cell = gameBoard[row][col]
            if MouseObj.x >= cell.x and MouseObj.x < cell.x + GridOptions.cellSize and
                MouseObj.y >= cell.y and MouseObj.y < cell.y + GridOptions.cellSize then
                if cell.value == "" then
                    cell.value = currentPlayer
                    currentPlayer = (currentPlayer == CurrentPlayer.X) and CurrentPlayer.O or CurrentPlayer.X
                end
            end
        end
    end

    return gameBoard, currentPlayer
end

function player.CheckWin(gameBoard, gridSize)
    for i = 1, gridSize do
        -- Check row
        local rowCoords = generateLineCoords("row", i, gridSize)
        if isWinningLine(gameBoard, rowCoords) then
            return gameBoard[i][1].value
        end

        -- Check column
        local colCoords = generateLineCoords("col", i, gridSize)
        if isWinningLine(gameBoard, colCoords) then
            return gameBoard[1][i].value
        end
    end

    -- Diagonals
    local diag1 = generateLineCoords("diag1", nil, gridSize)
    if isWinningLine(gameBoard, diag1) then
        return gameBoard[1][1].value
    end

    local diag2 = generateLineCoords("diag2", nil, gridSize)
    if isWinningLine(gameBoard, diag2) then
        return gameBoard[1][gridSize].value
    end

    -- Tie check
    for row = 1, gridSize do
        for col = 1, gridSize do
            if gameBoard[row][col].value == "" then
                return nil
            end
        end
    end

    return "Tie"
end

isWinningLine = function(gameBoard, coords)
    local firstValue = gameBoard[coords[1][1]][coords[1][2]].value
    if firstValue == "" then return false end

    for i = 2, #coords do
        local row, col = coords[i][1], coords[i][2]
        if gameBoard[row][col].value ~= firstValue then
            return false
        end
    end
    return true
end

generateLineCoords = function(lineType, index, gridSize)
    local coords = {}

    if lineType == "row" then
        for col = 1, gridSize do
            table.insert(coords, {index, col})
        end
    elseif lineType == "col" then
        for row = 1, gridSize do
            table.insert(coords, {row, index})
        end
    elseif lineType == "diag1" then
        for i = 1, gridSize do
            table.insert(coords, {i, i})
        end
    elseif lineType == "diag2" then
        for i = 1, gridSize do
            table.insert(coords, {i, gridSize - i + 1})
        end
    end

    return coords
end

return player