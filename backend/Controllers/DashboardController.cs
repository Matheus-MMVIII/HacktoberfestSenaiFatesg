using Microsoft.AspNetCore.Mvc;

namespace MinhaApi.Controllers;

[ApiController]
[Route("api/dashboard/")]
public class DashboardController : ControllerBase
{
    [HttpGet]
    public IActionResult Get([FromQuery] DateOnly? data)
    {
        if (data == null)
        {
            return BadRequest("The date field is mandatory.");
        }

        return Ok(new
        {
            Data = data.Value,
            TotalVendas = 1500.00m,
            QuantidadePedidos = 15
        });
    }
}