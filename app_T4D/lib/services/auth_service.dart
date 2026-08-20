import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiKey = 'pollo';

  // Servidor por Wi-Fi
static const String wifiApiUrl = 'http://192.168.2.9:5000';

  // Servidor mediante USB + adb reverse
  static const String usbApiUrl = 'http://127.0.0.1:5000';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String codigo,
  }) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      'codigo': codigo,
    });

    // Primero intenta USB
    try {
      final response = await http
          .post(
            Uri.parse('$usbApiUrl/auth/login'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': apiKey,
            },
            body: body,
          )
          .timeout(const Duration(seconds: 2));

      return _procesarRespuesta(response);
    } catch (_) {
      // Si USB no funciona, intenta Wi-Fi
    }

    // Si USB no funciona, intenta Wi-Fi
    try {
      final response = await http
          .post(
            Uri.parse('$wifiApiUrl/auth/login'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': apiKey,
            },
            body: body,
          )
          .timeout(const Duration(seconds: 5));

      return _procesarRespuesta(response);
    } catch (_) {
      throw Exception(
        'No se pudo conectar con el servidor. '
        'Verifica que el backend esté encendido y que el celular '
        'esté conectado por USB o a la misma red Wi-Fi.',
      );
    }
  }

  Map<String, dynamic> _procesarRespuesta(http.Response response) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['error']?.toString() ?? 'Error al iniciar sesión',
      );
    }

    return data;
  }
}