import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:agroapp/widgets/bottom_navigation.dart';

// =====================================================
// 1. DADOS JSON - SIMULAÇÃO DA API
// =====================================================

const String jsonDados = '''
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
''';

// =====================================================
// 2. MODELO OUTORGA
// =====================================================

class Outorga {
  final String id;
  final String numero;
  final String rio;
  final int autorizado;
  final int captado;
  final int disponivel;
  final double percentual;

  Outorga({
    required this.id,
    required this.numero,
    required this.rio,
    required this.autorizado,
    required this.captado,
    required this.disponivel,
    required this.percentual,
  });

  factory Outorga.fromJson(Map<String, dynamic> json) {
    return Outorga(
      id: json['outorga_id'],
      numero: json['numero_outorga'],
      rio: json['rio'],
      autorizado: json['volume_autorizado_dia'],
      captado: json['volume_captado_dia'],
      disponivel: json['volume_disponivel_dia'],
      percentual: (json['percentual_utilizado'] as num).toDouble(),
    );
  }
}

// =====================================================
// 3. MODELO DASHBOARD
// =====================================================

class DashboardData {
  final String dataReferencia;
  final Map<String, dynamic> resumo;
  final List<Outorga> outorgas;

  DashboardData({
    required this.dataReferencia,
    required this.resumo,
    required this.outorgas,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      dataReferencia: json['data_referencia'],
      resumo: json['resumo'],
      outorgas: (json['captacao_por_outorga'] as List)
          .map((item) => Outorga.fromJson(item))
          .toList(),
    );
  }
}

// =====================================================
// 4. TELA PRINCIPAL DO DASHBOARD
// =====================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Converte JSON para objeto Dart
    final dados = DashboardData.fromJson(jsonDecode(jsonDados));

    final resumo = dados.resumo;

    return Scaffold(
      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF087E8B),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Monitoramento Hídrico',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // CONTEÚDO
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABEÇALHO
            Text(
              'Visão geral',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              'Data de referência: ${dados.dataReferencia}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // INDICADORES
            const SectionTitle(title: 'Indicadores gerais'),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,

              children: [
                MetricCard(
                  title: 'Total de outorgas',
                  value: '${resumo['total_outorgas']}',
                  icon: Icons.description_outlined,
                  color: Colors.blue,
                ),

                MetricCard(
                  title: 'Módulos online',
                  value:
                      '${resumo['modulos_online']}/${resumo['total_modulos']}',
                  icon: Icons.sensors,
                  color: Colors.green,
                ),

                MetricCard(
                  title: 'Módulos captando',
                  value: '${resumo['modulos_captando']}',
                  icon: Icons.water_drop_outlined,
                  color: Colors.orange,
                ),

                MetricCard(
                  title: 'Volume captado',
                  value: formatarNumero(resumo['volume_captado_dia']),
                  icon: Icons.opacity,
                  color: Colors.teal,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // MONITORAMENTO DIÁRIO
            const SectionTitle(title: 'Monitoramento diário'),

            const SizedBox(height: 12),

            VolumeCard(resumo: resumo),

            const SizedBox(height: 24),

            // CAPTAÇÃO POR OUTORGA
            const SectionTitle(title: 'Captação por outorga'),

            const SizedBox(height: 12),

            ...dados.outorgas.map((outorga) => OutorgaCard(outorga: outorga)),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 5. COMPONENTE: TÍTULO DE SEÇÃO
// =====================================================

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

// =====================================================
// 6. COMPONENTE: CARD DE INDICADORES
// =====================================================

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Icon(icon, color: color, size: 27),

            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 7. COMPONENTE: VOLUME DIÁRIO
// =====================================================

class VolumeCard extends StatelessWidget {
  final Map<String, dynamic> resumo;

  const VolumeCard({super.key, required this.resumo});

  @override
  Widget build(BuildContext context) {
    final percentual = (resumo['percentual_utilizado'] as num).toDouble();

    return Card(
      elevation: 0,
      color: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Volume utilizado no dia',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(
              '${percentual.toStringAsFixed(2).replaceAll('.', ',')}%',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF087E8B),
              ),
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: (percentual / 100).clamp(0.0, 1.0),
              minHeight: 12,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF087E8B),
            ),

            const SizedBox(height: 20),

            VolumeInfo(
              label: 'Volume autorizado',
              value: resumo['volume_autorizado_dia'],
            ),

            VolumeInfo(
              label: 'Volume captado',
              value: resumo['volume_captado_dia'],
            ),

            VolumeInfo(
              label: 'Volume disponível',
              value: resumo['volume_disponivel_dia'],
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 8. COMPONENTE: INFORMAÇÕES DE VOLUME
// =====================================================

class VolumeInfo extends StatelessWidget {
  final String label;
  final int value;
  final Color? color;

  const VolumeInfo({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),

          Text(
            formatarNumero(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// 9. COMPONENTE: CARD DE OUTORGA
// =====================================================

class OutorgaCard extends StatelessWidget {
  final Outorga outorga;

  const OutorgaCard({super.key, required this.outorga});

  @override
  Widget build(BuildContext context) {
    final percentual = outorga.percentual;

    final cor = percentual >= 70 ? Colors.orange : const Color(0xFF087E8B);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  outorga.numero,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${percentual.toStringAsFixed(1)}% utilizado',
                  style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              outorga.rio.replaceAll('-', ' '),
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: (percentual / 100).clamp(0.0, 1.0),
              minHeight: 9,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade200,
              color: cor,
            ),

            const SizedBox(height: 16),

            VolumeInfo(label: 'Autorizado', value: outorga.autorizado),

            VolumeInfo(label: 'Captado', value: outorga.captado),

            VolumeInfo(
              label: 'Disponível',
              value: outorga.disponivel,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 10. FUNÇÃO: FORMATAÇÃO DE NÚMEROS
// =====================================================

String formatarNumero(dynamic valor) {
  final numero = valor.toInt().toString();

  return numero.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
