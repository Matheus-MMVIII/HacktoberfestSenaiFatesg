using Microsoft.AspNetCore.Mvc;
using backend.Models;
using backend.Services;

namespace backend.Controllers;

[ApiController]
[Route("api/analysis")]
public class AnalysisController : ControllerBase
{
    private readonly AnalysisService _analysisService;

    public AnalysisController(AnalysisService analysisService)
    {
        _analysisService = analysisService;
    }

    [HttpPost("forecast")]
    public async Task<ActionResult<ForecastOutput>> Forecast(
        [FromBody] ForecastInput input,
        CancellationToken cancellationToken)
    {
        var predictions = await _analysisService.PredictAsync(
            input.Values,
            input.Horizon,
            cancellationToken
        );

        return Ok(new ForecastOutput
        {
            Predictions = predictions
        });
    }
}