import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/sucursal.dart';

/// Servicio para consumir la API de sucursales.
/// GET disponible para todos los autenticados; POST/PUT/PATCH/DELETE
/// requieren rol Admin (1) o Contador (2).
class SucursalesService {
  static const String _baseUrl = AuthService.apiUrl;
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  // =====================================
  // GET /sucursales
  // =====================================
  Future<List<Sucursal>> obtenerSucursales(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sucursales'),
      headers: _headers(token),
    );
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Sucursal.fromJson(e as Map<String, dynamic>)).toList();
  }

  // =====================================
  // GET /sucursales/:id
  // =====================================
  Future<Sucursal> obtenerSucursalPorId(String token, int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sucursales/$id'),
      headers: _headers(token),
    );
    _validar(response);
    return Sucursal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // =====================================
  // POST /sucursales  (Admin o Contador)
  // =====================================
  Future<Sucursal> crearSucursal(String token, Sucursal sucursal) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sucursales'),
      headers: _headers(token),
      body: jsonEncode(sucursal.toJson()),
    );
    _validar(response);
    return Sucursal.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // PUT /sucursales/:id  (Admin o Contador)
  // =====================================
  Future<Sucursal> editarSucursal(String token, int id, Sucursal sucursal) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/sucursales/$id'),
      headers: _headers(token),
      body: jsonEncode(sucursal.toJson()),
    );
    _validar(response);
    return Sucursal.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // PATCH /sucursales/:id  (Admin o Contador)
  // =====================================
  Future<Sucursal> actualizarParcial(String token, int id, Map<String, dynamic> datos) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/sucursales/$id'),
      headers: _headers(token),
      body: jsonEncode(datos),
    );
    _validar(response);
    return Sucursal.fromJson(_primerElemento(jsonDecode(response.body)));
  }

  // =====================================
  // DELETE /sucursales/:id  (Admin o Contador)
  // =====================================
  Future<void> eliminarSucursal(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/sucursales/$id'),
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
      } catch (_) {}
      throw Exception(mensaje);
    }
  }
}