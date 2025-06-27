local GameState = require("Naught.Components.GameState")
local ActivePiece = require("Naught.Components.ActivePiece")
local FontManager = require("Naught.Managers.FontManager")
local DrawBoard = require("Naught.Graphics.DrawBoard")

local GameStateManager = {}
local Logger = require("Libraries.logger")

local winningPlayer = nil
local activePiece = nil
local gameBoard = nil
local gridOptions = nil

function GameStateManager.Init(mainMenu, config)
    GameStateManager.mainMenu = mainMenu
    GameStateManager.config = config

    winningPlayer = nil
    activePiece = ActivePiece.X
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    gridOptions = { gridSize = config.data.Board.gridSize, cellSize = config.data.Board.cellSize }

    if(GameState.currentState == nil) then
        GameStateManager.currentState = GameState.MAINMENU
    end
    GameStateManager.mainMenu.LoadMenu(screenWidth, screenHeight)
    gameBoard = DrawBoard.CreateBoard(screenWidth, screenHeight, gridOptions)
end

function GameStateManager.Render(buttonModule)
        FontManager.GetFont()

    if GameStateManager.currentState == GameState.MAINMENU then
        GameStateManager.mainMenu.DrawMainMenu()
    elseif GameStateManager.currentState == GameState.PLAYING then
        GameStateManager.RenderBoard()
    elseif GameStateManager.currentState == GameState.END then
        GameStateManager.RenderBoard()
        buttonModule.DrawButtons()
    end
end

function GameStateManager.HandleMousePress(x, y, button, buttonModule, playerController, botController)
    local MouseClickEvent = {x = x, y = y, button = button}

    if GameStateManager.currentState == GameState.MAINMENU then
        GameStateManager.currentState = GameStateManager.mainMenu.MenuSelection(MouseClickEvent)
    elseif GameStateManager.currentState == GameState.PLAYING then
        GameStateManager.PlayingGameHandler(MouseClickEvent, buttonModule, playerController, botController)
    elseif GameStateManager.currentState == GameState.END then
        GameStateManager.EndGameHandler(MouseClickEvent, buttonModule)
    end
end

function GameStateManager.RenderBoard()
    DrawBoard.DrawBoard(gameBoard, gridOptions)
    if winningPlayer then
        DrawBoard.WinningText(winningPlayer)
    end
end

-- TODO: Break into PlayerMoveHandler and BotMoveHandler and CheckWinCondition
function GameStateManager.HandlePlayerMove(MouseClickEvent, playerController)
    if activePiece == ActivePiece.X then
        gameBoard, activePiece = playerController.PlayerMove(gameBoard, activePiece, gridOptions, MouseClickEvent)
    end
end

function GameStateManager.HandleBotMove(botController)
    if GameStateManager.mainMenu.isBotActive and activePiece == ActivePiece.O and not winningPlayer then
        gameBoard, activePiece = botController.BotMove(gameBoard, ActivePiece.O)
    end
end

function GameStateManager.CheckWinCondition(playerController, buttonModule)
    if gridOptions and gridOptions.gridSize then
        winningPlayer = playerController.CheckWin(gameBoard, gridOptions.gridSize)
    else
        Logger.error("GameStateManager: gridSize is nil")
    end

    if winningPlayer then
        GameStateManager.SetupEndState(buttonModule)
    end
end

function GameStateManager.PlayingGameHandler(MouseClickEvent, buttonModule, playerController, botController)
    GameStateManager.HandlePlayerMove(MouseClickEvent, playerController)
    GameStateManager.HandleBotMove(botController)
    GameStateManager.CheckWinCondition(playerController, buttonModule)
end

function GameStateManager.EndGameHandler(MouseClickEvent, buttonModule)
    buttonModule.HandleClick(MouseClickEvent.x, MouseClickEvent.y)
end

function GameStateManager.SetupEndState(buttonModule)
    GameStateManager.currentState = GameState.END
    buttonModule.ClearButtons()
    buttonModule.CreateButton("Restart", nil, nil, nil, nil, function()
        GameStateManager.RestartGame()
    end)
    buttonModule.CreateButton("Main Menu", nil, nil, nil, nil, function()
        GameStateManager.LoadMainMenu()
    end)
    buttonModule.LayoutButtonsBelowBoard()
end

function GameStateManager.RestartGame()
    GameStateManager.currentState = GameState.PLAYING
    winningPlayer = nil
    activePiece = ActivePiece.X
    gameBoard = DrawBoard.CreateBoard(love.graphics.getWidth(), love.graphics.getHeight(), gridOptions)
end

function GameStateManager.LoadMainMenu()
    GameStateManager.currentState = GameState.MAINMENU
    winningPlayer = nil
    activePiece = ActivePiece.X
    love.load()
end

return GameStateManager