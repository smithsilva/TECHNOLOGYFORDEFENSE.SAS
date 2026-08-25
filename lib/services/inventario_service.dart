import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

/// Servicio para consumir la API de productos/inventario.
/// Usa la misma URL base y API key que AuthService, y añade
/// el token JWT del usuario (Bearer) en cada petición, tal
/// como lo espera tu middleware `verificarToken`.
class InventarioService {
  static const String _baseUrl = AuthService.apiUrl;
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  // =====================================
  // GET /productos
  // =====================================
  Future<List<Map<String, dynamic>>> obtenerProductos(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/productos'),
      headers: _headers(token),
    );
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  // =====================================
  // POST /productos  (solo admin, id_rol 1)
  // =====================================
  Future<Map<String, dynamic>> crearProducto(
      String token, Map<String, dynamic> producto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/productos'),
      headers: _headers(token),
      body: jsonEncode(producto),
    );
    _validar(response);
    return _primerElemento(jsonDecode(response.body));
  }

  // =====================================
  // PUT /productos/:id  (solo admin, id_rol 1)
  // =====================================
  Future<Map<String, dynamic>> editarProducto(
      String token, int id, Map<String, dynamic> producto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers(token),
      body: jsonEncode(producto),
    );
    _validar(response);
    return _primerElemento(jsonDecode(response.body));
  }

  // =====================================
  // PATCH /productos/:id  (edición parcial, solo admin)
  // =====================================
  Future<Map<String, dynamic>> actualizarParcial(
      String token, int id, Map<String, dynamic> datos) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers(token),
      body: jsonEncode(datos),
    );
    _validar(response);
    return _primerElemento(jsonDecode(response.body));
  }

  // =====================================
  // PATCH /productos/:id/stock  (admin id_rol 1 y mecánico id_rol 4)
  // =====================================
  Future<Map<String, dynamic>> actualizarStock(
      String token, int id, int nuevoStock) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/productos/$id/stock'),
      headers: _headers(token),
      body: jsonEncode({'stock': nuevoStock}),
    );
    _validar(response);
    return _primerElemento(jsonDecode(response.body));
  }

  // =====================================
  // DELETE /productos/:id  (solo admin, id_rol 1)
  // =====================================
  Future<void> eliminarProducto(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/productos/$id'),
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