local GameLoop = {}

function GameLoop.Init(fontManager, gameStateManager, mainMenu, config)
    fontManager.Init()
    gameStateManager.Init(mainMenu, config)
end

function GameLoop.Render(gameStateManager, buttonModule)
    gameStateManager.Render(buttonModule)
end

function GameLoop.HandleMousePress(gameStateManager, x, y, button, buttonModule, playerController, botController)
    gameStateManager.HandleMousePress(x, y, button, buttonModule, playerController, botController)
end

return GameLoop