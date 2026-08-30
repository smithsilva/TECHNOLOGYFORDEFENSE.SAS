import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/producto.dart';
import '../models/historial_precio.dart';

/// Servicio para consumir la API de Historial de Precios.
/// Misma URL base, API key y token JWT que el resto de servicios (ver CategoriasService).
///
/// Rutas del backend (montadas bajo `/historial-precios`):
///   GET    /historial-precios/productos
///   POST   /historial-precios/productos            (admin, gerente)
///   PUT    /historial-precios/productos/:id         (admin, gerente)
///   PATCH  /historial-precios/productos/:id/estado  (solo admin)
///   DELETE /historial-precios/productos/:id         (solo admin)
///   GET    /historial-precios            (soporta ?id_producto=)
///   DELETE /historial-precios/:id                   (solo admin)
///
/// Nota importante: el endpoint /productos de este módulo solo devuelve
/// `id_producto, nombre_producto, precio_actual, activo` (no todo lo que trae
/// el `Producto` de inventario general). `Producto.fromJson` funciona igual
/// porque el resto de campos son opcionales/con default, simplemente quedan
/// sin llenar (descripcion, stock, categoría, etc. quedarán null/0).
class HistorialPreciosService {
  static const String _baseUrl = '${AuthService.apiUrl}/historial-precios';
  static const String _apiKey = AuthService.apiKey;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token',
      };

  // =====================================
  // PRODUCTOS
  // =====================================

  /// Devuelve los productos usando tu modelo `Producto` de inventario.
  /// Útil para selects/formularios donde necesitas id, nombre y precio.
  Future<List<Producto>> obtenerProductos(String token) async {
    final raw = await _fetchProductosRaw(token);
    return raw.map((e) => Producto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Crea un producto nuevo. El backend registra automáticamente el precio
  /// inicial en el historial. `motivo` es opcional (por defecto "Creación de producto").
  Future<Producto> crearProducto(
    String token, {
    required String nombreProducto,
    required double precioInicial,
    String? motivo,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/productos'),
      headers: _headers(token),
      body: jsonEncode({
        'nombre_producto': nombreProducto,
        'precio_inicial': precioInicial,
        if (motivo != null) 'motivo': motivo,
      }),
    );
    _validar(response);
    return Producto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Edita nombre y/o precio de un producto. Si cambia el precio, el backend
  /// exige `motivo` (400 si falta) y registra el cambio en el historial.
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

  /// Puede lanzar una excepción con el mensaje 409 del backend cuando el
  /// producto tiene historial asociado; en ese caso conviene ofrecer
  /// `cambiarEstadoProducto(token, id, false)` como alternativa (desactivar),
  /// igual que hace el `window.confirm` en tu versión React.
  Future<void> eliminarProducto(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers(token),
    );
    _validar(response);
  }

  // =====================================
  // HISTORIAL (combinado con datos del producto)
  // =====================================

  /// Trae el historial y lo combina con los datos de producto (nombre,
  /// precio actual, activo) para devolverte directamente `List<HistorialPrecio>`
  /// tal como la espera tu `HistorialPreciosScreen` — equivalente al
  /// `productosMap` que se arma en la versión React.
  ///
  /// `idProducto` es opcional: si se pasa, filtra el historial de un solo producto.
  Future<List<HistorialPrecio>> obtenerHistorial(String token, {int? idProducto}) async {
    final resultados = await Future.wait([
      _fetchHistorialRaw(token, idProducto: idProducto),
      _fetchProductosRaw(token),
    ]);
    final historialRaw = resultados[0];
    final productosRaw = resultados[1];

    final mapaProductos = <int, Map<String, dynamic>>{
      for (final p in productosRaw) p['id_producto'] as int: p,
    };

    return historialRaw.map((h) {
      final prod = mapaProductos[h['id_producto'] as int];
      final precioNuevo = (h['precio_nuevo'] as num).toDouble();

      return HistorialPrecio(
        id: h['id_historial'] as int,
        idProducto: h['id_producto'] as int,
        // Si el producto fue eliminado después, evitamos un null y avisamos.
        nombreProducto: prod?['nombre_producto']?.toString() ?? 'Producto eliminado',
        precioActual: prod != null ? (prod['precio_actual'] as num).toDouble() : precioNuevo,
        activo: prod?['activo'] as bool? ?? false,
        precioAnterior: (h['precio_anterior'] as num).toDouble(),
        precioNuevo: precioNuevo,
        fecha: DateTime.parse(h['fecha_cambio'] as String),
        motivo: h['motivo']?.toString() ?? '',
      );
    }).toList();
  }

  Future<void> eliminarHistorial(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers(token),
    );
    _validar(response);
  }

  // =====================================
  // Helpers privados (fetch crudo, sin mapear a modelo todavía)
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
        // el body no era JSON, se deja el mensaje genérico
      }
      throw Exception(mensaje);
    }
  }
}