local player = {}

function player.AddColorGreen(grid, GridOptions)
    for row = 1, GridOptions.gridSize do
        for col = 1, GridOptions.gridSize do
            local cell = grid[row][col]
            -- Change color if clicked
            if cell.clicked then
                love.graphics.setColor(0, 1, 0)  -- Green if clicked
            else
                love.graphics.setColor(1, 1, 1)  -- White otherwise
            end

            love.graphics.rectangle("fill", cell.x, cell.y, GridOptions.cellSize, GridOptions.cellSize)

            love.graphics.setColor(0, 0, 0)  -- Black border
            love.graphics.rectangle("line", cell.x, cell.y, GridOptions.cellSize, GridOptions.cellSize)
        end
    end
    return grid
end

function player.OnClick(grid, GridOptions, MouseObj)
    if not MouseObj or not MouseObj.x or not MouseObj.y or not MouseObj.button then
        return grid  -- Return early if MouseObj is invalid
    end

    if MouseObj.button == 1 then  -- Left mouse button
        for row = 1, GridOptions.gridSize do
            for col = 1, GridOptions.gridSize do
                local cell = grid[row][col]
                if MouseObj.x >= cell.x and MouseObj.x < cell.x + GridOptions.cellSize and
                   MouseObj.y >= cell.y and MouseObj.y < cell.y + GridOptions.cellSize then
                    cell.clicked = not cell.clicked  -- Toggle click state
                end
            end
        end
    end

    return grid
end

return player