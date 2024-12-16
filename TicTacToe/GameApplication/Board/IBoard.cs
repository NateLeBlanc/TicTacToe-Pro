namespace GameApplication.Board;
public interface IBoard
{
    void Draw();
    char[,] GetBoardState();
    void UpdateBoard(int move, char player);
    bool IsFull();
}
