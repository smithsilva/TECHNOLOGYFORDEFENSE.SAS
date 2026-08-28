import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/proveedores_service.dart';

/// Servicio para consumir la API de proveedores.
/// Misma URL base, API key y token JWT que el resto de servicios.
/// Según tu backend: GET es para todos los autenticados; POST/PUT/PATCH/DELETE
/// requieren rol Admin (1) o Contador (2).
class ProveedoresService {
  static const String _baseUrl = AuthService.apiUrl;
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  // =====================================
  // GET /proveedores
  // =====================================
  Future<List<Proveedor>> obtenerProveedores(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/proveedores'),
      headers: _headers(token),
    );
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Proveedor.fromJson(e as Map<String, dynamic>)).toList();
  }

  // =====================================
  // POST /proveedores  (Admin o Contador)
  // =====================================
  Future<Proveedor> crearProveedor(String token, Proveedor proveedor) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/proveedores'),
      headers: _headers(token),
      body: jsonEncode(proveedor.toJson()),
    );
    _validar(response);
    return Proveedor.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // PUT /proveedores/:id  (Admin o Contador)
  // =====================================
  Future<Proveedor> editarProveedor(String token, int id, Proveedor proveedor) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/proveedores/$id'),
      headers: _headers(token),
      body: jsonEncode(proveedor.toJson()),
    );
    _validar(response);
    return Proveedor.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // PATCH /proveedores/:id  (Admin o Contador)
  // =====================================
  Future<Proveedor> actualizarParcial(String token, int id, Map<String, dynamic> datos) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/proveedores/$id'),
      headers: _headers(token),
      body: jsonEncode(datos),
    );
    _validar(response);
    return Proveedor.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // DELETE /proveedores/:id  (Admin o Contador)
  // =====================================
  Future<void> eliminarProveedor(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/proveedores/$id'),
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