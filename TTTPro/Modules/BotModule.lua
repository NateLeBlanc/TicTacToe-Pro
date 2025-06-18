local CurrentPlayer = require("ValueTables.CurrentPlayer")
local Bot = {}

function Bot.BotMove(gameBoard, currentPlayer)
    local availablePositions = {}

    for row = 1, #gameBoard do
        for col = 1, #gameBoard[row] do
            if gameBoard[row][col].value == "" then
                table.insert(availablePositions, {row = row, col = col})
            end
        end
    end

    if #availablePositions > 0 then
        local choice = availablePositions[math.random(#availablePositions)]
        gameBoard[choice.row][choice.col].value = currentPlayer
        currentPlayer = (currentPlayer == CurrentPlayer.X) and CurrentPlayer.O or CurrentPlayer.X
    end

    return gameBoard, currentPlayer
end

return Bot