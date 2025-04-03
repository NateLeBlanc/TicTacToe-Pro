local movementModule = {}

function movementModule.MoveRight(positionX, dt)
    return positionX + 50 * dt
end

function movementModule.MoveLeft(positionX, dt)
    return positionX - 50 * dt
end

function movementModule.MoveUp(positionY, dt)
    return positionY - 50 * dt
end

function movementModule.MoveDown(positionY, dt)
    return positionY + 50 * dt
end

return movementModule