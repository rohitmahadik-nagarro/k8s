using Microsoft.EntityFrameworkCore;
using k8s_assignment.Models;

namespace k8s_assignment.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Employee> Employees { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var host = Environment.GetEnvironmentVariable("DB_HOST") ?? "localhost";
                var port = Environment.GetEnvironmentVariable("DB_PORT") ?? "5432";
                var database = Environment.GetEnvironmentVariable("DB_NAME") ?? "k8s_assignment";
                var username = Environment.GetEnvironmentVariable("DB_USER") ?? "postgres";
                var password = Environment.GetEnvironmentVariable("DB_PASSWORD");
                
                if (string.IsNullOrEmpty(password))
                {
                    throw new InvalidOperationException("DB_PASSWORD environment variable is required but not set. Please set the database password as an environment variable.");
                }
                
                var connectionString = $"Host={host};Port={port};Database={database};Username={username};Password={password}";
                optionsBuilder.UseNpgsql(connectionString);
            }
        }
    }
}
