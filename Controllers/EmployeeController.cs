using Microsoft.AspNetCore.Mvc;
using k8s_assignment.Models;
using k8s_assignment.Services;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace k8s_assignment.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeService _employeeService;
        public EmployeeController(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Employee>>> GetAll()
        {
            var employees = await _employeeService.GetAllAsync();
            return Ok(employees);
        }

        [HttpPost]
        public async Task<ActionResult<Employee>> Post(Employee employee)
        {
            var created = await _employeeService.AddAsync(employee);
            return CreatedAtAction(nameof(GetAll), new { id = created.Id }, created);
        }
    }
}
