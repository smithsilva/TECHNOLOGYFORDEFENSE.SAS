import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/producto.dart';
import '../models/historial_precio.dart';

class HistorialPreciosService {
  static const String _baseUrl = '${AuthService.apiUrl}/historial-precios';
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  // =====================================
  // PRODUCTOS (solo lectura + actualizar precio)
  //
  // La creación y eliminación de productos vive en InventarioService.
  // Este servicio solo puede leer y actualizar el precio.
  // =====================================

  Future<List<Producto>> obtenerProductos(String token) async {
    final raw = await _fetchProductosRaw(token);
    return raw.map((e) => Producto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Actualiza nombre y/o precio de un producto existente. Si cambia el
  /// precio, el backend exige `motivo` (400 si falta) y registra el cambio
  /// en el historial.
  Future<Producto> editarProducto(
    String token,
    int id, {
    String? nombreProducto,
    double? precioNuevo,
    String? motivo,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers(token),
      body: jsonEncode({
        if (nombreProducto != null) 'nombre_producto': nombreProducto,
        if (precioNuevo != null) 'precio_nuevo': precioNuevo,
        if (motivo != null) 'motivo': motivo,
      }),
    );
    _validar(response);
    return Producto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Producto> cambiarEstadoProducto(String token, int id, bool activo) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/productos/$id/estado'),
      headers: _headers(token),
      body: jsonEncode({'activo': activo}),
    );
    _validar(response);
    return Producto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // =====================================
  // HISTORIAL (solo lectura)
  // =====================================

  Future<List<HistorialPrecio>> obtenerHistorial(String token, {int? idProducto}) async {
    final resultados = await Future.wait([
      _fetchHistorialRaw(token, idProducto: idProducto),
      _fetchProductosRaw(token),
    ]);
    final historialRaw = resultados[0];
    final productosRaw = resultados[1];

    final mapaProductos = <int, Map<String, dynamic>>{
      for (final p in productosRaw)
        if (p['id_producto'] != null) p['id_producto'] as int: p,
    };

    return historialRaw.map((h) {
      final idProd = h['id_producto'] as int? ?? 0;
      final prod = mapaProductos[idProd];
      final precioNuevo = (h['precio_nuevo'] as num?)?.toDouble() ?? 0;

      return HistorialPrecio(
        id: h['id_historial'] as int? ?? 0,
        idProducto: idProd,
        nombreProducto: prod?['nombre_producto']?.toString() ?? 'Producto eliminado',
        precioActual: prod != null
            ? (prod['precio_actual'] as num?)?.toDouble() ?? 0
            : precioNuevo,
        activo: prod?['activo'] as bool? ?? false,
        precioAnterior: (h['precio_anterior'] as num?)?.toDouble() ?? 0,
        precioNuevo: precioNuevo,
        fecha: h['fecha_cambio'] != null
            ? DateTime.tryParse(h['fecha_cambio'].toString()) ?? DateTime.now()
            : DateTime.now(),
        motivo: h['motivo']?.toString() ?? '',
      );
    }).toList();
  }

  // =====================================
  // Helpers privados
  // =====================================

  Future<List<Map<String, dynamic>>> _fetchProductosRaw(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/productos'),
      headers: _headers(token),
    );
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _fetchHistorialRaw(String token, {int? idProducto}) async {
    final uri = idProducto != null
        ? Uri.parse('$_baseUrl?id_producto=$idProducto')
        : Uri.parse(_baseUrl);
    final response = await http.get(uri, headers: _headers(token));
    _validar(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  void _validar(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String mensaje = 'Error en la solicitud (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        mensaje = body['error']?.toString() ?? mensaje;
      } catch (_) {
        // el cuerpo no era JSON, se deja el mensaje genérico
      }
      throw Exception(mensaje);
    }
  }
}