import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // URL activa (cambia según el entorno en el que estés probando)
  static const String apiUrl = wifiApiUrl;

  static const String apiKey = 'pollo';

  // Servidor por Wi-Fi
  static const String wifiApiUrl = 'http://192.168.137.84:5000';

  // Servidor mediante USB + adb reverse
  static const String usbApiUrl = 'http://localhost:5000';

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

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['error']?.toString() ?? 'No se pudo solicitar la recuperación',
      );
    }

    return data;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String nuevaPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'token': token,
        'nuevaPassword': nuevaPassword,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['error']?.toString() ?? 'No se pudo restablecer la contraseña',
      );
    }

    return data;
  }
}