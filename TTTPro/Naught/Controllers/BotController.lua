local ActivePiece = require("Naught.Components.ActivePiece")
local Bot = {}

function Bot.BotMove(gameBoard, activePiece)
    local availablePositions = {}

    for row = 1, #gameBoard do
        for col = 1, #gameBoard[row] do
            if gameBoard[row][col].placedPiece == "" then
                table.insert(availablePositions, {row = row, col = col})
            end
        end
    end

    if #availablePositions > 0 then
        local choice = availablePositions[math.random(#availablePositions)]
        gameBoard[choice.row][choice.col].placedPiece = activePiece
        activePiece = (activePiece == ActivePiece.X) and ActivePiece.O or ActivePiece.X
    end

    return gameBoard, activePiece
end

return Bot