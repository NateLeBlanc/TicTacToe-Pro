if arg[2] == "debug" then
    require("lldebugger").start()
end

local draw = require("Modules.DrawModule")
local player = require("Modules.PlayerModule")

local gridSize = 3
local cellSize = 100

local grid = {}
local GridOptions = {gridSize = gridSize, cellSize = cellSize}

function love.load()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    grid = draw.DrawBoard(screenWidth, screenHeight, GridOptions)
end

function love.draw()
    grid = player.AddColorGreen(grid, GridOptions)
end

function love.mousepressed(x, y, button)
    local MouseObj = {x = x, y = y, button = button}
    grid = player.OnClick(grid, GridOptions, MouseObj)
end