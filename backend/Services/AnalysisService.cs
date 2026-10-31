using backend.Models;

namespace backend.Services;

public class AnalysisService
{
    private readonly ChronosClient _chronos;

    public AnalysisService(ChronosClient chronos)
    {
        _chronos = chronos;
    }

    public async Task<double[]> PredictAsync(
        double[] history,
        int horizon,
        CancellationToken cancellationToken = default)
    {
        var result = await _chronos.PredictAsync(
            history,
            horizon,
            cancellationToken
        );

        if (result is null ||
            !result.Quantiles.TryGetValue("q50", out var median))
        {
            throw new InvalidOperationException(
                "Não foi possível obter as previsões do Chronos."
            );
        }

        return median;
    }
}