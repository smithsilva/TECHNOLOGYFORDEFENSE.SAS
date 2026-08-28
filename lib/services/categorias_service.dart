import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/categoria.dart';

/// Servicio para consumir la API de categorías de blindaje.
/// Misma URL base, API key y token JWT que el resto de servicios.
class CategoriasService {
  static const String _baseUrl = AuthService.apiUrl;
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  // =====================================
  // GET /categorias
  // =====================================
  Future<List<CategoriaBlindaje>> obtenerCategorias(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/categorias'),
      headers: _headers(token),
    );
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => CategoriaBlindaje.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =====================================
  // POST /categorias  (solo admin, id_rol 1)
  // =====================================
  Future<CategoriaBlindaje> crearCategoria(
      String token, CategoriaBlindaje categoria) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/categorias'),
      headers: _headers(token),
      body: jsonEncode(categoria.toJson()),
    );
    _validar(response);
    return CategoriaBlindaje.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // PUT /categorias/:id  (reemplazo completo, solo admin)
  // =====================================
  Future<CategoriaBlindaje> editarCategoria(
      String token, int id, CategoriaBlindaje categoria) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/categorias/$id'),
      headers: _headers(token),
      body: jsonEncode(categoria.toJson()),
    );
    _validar(response);
    return CategoriaBlindaje.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // PATCH /categorias/:id  (edición parcial, solo admin)
  // =====================================
  Future<CategoriaBlindaje> actualizarParcial(
      String token, int id, Map<String, dynamic> datos) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/categorias/$id'),
      headers: _headers(token),
      body: jsonEncode(datos),
    );
    _validar(response);
    return CategoriaBlindaje.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // DELETE /categorias/:id  (solo admin, id_rol 1)
  // =====================================
  Future<void> eliminarCategoria(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/categorias/$id'),
      headers: _headers(token),
    );
    _validar(response);
  }

  Map<String, dynamic> _primerElemento(dynamic data) {
    if (data is List && data.isNotEmpty) return data.first as Map<String, dynamic>;
    if (data is Map<String, dynamic>) return data;
    throw Exception('Respuesta inesperada del servidor');
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