import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

/// Servicio para consumir la API de Reportes.
/// Usa la misma URL base y API key que AuthService, y añade
/// el token JWT del usuario (Bearer) en cada petición.
///
/// Formato de respuesta del backend: { "ok": bool, "mensaje": string, "data": ... }
class ReporteService {
  static const String _baseUrl = AuthService.apiUrl;
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  /// Método interno genérico: hace el GET, valida la respuesta
  /// y devuelve el contenido de "data".
  Future<dynamic> _fetchReporte(String token, String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/reportes$endpoint'),
      headers: _headers(token),
    );

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Respuesta inválida del servidor (${response.statusCode})');
    }

    if (response.statusCode < 200 || response.statusCode >= 300 || body['ok'] != true) {
      throw Exception(body['mensaje']?.toString() ?? 'Error en $endpoint (${response.statusCode})');
    }

    return body['data'];
  }

  // ─── VENTAS ────────────────────────────────────────────────
  Future<Map<String, dynamic>> obtenerResumenVentas(String token) async {
    final data = await _fetchReporte(token, '/ventas/resumen');
    return data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> obtenerVentasPorSucursal(String token) async {
    final data = await _fetchReporte(token, '/ventas/por-sucursal');
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> obtenerVentasPorMetodoPago(String token) async {
    final data = await _fetchReporte(token, '/ventas/por-metodo-pago');
    return (data as List).cast<Map<String, dynamic>>();
  }

  // ─── INVENTARIO ────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerStockBajo(String token) async {
    final data = await _fetchReporte(token, '/inventario/stock-bajo');
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> obtenerMovimientosInventario(String token) async {
    final data = await _fetchReporte(token, '/inventario/movimientos');
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> obtenerValorizacionInventario(String token) async {
    final data = await _fetchReporte(token, '/inventario/valorizacion');
    return data as Map<String, dynamic>;
  }

  // ─── CLIENTES ──────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerTopClientes(String token) async {
    final data = await _fetchReporte(token, '/clientes/top');
    return (data as List).cast<Map<String, dynamic>>();
  }

  // ─── EMPLEADOS ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerRendimientoEmpleados(String token) async {
    final data = await _fetchReporte(token, '/empleados/rendimiento');
    return (data as List).cast<Map<String, dynamic>>();
  }

  // ─── FINANCIERO ────────────────────────────────────────────
  Future<Map<String, dynamic>> obtenerBalancePeriodo(String token) async {
    final data = await _fetchReporte(token, '/financiero/balance');
    return data as Map<String, dynamic>;
  }

  // ─── PRODUCTOS ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerMasVendidos(String token) async {
    final data = await _fetchReporte(token, '/productos/mas-vendidos');
    return (data as List).cast<Map<String, dynamic>>();
  }
}