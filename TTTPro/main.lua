if arg[2] == "debug" then
    require("lldebugger").start()
end

local gridSize = 3
local cellSize = 100
local grid = {}

function love.load()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local gridWidth = gridSize * cellSize
    local gridHeight = gridSize * cellSize
    local startX = (screenWidth - gridWidth) / 2
    local startY = (screenHeight - gridHeight) / 2

    for row = 1, gridSize do
        grid[row] = {}
        for col = 1, gridSize do
            grid[row][col] = {
                x = startX + (col - 1) * cellSize,
                y = startY + (row - 1) * cellSize,
                clicked = false
            }
        end
    end
end

function love.update(dt)

end

function love.draw()
    for row = 1, gridSize do
        for col = 1, gridSize do
            local cell = grid[row][col]
            -- Change color if clicked
            if cell.clicked then
                love.graphics.setColor(0, 1, 0)  -- Green if clicked
            else
                love.graphics.setColor(1, 1, 1)  -- White otherwise
            end

            -- Draw cell
            love.graphics.rectangle("fill", cell.x, cell.y, cellSize, cellSize)

            -- Draw border
            love.graphics.setColor(0, 0, 0)  -- Black border
            love.graphics.rectangle("line", cell.x, cell.y, cellSize, cellSize)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then  -- Left mouse button
        for row = 1, gridSize do
            for col = 1, gridSize do
                local cell = grid[row][col]
                if x >= cell.x and x < cell.x + cellSize and
                   y >= cell.y and y < cell.y + cellSize then
                    cell.clicked = not cell.clicked  -- Toggle click state
                end
            end
        end
    end
end