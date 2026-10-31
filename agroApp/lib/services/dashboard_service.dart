import 'dart:convert';

import 'package:http/http.dart' as http;

class DashboardService {
  // Endereço da API
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> buscarDados() async {
    final url = Uri.parse('$baseUrl/dashboard');

    try {
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
      }

      throw Exception('Erro HTTP: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha ao buscar dados: $e');
    }
  }
}
