import 'dart:convert';

import 'package:flutter/material.dart';

// =====================================================
// 1. DADOS JSON - SIMULAÇÃO DA API
// =====================================================

const String jsonOutorgas = '''
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
''';

// =====================================================
// 2. MODELO: MÓDULO
// =====================================================

class Modulo {
  final String id;
  final String identificacao;

  Modulo({required this.id, required this.identificacao});

  factory Modulo.fromJson(Map<String, dynamic> json) {
    return Modulo(id: json['id'], identificacao: json['identificacao']);
  }
}

// =====================================================
// 3. MODELO: OUTORGA
// =====================================================

class Outorga {
  final String id;
  final String numero;
  final String titular;
  final String rio;
  final int volumeAutorizado;
  final String dataValidade;
  final String status;
  final List<Modulo> modulos;

  Outorga({
    required this.id,
    required this.numero,
    required this.titular,
    required this.rio,
    required this.volumeAutorizado,
    required this.dataValidade,
    required this.status,
    required this.modulos,
  });

  factory Outorga.fromJson(Map<String, dynamic> json) {
    return Outorga(
      id: json['id'],
      numero: json['numero_outorga'],
      titular: json['titular'],
      rio: json['identificacao_rio'],
      volumeAutorizado: json['volume_diario_autorizado'],
      dataValidade: json['data_validade'],
      status: json['status'],
      modulos: (json['modulos'] as List)
          .map((item) => Modulo.fromJson(item))
          .toList(),
    );
  }
}

// =====================================================
// 4. MODELO: RESPOSTA DA API
// =====================================================

class OutorgasResponse {
  final int total;
  final List<Outorga> outorgas;

  OutorgasResponse({required this.total, required this.outorgas});

  factory OutorgasResponse.fromJson(Map<String, dynamic> json) {
    return OutorgasResponse(
      total: json['total'],
      outorgas: (json['outorgas'] as List)
          .map((item) => Outorga.fromJson(item))
          .toList(),
    );
  }
}

// =====================================================
// 5. TELA PRINCIPAL: OUTORGAS
// =====================================================

class OutorgasPage extends StatefulWidget {
  const OutorgasPage({super.key});

  @override
  State<OutorgasPage> createState() => _OutorgasPageState();
}

class _OutorgasPageState extends State<OutorgasPage> {
  late OutorgasResponse dados;

  final TextEditingController searchController = TextEditingController();

  String filtro = 'TODAS';

