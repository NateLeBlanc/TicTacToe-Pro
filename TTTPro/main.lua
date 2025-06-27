if arg[2] == "debug" then
    require("lldebugger").start()
end

local _config = require("Naught.Configuration.GameConfiguration")
_config.load()

local _drawModule = require("Naught.Graphics.DrawBoard")
local _playerModule = require("Naught.Controllers.PlayerController")
local _botModule = require("Naught.Controllers.BotController")
local _menuModule = require("Naught.UserInterface.MainMenu")
local _buttonModule = require("Naught.UserInterface.ButtonModule")
local GameState = require("Naught.Components.GameState")
local CurrentPlayer = require("Naught.Components.CurrentPlayer")

local gameState = GameState.MENU
local gridSize = _config.data.Board.gridSize
local cellSize = _config.data.Board.cellSize
local currentPlayer = CurrentPlayer.X
local winnerPlayer = nil

local gameBoard = {}
local GridOptions = {gridSize = gridSize, cellSize = cellSize}

-- TODO:
-- Seperate concerns (move initalization logic, game state management, and rendering into seperate modules)
-- Use a game loop structure (check that update and draw are clean and only use module calls)
-- Avoid any hardcoding

-- FIXME: BUG #4

function love.load()
    winnerPlayer = nil
    currentPlayer = CurrentPlayer.X

    print("Game Start")
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    _menuModule.LoadMenu(screenWidth, screenHeight)
    gameBoard = _drawModule.CreateBoard(screenWidth, screenHeight, GridOptions)
end

function love.draw()
    if gameState == GameState.MENU then
        _menuModule.DrawMenu()
    elseif gameState == GameState.PLAYING then
        _drawModule.DrawBoard(gameBoard, GridOptions)
    elseif gameState == GameState.END then
        _drawModule.DrawBoard(gameBoard, GridOptions)
        _drawModule.WinningText(winnerPlayer)
        _buttonModule.DrawButtons()
    end
end

function love.mousepressed(x, y, button)
    local MouseObj = {x = x, y = y, button = button}

    if gameState == GameState.MENU then
        gameState = _menuModule.MenuSelection(MouseObj)
    elseif gameState == GameState.PLAYING then
        if currentPlayer == CurrentPlayer.X then
            gameBoard, currentPlayer = _playerModule.PlayerMove(gameBoard, currentPlayer, GridOptions, MouseObj)
        end
        if _menuModule.isBotActive and currentPlayer == CurrentPlayer.O and not winnerPlayer then
            gameBoard, currentPlayer = _botModule.BotMove(gameBoard, CurrentPlayer.O)
        end

        winnerPlayer = _playerModule.CheckWin(gameBoard, GridOptions.gridSize)

        if winnerPlayer then
            gameState = GameState.END

            _buttonModule.ClearButtons()
            _buttonModule.CreateButton("Restart", nil, nil, nil, nil, function()
                gameState = GameState.PLAYING
                _buttonModule.ClearButtons()
                love.load()
            end)
            _buttonModule.CreateButton("Main Menu", nil, nil, nil, nil, function()
                gameState = GameState.MENU
                _buttonModule.ClearButtons()
                love.load()
                love.draw()
            end)
            _buttonModule.LayoutButtonsBelowBoard()
        end
    elseif gameState == GameState.END then
        _buttonModule.HandleClick(MouseObj.x, MouseObj.y)
    end
end