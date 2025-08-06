using k8s_assignment.Models;
using Microsoft.EntityFrameworkCore;

namespace k8s_assignment.Data
{
    public static class DbInitializer
    {
        public static void Initialize(AppDbContext context)
        {
            // Only run migrations if using a relational database
            if (context.Database.IsRelational())
            {
                context.Database.Migrate();
            }

            if (context.Employees.Any())
            {
                return; // DB has been seeded
            }

            var employees = new Employee[]
            {
                new Employee { Name = "Alice", JoiningDate = new DateOnly(2011, 1, 1) },
                new Employee { Name = "Bob", JoiningDate = new DateOnly(2012, 2, 2) },
                new Employee { Name = "Charlie", JoiningDate = new DateOnly(2013, 3, 3) },
                new Employee { Name = "Diana", JoiningDate = new DateOnly(2014, 4, 4) },
                new Employee { Name = "Eve", JoiningDate = new DateOnly(2015, 5, 5) }
            };

            context.Employees.AddRange(employees);
            context.SaveChanges();
        }
    }
}