  @override
  void initState() {
    super.initState();

    // Simula o recebimento dos dados da API
    dados = OutorgasResponse.fromJson(jsonDecode(jsonOutorgas));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ===================================================
  // FILTRAGEM DAS OUTORGAS
  // ===================================================

  List<Outorga> get outorgasFiltradas {
    return dados.outorgas.where((outorga) {
      final pesquisa = searchController.text.toLowerCase();

      final correspondePesquisa =
          outorga.numero.toLowerCase().contains(pesquisa) ||
          outorga.titular.toLowerCase().contains(pesquisa) ||
          outorga.rio.toLowerCase().contains(pesquisa);

      final correspondeStatus = filtro == 'TODAS' || outorga.status == filtro;

      return correspondePesquisa && correspondeStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =================================================
      // APP BAR
      // =================================================

      appBar: AppBar(
        title: const Text(
          'Outorgas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF087E8B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // =================================================
      // CONTEÚDO
      // =================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // CABEÇALHO

            const Text(
              'Gerenciamento de outorgas',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              'Consulte as autorizações de captação de água.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 20),

            // INDICADOR TOTAL
            TotalOutorgasCard(total: dados.total),

            const SizedBox(height: 24),

            // CAMPO DE PESQUISA
            TextField(
              controller: searchController,

              onChanged: (value) {
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: 'Buscar por outorga, titular ou rio...',
                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(vertical: 14),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),

                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FILTROS
            const Text(
              'Filtrar por status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,

              children: [
                filtroChip('TODAS'),
                filtroChip('ATIVA'),
                filtroChip('INATIVA'),
                filtroChip('SUSPENSA'),
              ],
            ),

            const SizedBox(height: 20),

            // TÍTULO DA LISTAGEM
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Outorgas cadastradas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${outorgasFiltradas.length} registro(s)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // LISTAGEM
            if (outorgasFiltradas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),

                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 45, color: Colors.grey),

                      SizedBox(height: 10),

                      Text(
                        'Nenhuma outorga encontrada.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...outorgasFiltradas.map(
                (outorga) => OutorgaCard(outorga: outorga),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // COMPONENTE: FILTRO
  // ===================================================

  Widget filtroChip(String status) {
    final selecionado = filtro == status;

    return ChoiceChip(
      label: Text(status),

      selected: selecionado,

      onSelected: (value) {
        setState(() {
          filtro = status;
        });
      },

      selectedColor: const Color(0xFF087E8B),

      backgroundColor: Colors.white,

      labelStyle: TextStyle(
        color: selecionado ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),

      side: BorderSide(
        color: selecionado ? const Color(0xFF087E8B) : Colors.grey.shade300,
      ),
    );
  }
}

// =====================================================
// 6. COMPONENTE: TOTAL DE OUTORGAS
// =====================================================

class TotalOutorgasCard extends StatelessWidget {
  final int total;

  const TotalOutorgasCard({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF087E8B),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 18),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Total de outorgas',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              Text(
                '$total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'Autorizações cadastradas',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================
// 7. COMPONENTE: CARD DE OUTORGA
// =====================================================

class OutorgaCard extends StatelessWidget {
  final Outorga outorga;

  const OutorgaCard({super.key, required this.outorga});

  @override
  Widget build(BuildContext context) {
    final corStatus = obterCorStatus(outorga.status);

    return Card(
      color: Colors.white,
      elevation: 0,

      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // IDENTIFICAÇÃO E STATUS

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF087E8B),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      outorga.numero,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: corStatus.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    outorga.status,
                    style: TextStyle(
                      color: corStatus,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 25),

            // TITULAR
            InfoOutorga(
              icon: Icons.business_outlined,
              label: 'Titular',
              value: outorga.titular,
            ),

            const SizedBox(height: 14),

            // RIO
            InfoOutorga(
              icon: Icons.water_outlined,
              label: 'Identificação do rio',
              value: outorga.rio.replaceAll('-', ' '),
            ),

            const SizedBox(height: 14),

            // VOLUME AUTORIZADO
            InfoOutorga(
              icon: Icons.opacity,
              label: 'Volume diário autorizado',
              value: formatarNumero(outorga.volumeAutorizado),
              destaque: true,
            ),

            const SizedBox(height: 14),

            // VALIDADE
            InfoOutorga(
              icon: Icons.calendar_month_outlined,
              label: 'Data de validade',
              value: formatarData(outorga.dataValidade),
            ),

            const Divider(height: 28),

            // MÓDULOS VINCULADOS
            Row(
              children: [
                const Icon(Icons.sensors, color: Color(0xFF087E8B), size: 20),

                const SizedBox(width: 8),

                const Text(
                  'Módulos vinculados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),

                const Spacer(),

                Text(
                  '${outorga.modulos.length} módulo(s)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: outorga.modulos.map((modulo) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4F5),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.sensors,
                        color: Color(0xFF087E8B),
                        size: 16,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        modulo.identificacao,
                        style: const TextStyle(
                          color: Color(0xFF087E8B),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// 8. COMPONENTE: INFORMAÇÕES DA OUTORGA
// =====================================================

class InfoOutorga extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool destaque;

  const InfoOutorga({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: destaque ? FontWeight.bold : FontWeight.w500,
                  color: destaque ? const Color(0xFF087E8B) : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// 9. FUNÇÕES AUXILIARES
// =====================================================

// Formatação de números
String formatarNumero(dynamic valor) {
  final numero = valor.toInt().toString();

  return numero.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}

// Formatação de datas
String formatarData(String data) {
  final partes = data.split('-');

  if (partes.length != 3) {
    return data;
  }

  return '${partes[2]}/${partes[1]}/${partes[0]}';
}

// Cores conforme o status
Color obterCorStatus(String status) {
  switch (status.toUpperCase()) {
    case 'ATIVA':
      return Colors.green;

    case 'INATIVA':
      return Colors.grey;

    case 'SUSPENSA':
      return Colors.orange;

    default:
      return Colors.red;
  }
}
