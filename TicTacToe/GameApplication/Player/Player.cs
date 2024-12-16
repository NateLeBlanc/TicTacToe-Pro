using GameApplication.Board;

namespace GameApplication.Player;
internal class Player(char symbol, IBoard board) : IPlayer
{
    private readonly IBoard _board = board;

    public char Symbol { get; } = symbol;

    public bool IsValidMove(int move)
    {
        char[,] boardState = _board.GetBoardState();
        if (move < 1 || move > 9)
        {
            return false;
        }
        return boardState[(move - 1) / 3, (move - 1) % 3] != 'X' && boardState[(move - 1) / 3, (move - 1) % 3] != 'O';
    }

    public void MakeMove(int move)
    {
        _board.UpdateBoard(move, Symbol);
    }

    public bool CheckWin(out bool isTie)
    {
        char[,] boardState = _board.GetBoardState();
        for (int i = 0; i < 3; i++)
        {
            if ((boardState[i, 0] == boardState[i, 1] && boardState[i, 1] == boardState[i, 2]) ||
                (boardState[0, i] == boardState[1, i] && boardState[1, i] == boardState[2, i]))
            {
                isTie = false;
                return true;
            }
        }

        if ((boardState[0, 0] == boardState[1, 1] && boardState[1, 1] == boardState[2, 2]) ||
            (boardState[0, 2] == boardState[1, 1] && boardState[1, 1] == boardState[2, 0]))
        {
            isTie = false;
            return true;
        }

        isTie = _board.IsFull();
        return false;
    }
}
