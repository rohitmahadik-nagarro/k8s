using System;
using System.ComponentModel.DataAnnotations;

namespace k8s_assignment.Models
{
    public class Employee
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public DateOnly JoiningDate { get; set; }
    }
}
