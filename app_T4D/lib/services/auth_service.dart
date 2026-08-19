import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl = 'http://192.168.2.14:5000';
  static const String apiKey = 'pollo';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String codigo,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'codigo': codigo,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['error']?.toString() ?? 'Error al iniciar sesión',
      );
    }

    return data;
  }
}