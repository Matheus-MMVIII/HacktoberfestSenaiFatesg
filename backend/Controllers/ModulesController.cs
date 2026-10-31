using backend.DataManager;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/modules/")]
public class ModulesController : ControllerBase
{

    private readonly IDataManager _dataManager;

    public ModulesController(IDataManager dataManager)
    {
        _dataManager = dataManager;
    }

    [HttpGet]
    public IActionResult Get()
    {
        string json = _dataManager.GetJson("modules.json");

        if (string.IsNullOrWhiteSpace(json))
            return NotFound("File not found.");

        return PhysicalFile(json, "application/json");
    }

    [HttpGet("map")]
    public IActionResult GetMap()
    {
        string json = _dataManager.GetJson("modules-app.json");

        if (string.IsNullOrWhiteSpace(json))
            return NotFound("File not found.");

        return PhysicalFile(json, "application/json");
    }
}