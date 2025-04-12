if arg[2] == "debug" then
    require("lldebugger").start()
end

local config = require("Modules.ConfigModule")
config.load()

local draw = require("Modules.DrawModule")
local player = require("Modules.PlayerModule")
local menu = require("Modules.MenuModule")

local gameState = config.data.gameState
local gridSize = config.data.Board.gridSize
local cellSize = config.data.Board.cellSize
local currentPlayer = config.data.Game.currentPlayer
local winnerPlayer = nil

local gameBoard = {}
local GridOptions = {gridSize = gridSize, cellSize = cellSize}

function love.load()
    print("Game Start")
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    menu.LoadMenu(screenWidth, screenHeight)
    gameBoard = draw.CreateBoard(screenWidth, screenHeight, GridOptions)
end

function love.draw()
    if gameState == "menu" then
        menu.DrawMenu()
    elseif gameState == "playing" then
        draw.DrawBoard(gameBoard, GridOptions)
        draw.WinningText(winnerPlayer)
    end
end

function love.mousepressed(x, y, button)
    local MouseObj = {x = x, y = y, button = button}

    if gameState == "menu" then
        gameState = menu.MenuSelection(MouseObj)
    elseif gameState == "playing" then
        if winnerPlayer then return end

        gameBoard, currentPlayer = player.SelectCell(gameBoard, currentPlayer, GridOptions, MouseObj)
        winnerPlayer = player.CheckWin(gameBoard, GridOptions.gridSize)
    end

end