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
