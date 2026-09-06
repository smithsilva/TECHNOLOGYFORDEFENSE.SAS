import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarea.dart';
import 'auth_service.dart';

/// Servicio de Tareas (Asignaciones).
/// Colócalo en: lib/services/tareas_service.dart
class TareasService {
  static final String _baseUrl = '${AuthService.apiUrl}/asignaciones';
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

  /// GET /asignaciones
  Future<List<Tarea>> obtenerTareas() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Tarea.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al obtener tareas (${response.statusCode}): ${response.body}');
    }
  }

  /// POST /asignaciones
  Future<Tarea> crearTarea(Map<String, dynamic> datos) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(),
      body: jsonEncode(datos),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Tarea.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al crear tarea (${response.statusCode}): ${response.body}');
    }
  }

  /// PATCH /asignaciones/:id  (id = id_asignacion)
  Future<Tarea> actualizarTarea(
    int idAsignacion,
    Map<String, dynamic> cambios,
  ) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$idAsignacion'),
      headers: await _headers(),
      body: jsonEncode(cambios),
    );

    if (response.statusCode == 200) {
      return Tarea.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al actualizar tarea (${response.statusCode}): ${response.body}');
    }
  }

  /// DELETE /asignaciones/:id  (id = id_asignacion)
  Future<void> eliminarTarea(int idAsignacion) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$idAsignacion'),
      headers: await _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Error al eliminar tarea (${response.statusCode}): ${response.body}');
    }
  }
}