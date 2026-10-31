using backend.DataManager;
using backend.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddScoped<IDataManager, DataManager>();
builder.Services.AddHttpClient<ChronosClient>(client =>
{
    client.BaseAddress = new Uri("http://127.0.0.1:8000/");
    client.Timeout = TimeSpan.FromMinutes(3);
});
builder.Services.AddScoped<AnalysisService>();

var app = builder.Build();

app.UseHttpsRedirection();

app.MapControllers();

app.Run();
