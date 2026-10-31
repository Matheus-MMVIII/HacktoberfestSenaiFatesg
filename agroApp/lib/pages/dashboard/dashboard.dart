import 'package:flutter/material.dart';
import 'package:agroapp/services/dashboard_service.dart';

// =====================================================
// 1. MODELO OUTORGA
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
      id: json['outorga_id'].toString(),
      numero: json['numero_outorga'].toString(),
      rio: json['rio'].toString(),
      autorizado: (json['volume_autorizado_dia'] as num).toInt(),
      captado: (json['volume_captado_dia'] as num).toInt(),
      disponivel: (json['volume_disponivel_dia'] as num).toInt(),
      percentual: (json['percentual_utilizado'] as num).toDouble(),
    );
  }
}

// =====================================================
// 2. MODELO DASHBOARD
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
      dataReferencia: json['data_referencia'].toString(),

      resumo: Map<String, dynamic>.from(json['resumo']),

      outorgas: (json['captacao_por_outorga'] as List)
          .map((item) => Outorga.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

// =====================================================
// 3. TELA PRINCIPAL DO DASHBOARD
// =====================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _service = DashboardService();

  late Future<DashboardData> _dadosDashboard;

  @override
  void initState() {
    super.initState();

    // Primeira consulta à API
    _dadosDashboard = carregarDados();
  }

  // ===================================================
  // CONSULTAR API
  // ===================================================

  Future<DashboardData> carregarDados() async {
    final json = await _service.buscarDados();

    return DashboardData.fromJson(json);
  }

  // ===================================================
  // ATUALIZAR DASHBOARD
  // ===================================================

  Future<void> atualizarDashboard() async {
    setState(() {
      _dadosDashboard = carregarDados();
    });

    try {
      await _dadosDashboard;
    } catch (_) {
      // O FutureBuilder tratará o erro.
    }
  }

  // ===================================================
  // CONSTRUIR INTERFACE
  // ===================================================

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: _dadosDashboard,

      builder: (context, snapshot) {
        // ---------------------------------------------
        // CARREGAMENTO
        // ---------------------------------------------

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF087E8B)),
            ),
          );
        }

        // ---------------------------------------------
        // TRATAMENTO DE ERRO
        // ---------------------------------------------

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Monitoramento Hídrico'),
              backgroundColor: const Color(0xFF087E8B),
              foregroundColor: Colors.white,
            ),

            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Não foi possível carregar os dados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: atualizarDashboard,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // ---------------------------------------------
        // DADOS RECEBIDOS DA API
        // ---------------------------------------------

        final dados = snapshot.data!;
        final resumo = dados.resumo;

        return Scaffold(
          // ===========================================
          // APP BAR
          // ===========================================

          appBar: AppBar(
            backgroundColor: const Color(0xFF087E8B),
            foregroundColor: Colors.white,
            elevation: 0,

            title: const Text(
              'Monitoramento Hídrico',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            actions: [
              // Atualizar dados
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Atualizar dados',
                onPressed: atualizarDashboard,
              ),

              // Notificações
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),

              const SizedBox(width: 8),
            ],
          ),

          // ===========================================
          // CONTEÚDO
          // ===========================================
          body: RefreshIndicator(
            color: const Color(0xFF087E8B),
            onRefresh: atualizarDashboard,

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // -----------------------------------
                  // CABEÇALHO
                  // -----------------------------------

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

                  // -----------------------------------
                  // INDICADORES GERAIS
                  // -----------------------------------
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
                      // Total de outorgas
                      MetricCard(
                        title: 'Total de outorgas',
                        value: '${resumo['total_outorgas']}',
                        icon: Icons.description_outlined,
                        color: Colors.blue,
                      ),

                      // Módulos online
                      MetricCard(
                        title: 'Módulos online',
                        value:
                            '${resumo['modulos_online']}/${resumo['total_modulos']}',
                        icon: Icons.sensors,
                        color: Colors.green,
                      ),

                      // Módulos captando
                      MetricCard(
                        title: 'Módulos captando',
                        value: '${resumo['modulos_captando']}',
                        icon: Icons.water_drop_outlined,
                        color: Colors.orange,
                      ),

                      // Volume captado
                      MetricCard(
                        title: 'Volume captado',
                        value: formatarNumero(resumo['volume_captado_dia']),
                        icon: Icons.opacity,
                        color: Colors.teal,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // -----------------------------------
                  // MONITORAMENTO DIÁRIO
                  // -----------------------------------
                  const SectionTitle(title: 'Monitoramento diário'),

                  const SizedBox(height: 12),

                  VolumeCard(resumo: resumo),

                  const SizedBox(height: 24),

                  // -----------------------------------
                  // CAPTAÇÃO POR OUTORGA
                  // -----------------------------------
                  const SectionTitle(title: 'Captação por outorga'),

                  const SizedBox(height: 12),

                  ...dados.outorgas.map(
                    (outorga) => OutorgaCard(outorga: outorga),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =====================================================
// 4. COMPONENTE: TÍTULO DE SEÇÃO
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
// 5. COMPONENTE: CARD DE INDICADORES
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
// 6. COMPONENTE: VOLUME DIÁRIO
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
              value: resumo['volume_autorizado_dia'] as num,
            ),

            VolumeInfo(
              label: 'Volume captado',
              value: resumo['volume_captado_dia'] as num,
            ),

            VolumeInfo(
              label: 'Volume disponível',
              value: resumo['volume_disponivel_dia'] as num,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 7. COMPONENTE: INFORMAÇÕES DE VOLUME
// =====================================================

class VolumeInfo extends StatelessWidget {
  final String label;
  final num value;
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
// 8. COMPONENTE: CARD DE OUTORGA
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
            // IDENTIFICAÇÃO DA OUTORGA
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

            // IDENTIFICAÇÃO DO RIO
            Text(
              outorga.rio.replaceAll('-', ' '),
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // PROGRESSO DA CAPTAÇÃO
            LinearProgressIndicator(
              value: (percentual / 100).clamp(0.0, 1.0),
              minHeight: 9,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade200,
              color: cor,
            ),

            const SizedBox(height: 16),

            // VOLUMES
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
// 9. FUNÇÃO: FORMATAÇÃO DE NÚMEROS
// =====================================================

String formatarNumero(num valor) {
  final numero = valor.toInt().toString();

  return numero.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
