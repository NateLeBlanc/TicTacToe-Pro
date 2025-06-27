if arg[2] == "debug" then
    require("lldebugger").start()
end

local _config = require("Naught.Configuration.GameConfiguration")
_config.load()

local GameStateManager = require("Naught.Managers.GameStateManager")
local FontManager = require("Naught.Managers.FontManager")

local drawBoard = require("Naught.Graphics.DrawBoard")
local playerController = require("Naught.Controllers.PlayerController")
local botController = require("Naught.Controllers.BotController")
local mainMenu = require("Naught.UserInterface.MainMenu")
local buttonModule = require("Naught.UserInterface.ButtonModule")

-- TODO:
-- Seperate concerns (move initalization logic, game state management, and rendering into seperate modules)
-- Use a game loop structure (check that update and draw are clean and only use module calls)
-- Avoid any hardcoding
-- Move game state management logic into `GameStateManager`
-- Delegate board create and drawing to `DrawBoard`
-- Encapsulate(How?) gameBoard and GridOptions into a Board object
-- Use `GameStateManager` to hanlde transitions and delegate redering logic

-- FIXME: #4 Two Player only plays X
-- FIXME: #5 Clicking outside of game grid counts as a turn

-- IDEA: Speed up the pace of placemnt from bots for hard gamemodes (ie. start slow and then go faster)

function love.load()
    FontManager.Init()
    GameStateManager.Init(mainMenu, _config)
end

function love.draw()
    GameStateManager.Render(mainMenu, buttonModule)
end

function love.mousepressed(x, y, button)
    GameStateManager.HandleMousePress(x, y, button, mainMenu, buttonModule, playerController, botController)
end