using k8s_assignment.Data;
using k8s_assignment.Models;
using k8s_assignment.Repositories;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace k8s_assignment.Services
{
    public class EmployeeService : IEmployeeService
    {
        private readonly IEmployeeRepository _repository;
        public EmployeeService(IEmployeeRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Employee>> GetAllAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Employee> AddAsync(Employee employee)
        {
            return await _repository.AddAsync(employee);
        }
    }
}
