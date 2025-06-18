if arg[2] == "debug" then
    require("lldebugger").start()
end

local _config = require("Modules.ConfigModule")
_config.load()

local _draw = require("Modules.DrawModule")
local _player = require("Modules.PlayerModule")
local _bot = require("Modules.BotModule")
local _menu = require("Modules.MenuModule")
local _buttons = require("Modules.ButtonModule")
local GameState = require("ValueTables.GameState")
local CurrentPlayer = require("ValueTables.CurrentPlayer")

local gameState = GameState.MENU
local gridSize = _config.data.Board.gridSize
local cellSize = _config.data.Board.cellSize
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

    _menu.LoadMenu(screenWidth, screenHeight)
    gameBoard = _draw.CreateBoard(screenWidth, screenHeight, GridOptions)
end

function love.draw()
    if gameState == GameState.MENU then
        _menu.DrawMenu()
    elseif gameState == GameState.PLAYING then
        _draw.DrawBoard(gameBoard, GridOptions)
    elseif gameState == GameState.END then
        _draw.DrawBoard(gameBoard, GridOptions)
        _draw.WinningText(winnerPlayer)
        _buttons.DrawButtons()
    end
end

function love.mousepressed(x, y, button)
    local MouseObj = {x = x, y = y, button = button}

    if gameState == GameState.MENU then
        gameState = _menu.MenuSelection(MouseObj)
    elseif gameState == GameState.PLAYING then
        if currentPlayer == CurrentPlayer.X then
            gameBoard, currentPlayer = _player.PlayerMove(gameBoard, currentPlayer, GridOptions, MouseObj)
        end
        if _menu.isBotActive and currentPlayer == CurrentPlayer.O and not winnerPlayer then
            gameBoard, currentPlayer = _bot.BotMove(gameBoard, CurrentPlayer.O)
        end

        winnerPlayer = _player.CheckWin(gameBoard, GridOptions.gridSize)

        if winnerPlayer then
            gameState = GameState.END

            _buttons.ClearButtons()
            _buttons.CreateButton("Restart", nil, nil, nil, nil, function()
                gameState = GameState.PLAYING
                _buttons.ClearButtons()
                love.load()
            end)
            _buttons.CreateButton("Main Menu", nil, nil, nil, nil, function()
                gameState = GameState.MENU
                _buttons.ClearButtons()
                love.load()
                love.draw()
            end)
            _buttons.LayoutButtonsBelowBoard()
        end
    elseif gameState == GameState.END then
        _buttons.HandleClick(MouseObj.x, MouseObj.y)
    end
end