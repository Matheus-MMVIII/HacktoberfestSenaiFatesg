
from fastapi import FastAPI
from pydantic import BaseModel, Field
from chronos import BaseChronosPipeline
import torch

app = FastAPI(title="Chronos Forecast API")

# Carrega o modelo uma única vez, na inicialização.
pipeline = BaseChronosPipeline.from_pretrained(
    "amazon/chronos-bolt-base",
    device_map="cpu"
)


class ForecastRequest(BaseModel):
    values: list[float] = Field(min_length=1)
    horizon: int = Field(gt=0)


@app.post("/forecast")
def forecast(request: ForecastRequest):

    # Converte os valores históricos para tensor.
    context = torch.tensor(
        request.values,
        dtype=torch.float32
    )

    # Executa a previsão.
    predictions = pipeline.predict(
        context,
        prediction_length=request.horizon
    )

    # Formato: [quantis, períodos futuros].
    predictions = predictions[0]

    # Organiza os resultados por quantil.
    quantiles = {
        f"q{int(level * 100)}": predictions[index].tolist()
        for index, level in enumerate(pipeline.quantiles)
    }

    return {
        "horizon": request.horizon,
        "quantiles": quantiles
    }
