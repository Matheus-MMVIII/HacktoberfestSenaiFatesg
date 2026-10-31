using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/dashboard/")]
public class DashboardController : ControllerBase
{

    private readonly IWebHostEnvironment _environment;

    public DashboardController(IWebHostEnvironment environment)
    {
        _environment = environment;
    }

    [HttpGet]
    public IActionResult Get()
    {
        var path = Path.Combine(
            _environment.ContentRootPath,
            "Data",
            "dashboard.json"
        );

        if (!System.IO.File.Exists(path))
            return NotFound("File not found.");

        return PhysicalFile(path, "application/json");
    }
}