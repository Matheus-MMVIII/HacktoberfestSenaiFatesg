# 1. Arquitetura das requisições

![[Pasted image 20261031124540.png|539]]
# 2. Primeira requisição – Dashboard

`GET /api/dashboard?data=2026-10-31`

Responsável por entregar os indicadores consolidados.

```json

{
  "data_referencia": "2026-10-31",
  "resumo": {
    "total_outorgas": 2,
    "total_modulos": 4,
    "modulos_online": 4,
    "modulos_captando": 1,
    "volume_autorizado_dia": 30000,
    "volume_captado_dia": 14500,
    "volume_disponivel_dia": 15500,
    "percentual_utilizado": 48.33
  },
  "captacao_por_outorga": [
    {
      "outorga_id": "uuid-outorga-001",
      "numero_outorga": "OUT-001",
      "rio": "RIO-ARAGUAIA",
      "volume_autorizado_dia": 10000,
      "volume_captado_dia": 6500,
      "volume_disponivel_dia": 3500,
      "percentual_utilizado": 65
    },
    {
      "outorga_id": "uuid-outorga-002",
      "numero_outorga": "OUT-002",
      "rio": "RIO-TOCANTINS",
      "volume_autorizado_dia": 20000,
      "volume_captado_dia": 8000,
      "volume_disponivel_dia": 12000,
      "percentual_utilizado": 40
    }
  ]
}
```

# 3. Segunda requisição – Mapa de módulos

`GET /api/modulos/mapa`

Responsável por entregar as coordenadas geográficas e os dados necessários para os marcadores.

```json

{
  "centro": {
    "latitude": -15.1400000,
    "longitude": -51.1100000
  },
  "zoom": 11,
  "total_modulos": 4,
  "marcadores": [
    {
      "modulo_id": "uuid-modulo-001",
      "identificacao": "MOD-001",
      "outorga_id": "uuid-outorga-001",
      "numero_outorga": "OUT-001",
      "rio": "RIO-ARAGUAIA",
      "latitude": -15.1234567,
      "longitude": -51.1234567,
      "status": "ONLINE",
      "situacao_captacao": "FINALIZADA",
      "volume_captado_hoje": 4000,
      "ultimo_contato": "2026-10-31T09:30:00-03:00"
    },
    {
      "modulo_id": "uuid-modulo-002",
      "identificacao": "MOD-002",
      "outorga_id": "uuid-outorga-001",
      "numero_outorga": "OUT-001",
      "rio": "RIO-ARAGUAIA",
      "latitude": -15.1324567,
      "longitude": -51.1124567,
      "status": "ONLINE",
      "situacao_captacao": "FINALIZADA",
      "volume_captado_hoje": 2500,
      "ultimo_contato": "2026-10-31T10:15:00-03:00"
    },
    {
      "modulo_id": "uuid-modulo-003",
      "identificacao": "MOD-003",
      "outorga_id": "uuid-outorga-002",
      "numero_outorga": "OUT-002",
      "rio": "RIO-TOCANTINS",
      "latitude": -15.1454567,
      "longitude": -51.1054567,
      "status": "ONLINE",
      "situacao_captacao": "CAPTANDO",
      "volume_captado_hoje": 5000,
      "ultimo_contato": "2026-10-31T11:00:00-03:00"
    },
    {
      "modulo_id": "uuid-modulo-004",
      "identificacao": "MOD-004",
      "outorga_id": "uuid-outorga-002",
      "numero_outorga": "OUT-002",
      "rio": "RIO-TOCANTINS",
      "latitude": -15.1554567,
      "longitude": -51.0954567,
      "status": "ONLINE",
      "situacao_captacao": "FINALIZADA",
      "volume_captado_hoje": 3000,
      "ultimo_contato": "2026-10-31T10:45:00-03:00"
    }
  ]
}
```

# 4. Terceira requisição – Outorgas

`GET /api/outorgas`

Responsável por alimentar a tela de gerenciamento de outorgas.

```json

{
  "total": 2,
  "outorgas": [
    {
      "id": "uuid-outorga-001",
      "numero_outorga": "OUT-001",
      "titular": "Fazenda Modelo",
      "identificacao_rio": "RIO-ARAGUAIA",
      "volume_diario_autorizado": 10000,
      "data_validade": "2027-12-31",
      "status": "ATIVA",
      "modulos": [
        {
          "id": "uuid-modulo-001",
          "identificacao": "MOD-001"
        },
        {
          "id": "uuid-modulo-002",
          "identificacao": "MOD-002"
        }
      ]
    },
    {
      "id": "uuid-outorga-002",
      "numero_outorga": "OUT-002",
      "titular": "Fazenda Santa Maria",
      "identificacao_rio": "RIO-TOCANTINS",
      "volume_diario_autorizado": 20000,
      "data_validade": "2028-06-30",
      "status": "ATIVA",
      "modulos": [
        {
          "id": "uuid-modulo-003",
          "identificacao": "MOD-003"
        },
        {
          "id": "uuid-modulo-004",
          "identificacao": "MOD-004"
        }
      ]
    }
  ]
}
```

# 5. Quarta requisição – Módulos

`GET /api/modulos`

Responsável por alimentar a tela de gerenciamento dos equipamentos.

```json

{
  "total": 4,
  "modulos": [
    {
      "id": "uuid-modulo-001",
      "identificacao": "MOD-001",
      "numero_serie": "SN-000001",
      "outorga_id": "uuid-outorga-001",
      "numero_outorga": "OUT-001",
      "identificacao_rio": "RIO-ARAGUAIA",
      "localizacao": {
        "latitude": -15.1234567,
        "longitude": -51.1234567
      },
      "status": "ONLINE",
      "situacao_captacao": "FINALIZADA",
      "ultimo_contato": "2026-10-31T09:30:00-03:00"
    },
    {
      "id": "uuid-modulo-002",
      "identificacao": "MOD-002",
      "numero_serie": "SN-000002",
      "outorga_id": "uuid-outorga-001",
      "numero_outorga": "OUT-001",
      "identificacao_rio": "RIO-ARAGUAIA",
      "localizacao": {
        "latitude": -15.1324567,
        "longitude": -51.1124567
      },
      "status": "ONLINE",
      "situacao_captacao": "FINALIZADA",
      "ultimo_contato": "2026-10-31T10:15:00-03:00"
    },
    {
      "id": "uuid-modulo-003",
      "identificacao": "MOD-003",
      "numero_serie": "SN-000003",
      "outorga_id": "uuid-outorga-002",
      "numero_outorga": "OUT-002",
      "identificacao_rio": "RIO-TOCANTINS",
      "localizacao": {
        "latitude": -15.1454567,
        "longitude": -51.1054567
      },
      "status": "ONLINE",
      "situacao_captacao": "CAPTANDO",
      "ultimo_contato": "2026-10-31T11:00:00-03:00"
    },
    {
      "id": "uuid-modulo-004",
      "identificacao": "MOD-004",
      "numero_serie": "SN-000004",
      "outorga_id": "uuid-outorga-002",
      "numero_outorga": "OUT-002",
      "identificacao_rio": "RIO-TOCANTINS",
      "localizacao": {
        "latitude": -15.1554567,
        "longitude": -51.0954567
      },
      "status": "ONLINE",
      "situacao_captacao": "FINALIZADA",
      "ultimo_contato": "2026-10-31T10:45:00-03:00"
    }
  ]
}
```