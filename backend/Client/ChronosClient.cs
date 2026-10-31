
using System.Net.Http.Json;

public sealed record ForecastRequest(
    double[] Values,
    int Horizon
);

public sealed record ForecastResponse(
    int Horizon,
    Dictionary<string, double[]> Quantiles
);

public sealed class ChronosClient
{
    private readonly HttpClient _http;

    public ChronosClient(HttpClient http)
    {
        _http = http;
    }

    public async Task<ForecastResponse?> PredictAsync(
        double[] values,
        int horizon,
        CancellationToken cancellationToken = default)
    {
        using var response = await _http.PostAsJsonAsync(
            "forecast",
            new ForecastRequest(values, horizon),
            cancellationToken
        );

        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<ForecastResponse>(
            cancellationToken: cancellationToken
        );
    }
}
