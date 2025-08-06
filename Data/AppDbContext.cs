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
                // Use PostgreSQL if no options are configured (for migrations)
                optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=k8s_assignment;Username=postgres;Password=yourpassword");
            }
        }
    }
}
