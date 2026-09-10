import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/notificacion.dart';

class NotificacionesService {
  static const String _baseUrl = '${AuthService.apiUrl}/notificaciones';
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  /// Trae las notificaciones del rol del usuario autenticado. El backend
  /// filtra por el rol que viene DENTRO del token (req.usuario.id_rol),
  /// así que no hace falta enviar el rol como parámetro.
  Future<List<Notificacion>> obtenerNotificaciones(String token) async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers(token));
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => Notificacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Marca una notificación como leída.
  Future<void> marcarLeida(String token, int id) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$id/leida'),
      headers: _headers(token),
    );
    _validar(response);
  }

  /// Envía un mensaje manual que le llega a TODOS los roles del sistema
  /// (equivalente al botón "+ Mensaje" del panel web).
  Future<void> enviarATodos(String token, {
    required String titulo,
    required String descripcion,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers(token),
      body: jsonEncode({'titulo': titulo, 'descripcion': descripcion}),
    );
    _validar(response);
  }

  void _validar(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String mensaje = 'Error en la solicitud (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        mensaje = body['error']?.toString() ?? mensaje;
      } catch (_) {
        // el body no era JSON, se deja el mensaje genérico
      }
      throw Exception(mensaje);
    }
  }
}