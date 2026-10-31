using backend.DataManager;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddScoped<IDataManager, DataManager>();

var app = builder.Build();

app.UseHttpsRedirection();

app.MapControllers();

app.Run();
