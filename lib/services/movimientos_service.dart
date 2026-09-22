import 'dart:convert';
import 'package:http/http.dart' as http;

class MovimientosService {
  static const String _baseUrl = 'http://192.168.2.11:5000';
  static const String _apiKey = 'pollo'; 

  Future<List<Map<String, dynamic>>> obtenerMovimientos(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movimientos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-api-key': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('RESPUESTA CRUDA: $decoded'); 
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'Error al obtener movimientos');
    }
  }

  Future<Map<String, dynamic>> crearMovimiento(
    String token,
    Map<String, dynamic> movimiento,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/movimientos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-api-key': _apiKey,
      },
      body: jsonEncode(movimiento),
    );

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded is List ? decoded.first : decoded as Map<String, dynamic>;
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'Error al crear movimiento');
    }
  }
}