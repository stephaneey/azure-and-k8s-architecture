// See https://aka.ms/new-console-template for more information
using Microsoft.Data.SqlClient;
using System.Diagnostics;


string ConnectionString = @"Server=" + args[0] + ";"
       + "Encrypt=True; Database=" + args[1] + ";"
       + "User Id=sqladminuser; Password=P@ssw0rd123!;pooling=true;";
Console.WriteLine(ConnectionString);

//creates the default table if it doesn't exist
using var connection = new SqlConnection(ConnectionString); 
await connection.OpenAsync(); 
var cmd = connection.CreateCommand(); 
cmd.CommandText = @" IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'atable' AND schema_id = SCHEMA_ID('dbo') ) BEGIN CREATE TABLE dbo.atable ( Id INT IDENTITY(1,1) PRIMARY KEY, whatever NVARCHAR(100) ); END "; await cmd.ExecuteNonQueryAsync();

while (true)
{
    try
    {
        Stopwatch stopwatch = new Stopwatch();

        stopwatch.Start();

        Console.WriteLine($"Row count: {ExecuteQuery("select count(*) from atable", ConnectionString)} {stopwatch.ElapsedMilliseconds}");
        ExecuteCommnd("insert into atable values('a value')", ConnectionString);
        stopwatch.Stop();


    }
    catch (Exception ex)
    {
        Console.WriteLine(ex.ToString());
    }
    Thread.Sleep(5000);
}


static int ExecuteQuery(string query, string cs)
{
    using (SqlConnection conn = new SqlConnection(cs))
    {
        conn.Open();


        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            return (int)cmd.ExecuteScalar();
        }
    }
}

static void ExecuteCommnd(string command, string cs)
{
    using (SqlConnection conn = new SqlConnection(cs))
    {
        conn.Open();


        using (SqlCommand cmd = new SqlCommand(command, conn))
        {
            cmd.ExecuteNonQuery();
        }
    }
}