import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rol.dart';
import 'auth_service.dart';

/// Servicio de Roles.
/// Colócalo en: lib/services/roles_service.dart
class RolesService {
  static final String _baseUrl = '${AuthService.apiUrl}/roles';
  static const String _apiKey = AuthService.apiKey;

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'x-api-key': _apiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /roles
  Future<List<Rol>> obtenerRoles() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Rol.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al obtener roles (${response.statusCode}): ${response.body}');
    }
  }

  /// POST /roles
  Future<Rol> crearRol({
    required String nombreRol,
    String? descripcion,
    int? nivelAcceso,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(),
      body: jsonEncode({
        'nombre_rol': nombreRol,
        'descripcion': descripcion,
        'nivel_acceso': nivelAcceso,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Rol.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al crear rol (${response.statusCode}): ${response.body}');
    }
  }

  /// PATCH /roles/:id  (id = id_rol)
  Future<Rol> actualizarRol(int idRol, Map<String, dynamic> cambios) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$idRol'),
      headers: await _headers(),
      body: jsonEncode(cambios),
    );

    if (response.statusCode == 200) {
      return Rol.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al actualizar rol (${response.statusCode}): ${response.body}');
    }
  }

  /// DELETE /roles/:id  (id = id_rol)
  Future<void> eliminarRol(int idRol) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$idRol'),
      headers: await _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Error al eliminar rol (${response.statusCode}): ${response.body}');
    }
  }
}