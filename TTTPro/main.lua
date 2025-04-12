if arg[2] == "debug" then
    require("lldebugger").start()
end

local draw = require("Modules.DrawModule")
local player = require("Modules.PlayerModule")

local gridSize = 3
local cellSize = 100
local currentPlayer = "X"
local winnerPlayer = nil

local gameBoard = {}
local GridOptions = {gridSize = gridSize, cellSize = cellSize}

function love.load()
    print("Game Start")
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    gameBoard = draw.CreateBoard(screenWidth, screenHeight, GridOptions)
end

function love.draw()
    draw.DrawBoard(gameBoard, GridOptions)
    draw.WinningText(winnerPlayer)
end

function love.mousepressed(x, y, button)
    if winnerPlayer then return end

    local MouseObj = {x = x, y = y, button = button}
    gameBoard, currentPlayer = player.OnClick(gameBoard, currentPlayer, GridOptions, MouseObj)
    winnerPlayer = player.CheckWin(gameBoard, GridOptions.gridSize)
end