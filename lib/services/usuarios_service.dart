import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_lista.dart';
import 'auth_service.dart';

/// Servicio de Usuarios.
/// Colócalo en: lib/services/usuarios_service.dart
class UsuariosService {
  static final String _baseUrl = '${AuthService.apiUrl}/usuarios';
  static const String _apiKey = AuthService.apiKey;

  /// Arma los headers con la API key y el token guardado tras el login.
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Content-Type': 'application/json',
      'x-api-key': _apiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /usuarios
  Future<List<UsuarioLista>> obtenerUsuarios() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UsuarioLista.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al obtener usuarios (${response.statusCode}): ${response.body}');
    }
  }

  /// POST /usuarios
  /// Body real esperado: { username, email, password, id_rol, codigo }
  Future<UsuarioLista> crearUsuario({
    required String username,
    required String email,
    required String password,
    required int idRol,
    required String codigo,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'id_rol': idRol,
        'codigo': codigo,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UsuarioLista.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al crear usuario (${response.statusCode}): ${response.body}');
    }
  }

  /// PATCH /usuarios/:id  (id = id_usuario)
  /// cambios puede traer cualquier subconjunto de:
  /// { username, email, id_rol, codigo, activo }
  Future<UsuarioLista> actualizarUsuario(
    int idUsuario,
    Map<String, dynamic> cambios,
  ) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$idUsuario'),
      headers: await _headers(),
      body: jsonEncode(cambios),
    );

    if (response.statusCode == 200) {
      return UsuarioLista.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al actualizar usuario (${response.statusCode}): ${response.body}');
    }
  }

  /// DELETE /usuarios/:id  (id = id_usuario)
  Future<void> eliminarUsuario(int idUsuario) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$idUsuario'),
      headers: await _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Error al eliminar usuario (${response.statusCode}): ${response.body}');
    }
  }

  /// POST /usuarios/:id/reset-password
  Future<void> restablecerPassword(int idUsuario) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$idUsuario/reset-password'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Error al restablecer contraseña (${response.statusCode}): ${response.body}');
    }
  }
}