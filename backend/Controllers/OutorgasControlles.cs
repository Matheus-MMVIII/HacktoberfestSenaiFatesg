using backend.DataManager;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/outorgas/")]
public class OutorgasController : ControllerBase
{

    private readonly IDataManager _dataManager;

    public OutorgasController(IDataManager dataManager)
    {
        _dataManager = dataManager;
    }

    [HttpGet]
    public IActionResult Get()
    {
        string json = _dataManager.GetJson("outorgas.json");

        if (string.IsNullOrWhiteSpace(json))
            return NotFound("File not found.");

        return Content(json, "application/json");
    }
}