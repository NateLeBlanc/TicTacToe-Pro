if arg[2] == "debug" then
    require("lldebugger").start()
end

local config = require("Modules.ConfigModule")
config.load()

local draw = require("Modules.DrawModule")
local player = require("Modules.PlayerModule")
local menu = require("Modules.MenuModule")
local buttons = require("Modules.ButtonModule")
local GameState = require("ValueTables.GameState")
local CurrentPlayer = require("ValueTables.CurrentPlayer")

local gameState = GameState.MENU
local gridSize = config.data.Board.gridSize
local cellSize = config.data.Board.cellSize
local currentPlayer = CurrentPlayer.X
local winnerPlayer = nil

local gameBoard = {}
local GridOptions = {gridSize = gridSize, cellSize = cellSize}

function love.load()
    winnerPlayer = nil
    currentPlayer = CurrentPlayer.X

    print("Game Start")
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    menu.LoadMenu(screenWidth, screenHeight)
    gameBoard = draw.CreateBoard(screenWidth, screenHeight, GridOptions)
end

function love.draw()
    if gameState == GameState.MENU then
        menu.DrawMenu()
    elseif gameState == GameState.PLAYING then
        draw.DrawBoard(gameBoard, GridOptions)
    elseif gameState == GameState.END then
        draw.DrawBoard(gameBoard, GridOptions)
        draw.WinningText(winnerPlayer)
        buttons.DrawButtons()
    end
end

function love.mousepressed(x, y, button)
    local MouseObj = {x = x, y = y, button = button}

    if gameState == GameState.MENU then
        gameState = menu.MenuSelection(MouseObj)
    elseif gameState == GameState.PLAYING then
        gameBoard, currentPlayer = player.SelectCell(gameBoard, currentPlayer, GridOptions, MouseObj)
        winnerPlayer = player.CheckWin(gameBoard, GridOptions.gridSize)

        if winnerPlayer then
            gameState = GameState.END

            buttons.ClearButtons()
            buttons.CreateButton("Restart", nil, nil, nil, nil, function()
                gameState = GameState.PLAYING
                buttons.ClearButtons()
                love.load()
            end)
            buttons.CreateButton("Main Menu", nil, nil, nil, nil, function()
                gameState = GameState.MENU
                buttons.ClearButtons()
                love.load()
                love.draw()
            end)
            buttons.LayoutButtonsBelowBoard()
        end
    elseif gameState == GameState.END then
        buttons.HandleClick(MouseObj.x, MouseObj.y)
    end
end