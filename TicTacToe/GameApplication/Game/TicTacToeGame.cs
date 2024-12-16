using GameApplication.Board;
using GameApplication.Player;

namespace GameApplication.Game;
public class TicTacToeGame
{
    private readonly IBoard _board;
    private readonly IPlayer _playerX;
    private readonly IPlayer _playerO;

    private IPlayer _currentPlayer;

    public TicTacToeGame()
    {
        _board = new Board.Board();
        _playerX = new Player.Player('X', _board);
        _playerO = new Player.Player('O', _board);
        _currentPlayer = _playerX;
    }

    public void Start()
    {
        for (int turn = 0; turn < 9; turn++)
        {
            _board.Draw();
            if (PlayMove(ref turn))
            {
                break;
            }
        }
    }

    private bool PlayMove(ref int turn)
    {
        Console.WriteLine($"Player {_currentPlayer}, enter your move (1-9):");
        int move = int.Parse(Console.ReadLine() ?? string.Empty);
        if (!_currentPlayer.IsValidMove(move))
        {
            Console.WriteLine("Invalid move! Try again.");
            turn--;
            return false;
        }

        _currentPlayer.MakeMove(move);
        if (_currentPlayer.CheckWin(out bool isTie))
        {
            _board.Draw();
            Console.WriteLine($"Player {_currentPlayer.Symbol} wins!");
            return true;
        }
        if (isTie)
        {
            _board.Draw();
            Console.WriteLine("It's a tie!");
            return true;
        }

        _currentPlayer = _currentPlayer == _playerX ? _playerO : _playerX;
        return false;
    }
}
