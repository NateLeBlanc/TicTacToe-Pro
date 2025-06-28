local GameStateManager = {}

function GameStateManager.new(GameState, ActivePiece, FontManager, DrawBoard, Logger)
    local self = {}
    self.GameState = GameState
    self.ActivePiece = ActivePiece
    self.FontManager = FontManager
    self.DrawBoard = DrawBoard
    self.Logger = Logger

    local winningPlayer = nil
    local activePiece = nil
    local gameBoard = nil
    local gridOptions = nil

    function self.Init(mainMenu, config)
        self.mainMenu = mainMenu
        self.config = config

        winningPlayer = nil
        activePiece = ActivePiece.X
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        gridOptions = { gridSize = config.data.Board.gridSize, cellSize = config.data.Board.cellSize }

        if (self.GameState.currentState == nil) then
            self.currentState = self.GameState.MAINMENU
        end
        self.mainMenu.LoadMenu(screenWidth, screenHeight)
        gameBoard = self.DrawBoard.CreateBoard(screenWidth, screenHeight, gridOptions)
    end

    function self.Render(buttonModule)
        self.FontManager.GetFont()

        if self.currentState == self.GameState.MAINMENU then
            self.mainMenu.DrawMainMenu()
        elseif self.currentState == self.GameState.PLAYING then
            self.RenderBoard()
        elseif self.currentState == self.GameState.END then
            self.RenderBoard()
            buttonModule.DrawButtons()
        end
    end

    function self.HandleMousePress(x, y, button, buttonModule, playerController, botController)
        local MouseClickEvent = { x = x, y = y, button = button }

        if self.currentState == self.GameState.MAINMENU then
            self.currentState = self.mainMenu.MenuSelection(MouseClickEvent)
        elseif self.currentState == self.GameState.PLAYING then
            self.PlayingGameHandler(MouseClickEvent, buttonModule, playerController, botController)
        elseif self.currentState == self.GameState.END then
            self.EndGameHandler(MouseClickEvent, buttonModule)
        end
    end

    function self.RenderBoard()
        self.DrawBoard.DrawBoard(gameBoard, gridOptions)
        if winningPlayer then
            self.DrawBoard.WinningText(winningPlayer)
        end
    end

    function self.HandlePlayerMove(MouseClickEvent, playerController)
        if activePiece == self.ActivePiece.X then
            gameBoard, activePiece = playerController.PlayerMove(gameBoard, activePiece, gridOptions, MouseClickEvent)
        end
    end

    function self.HandleBotMove(botController)
        if self.mainMenu.isBotActive and activePiece == self.ActivePiece.O and not winningPlayer then
            gameBoard, activePiece = botController.BotMove(gameBoard, self.ActivePiece.O)
        end
    end

    function self.CheckWinCondition(playerController, buttonModule)
        if gridOptions and gridOptions.gridSize then
            winningPlayer = playerController.CheckWin(gameBoard, gridOptions.gridSize)
        else
            self.Logger.error("GameStateManager: gridSize is nil")
        end

        if winningPlayer then
            self.SetupEndState(buttonModule)
        end
    end

    function self.PlayingGameHandler(MouseClickEvent, buttonModule, playerController, botController)
        self.HandlePlayerMove(MouseClickEvent, playerController)
        self.HandleBotMove(botController)
        self.CheckWinCondition(playerController, buttonModule)
    end

    function self.EndGameHandler(MouseClickEvent, buttonModule)
        buttonModule.HandleClick(MouseClickEvent.x, MouseClickEvent.y)
    end

    function self.SetupEndState(buttonModule)
        self.currentState = self.GameState.END
        buttonModule.ClearButtons()
        buttonModule.CreateButton("Restart", nil, nil, nil, nil, function()
            self.RestartGame()
        end)
        buttonModule.CreateButton("Main Menu", nil, nil, nil, nil, function()
            self.LoadMainMenu()
        end)
        buttonModule.LayoutButtonsBelowBoard()
    end

    function self.RestartGame()
        self.currentState = self.GameState.PLAYING
        winningPlayer = nil
        activePiece = self.ActivePiece.X
        gameBoard = self.DrawBoard.CreateBoard(love.graphics.getWidth(), love.graphics.getHeight(), gridOptions)
    end

    function self.LoadMainMenu()
        self.currentState = self.GameState.MAINMENU
        winningPlayer = nil
        activePiece = self.ActivePiece.X
        love.load()
    end

    return self
end

return GameStateManager