using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/modules/")]
public class ModulesController : ControllerBase
{

    private readonly IWebHostEnvironment _environment;

    public ModulesController(IWebHostEnvironment environment)
    {
        _environment = environment;
    }

    [HttpGet]
    public IActionResult Get()
    {
        var path = Path.Combine(
            _environment.ContentRootPath,
            "Data",
            "modules.json"
        );

        if (!System.IO.File.Exists(path))
            return NotFound("File not found.");

        return PhysicalFile(path, "application/json");
    }

    [HttpGet("map")]
    public IActionResult GetMap()
    {
        var path = Path.Combine(
            _environment.ContentRootPath,
            "Data",
            "modules-map.json"
        );

        if (!System.IO.File.Exists(path))
            return NotFound("File not found.");

        return PhysicalFile(path, "application/json");
    }
}