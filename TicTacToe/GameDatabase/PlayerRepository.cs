using Npgsql;

namespace GameDatabase
{
    public class PlayerRepository
    {
        private readonly string _connectionString;

        public PlayerRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public void SaveScore(char player, bool isWin)
        {
            using var connection = new NpgsqlConnection(_connectionString);
            connection.Open();

            using var command = new NpgsqlCommand("INSERT INTO Scores (Player, IsWin, Date) VALUES (@player, @isWin, @date)", connection);
            command.Parameters.AddWithValue("player", player);
            command.Parameters.AddWithValue("isWin", isWin);
            command.Parameters.AddWithValue("date", DateTime.UtcNow);

            command.ExecuteNonQuery();
        }

        public int GetPlayerScore(char player)
        {
            using var connection = new NpgsqlConnection(_connectionString);
            connection.Open();

            using var command = new NpgsqlCommand("SELECT COUNT(*) FROM Scores WHERE Player = @player AND IsWin = true", connection);
            command.Parameters.AddWithValue("player", player);

            return Convert.ToInt32(command.ExecuteScalar());
        }
    }
}
