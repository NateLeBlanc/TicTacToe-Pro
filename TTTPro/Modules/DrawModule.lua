local draw = {}

function draw.DrawSpace(screenWidth, screenHeight, boardWidth, boardHeight)
    local screenCenterX = (screenWidth - boardWidth) / 2
    local screenCenterY = (screenHeight - boardHeight) / 2

    return {screenCenterX, screenCenterY}
end

return draw