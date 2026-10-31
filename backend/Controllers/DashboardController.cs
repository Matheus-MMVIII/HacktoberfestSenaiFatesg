using backend.DataManager;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/dashboard/")]
public class DashboardController : ControllerBase
{

    private readonly IDataManager _dataManager;

    public DashboardController(IDataManager dataManager)
    {
        _dataManager = dataManager;
    }

    [HttpGet]
    public IActionResult Get()
    {
        string json = _dataManager.GetJson("dashboard.json");

        if (string.IsNullOrWhiteSpace(json))
            return NotFound("File not found.");

        return Content(json, "application/json");
    }
}