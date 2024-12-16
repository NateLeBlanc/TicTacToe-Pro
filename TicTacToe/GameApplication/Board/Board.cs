namespace GameApplication.Board;
public class Board : IBoard
{
    private readonly char[,] _board =
    {
        {'1', '2', '3'},
        {'4', '5', '6'},
        {'7', '8', '9'}
    };

    public void Draw()
    {
        Console.Clear();
        Console.WriteLine("  1 2 3");
        Console.WriteLine("1 " + _board[0, 0] + "|" + _board[0, 1] + "|" + _board[0, 2]);
        Console.WriteLine("  -----");
        Console.WriteLine("2 " + _board[1, 0] + "|" + _board[1, 1] + "|" + _board[1, 2]);
        Console.WriteLine("  -----");
        Console.WriteLine("3 " + _board[2, 0] + "|" + _board[2, 1] + "|" + _board[2, 2]);
    }

    public char[,] GetBoardState()
    {
        return _board;
    }

    public void UpdateBoard(int move, char player)
    {
        _board[(move - 1) / 3, (move - 1) % 3] = player;
    }

    public bool IsFull()
    {
        foreach (char cell in _board)
        {
            if (cell != 'X' && cell != 'O')
            {
                return false;
            }
        }
        return true;
    }
}
