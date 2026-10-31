using System.ComponentModel.DataAnnotations;

namespace backend.Models;

public class ForecastInput
{
    [Required]
    [MinLength(1)]
    public double[] Values { get; set; } = [];

    [Range(1, int.MaxValue)]
    public int Horizon { get; set; } = 12;
}