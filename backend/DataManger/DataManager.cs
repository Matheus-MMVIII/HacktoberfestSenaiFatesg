namespace backend.DataManager;

public class DataManager : IDataManager
{
    private readonly IWebHostEnvironment _environment;

    public DataManager(IWebHostEnvironment environment)
    {
        _environment = environment;
    }
    
    public string GetJson(string fileName)
    {
        string path = Path.Combine(
            _environment.ContentRootPath,
            "Data",
            fileName
        );

        if (!System.IO.File.Exists(path))
            return "";

        return File.ReadAllText(path);
    }
}