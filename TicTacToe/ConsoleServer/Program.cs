using GameApplication.Game;

namespace ConsoleServer;
public class Program
{
    public static void Main()
    {
        var game = new TicTacToeGame();
        game.Start();
    }
}

// TODO: Add a score board with a database to keep track of the players' names, win, and loses.
// TODO: Add a bot / AI
// TODO: Add difficulty to the bot
// TODO: Make an adaptable board size
// TODO: Make a random board size mode where the objective is still to get 3 in a row but some cells are blocked
// TODO: Make a hidden board so that the display isn't shown until the end of the game. invalid moves aren't recorded
// TODO: Give recorded players elo rankings
// TODO: If AI is implemented, make it so that the AI learns from its loses and other players games and strategies
