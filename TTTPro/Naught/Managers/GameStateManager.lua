local GameState = require("Naught.Components.GameState")
local ActivePiece = require("Naught.Components.ActivePiece")
local FontManager = require("Naught.Managers.FontManager")
local DrawBoard = require("Naught.Graphics.DrawBoard")

local GameStateManager = {}

local winningPlayer = nil
local activePiece = nil
local gameBoard = nil
local gridOptions = nil


function GameStateManager.Init(mainMenu, config)
    print("Game Start")

    winningPlayer = nil
    activePiece = ActivePiece.X
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    gridOptions = { gridSize = config.data.Board.gridSize, cellSize = config.data.Board.cellSize }

    if(GameState.currentState == nil) then
        GameStateManager.currentState = GameState.MAINMENU
    end
    mainMenu.LoadMenu(screenWidth, screenHeight)
    gameBoard = DrawBoard.CreateBoard(screenWidth, screenHeight, gridOptions)
    print("Debug: currentPlayer initialized to", activePiece)
end

function GameStateManager.Render(mainMenu, buttonModule)
    FontManager.GetFont()

    if GameStateManager.currentState == GameState.MAINMENU then
        mainMenu.DrawMainMenu()
    elseif GameStateManager.currentState == GameState.PLAYING then
        DrawBoard.DrawBoard(gameBoard, gridOptions)
    elseif GameStateManager.currentState == GameState.END then
        DrawBoard.DrawBoard(gameBoard, gridOptions)
        DrawBoard.WinningText(winningPlayer)
        buttonModule.DrawButtons()
    end
end

function GameStateManager.HandleMousePress(x, y, button, mainMenu, buttonModule, playerController, botController)
    local MouseObj = {x = x, y = y, button = button}

    if GameStateManager.currentState == GameState.MAINMENU then
        GameStateManager.currentState = mainMenu.MenuSelection(MouseObj)
    elseif GameStateManager.currentState == GameState.PLAYING then
        GameStateManager.HandlePlayingMousePress(MouseObj, mainMenu, buttonModule, playerController, botController)
    elseif GameStateManager.currentState == GameState.END then
        GameStateManager.HandleEndScreenMousePress(MouseObj, buttonModule)
    end
end

function GameStateManager.HandlePlayingMousePress(MouseObj, mainMenu, buttonModule, playerController, botController)
    print("Debug: currentPlayer before move:", activePiece)

    if activePiece == ActivePiece.X then
        gameBoard, activePiece = playerController.PlayerMove(gameBoard, activePiece, gridOptions, MouseObj)
        print("Debug: currentPlayer after PlayerMove:", activePiece)
    end
    if mainMenu.isBotActive and activePiece == ActivePiece.O and not winningPlayer then
        gameBoard, activePiece = botController.BotMove(gameBoard, ActivePiece.O)
        print("Debug: currentPlayer after BotMove:", activePiece)
    end

    if gridOptions and gridOptions.gridSize then
        winningPlayer = playerController.CheckWin(gameBoard, gridOptions.gridSize)
    else
        print("Error in GameStateManager: gridSize is nil")
    end

    if winningPlayer then
        GameStateManager.SetupEndState(buttonModule)
    end
end

function GameStateManager.HandleEndScreenMousePress(MouseObj, buttonModule)
    buttonModule.HandleClick(MouseObj.x, MouseObj.y)
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