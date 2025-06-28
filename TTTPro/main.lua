if arg[2] == "debug" then
    require("lldebugger").start()
end

local _config = require("Naught.Configuration.GameConfiguration")

local DIContainer = require("Naught.DIContainer")
local container = DIContainer.new()

-- Register dependencies
container:register("FontManager", function()
    return require("Naught.Managers.FontManager")
end)

container:register("GameState", function()
    return require("Naught.Components.GameState")
end)

container:register("ActivePiece", function()
    return require("Naught.Components.ActivePiece")
end)

container:register("FontManager", function()
    return require("Naught.Managers.FontManager")
end)

container:register("DrawBoard", function()
    return require("Naught.Graphics.DrawBoard")
end)

container:register("Logger", function()
    return require("Libraries.logger")
end)

container:register("GameStateManager", function()
    local GameState = container:resolve("GameState")
    local ActivePiece = container:resolve("ActivePiece")
    local FontManager = container:resolve("FontManager")
    local DrawBoard = container:resolve("DrawBoard")
    local Logger = container:resolve("Logger")
    local GameStateManager = require("Naught.Managers.GameStateManager")
    return GameStateManager.new(GameState, ActivePiece, FontManager, DrawBoard, Logger)
end)

container:register("GameLoop", function()
    return require("Naught.GameLoop")
end)

container:register("PlayerController", function()
    return require("Naught.Controllers.PlayerController")
end)

container:register("BotController", function()
    return require("Naught.Controllers.BotController")
end)

container:register("MainMenu", function()
    return require("Naught.UserInterface.MainMenu")
end)

container:register("ButtonModule", function()
    return require("Naught.UserInterface.ButtonModule")
end)

-- Resolve dependencies
local FontManager = container:resolve("FontManager")
local GameLoop = container:resolve("GameLoop")
local GameStateManager = container:resolve("GameStateManager")
local ButtonModule = container:resolve("ButtonModule")
local PlayerController = container:resolve("PlayerController")
local BotController = container:resolve("BotController")
local MainMenu = container:resolve("MainMenu")

-- TODO:
-- Seperate concerns (move initalization logic, game state management, and rendering into seperate modules)
-- Use a game loop structure (check that update and draw are clean and only use module calls)
-- Encapsulate(How?) gameBoard and GridOptions into a Board object

-- FIXME: #4 Two Player only plays X
-- FIXME: #5 Clicking outside of game grid counts as a turn

-- IDEA: Speed up the pace of placemnt from bots for hard gamemodes (ie. start slow and then go faster)

function love.load()
    _config.load()
    GameLoop.Init(FontManager, GameStateManager, MainMenu, _config)
end

function love.draw()
    GameLoop.Render(GameStateManager, ButtonModule)
end

function love.mousepressed(x, y, button)
    GameLoop.HandleMousePress(GameStateManager, x, y, button, ButtonModule, PlayerController, BotController)
end