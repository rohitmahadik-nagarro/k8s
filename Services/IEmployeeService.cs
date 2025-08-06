using k8s_assignment.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace k8s_assignment.Services
{
    public interface IEmployeeService
    {
        Task<IEnumerable<Employee>> GetAllAsync();
        Task<Employee> AddAsync(Employee employee);
    }
}
