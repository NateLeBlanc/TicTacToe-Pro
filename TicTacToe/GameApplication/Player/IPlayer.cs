namespace GameApplication.Player;
public interface IPlayer
{
    char Symbol { get; }
    bool IsValidMove(int move);
    void MakeMove(int move);
    bool CheckWin(out bool isTie);
}
