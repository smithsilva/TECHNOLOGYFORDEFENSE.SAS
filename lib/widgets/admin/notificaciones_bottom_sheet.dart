import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/notificacion.dart';
import '../../services/notificaciones_service.dart';

class _SheetColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const navy = Color(0xFF13202E);
  static const rojo = Color(0xFFC0392B);
  static const azul = Color(0xFF2563EB);
  static const verde = Color(0xFF1F9D55);
  static const textoMuted = Color(0xFF6B7280);
}

/// Llama a esto desde la campana. Muestra un bottom sheet con las
/// notificaciones más recientes, con opción de ir a la pantalla completa.
Future<void> mostrarNotificacionesBottomSheet(
  BuildContext context, {
  required VoidCallback onVerTodas,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _NotificacionesSheet(onVerTodas: onVerTodas),
  );
}

class _NotificacionesSheet extends StatefulWidget {
  final VoidCallback onVerTodas;
  const _NotificacionesSheet({required this.onVerTodas});

  @override
  State<_NotificacionesSheet> createState() => _NotificacionesSheetState();
}

class _NotificacionesSheetState extends State<_NotificacionesSheet> {
  final NotificacionesService _service = NotificacionesService();
  bool _cargando = true;
  String? _error;
  List<Notificacion> _notificaciones = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      setState(() {
        _error = 'Sin sesión activa';
        _cargando = false;
      });
      return;
    }
    try {
      final data = await _service.obtenerNotificaciones(token);
      if (!mounted) return;
      setState(() {
        _notificaciones = data.take(5).toList(); // solo las 5 más recientes
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar: $e';
        _cargando = false;
      });
    }
  }

  IconData _icono(String tipo) {
    switch (tipo) {
      case 'alerta':
        return Icons.warning_amber_rounded;
      case 'exito':
        return Icons.check_circle_outline;
      case 'advertencia':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  Color _color(String tipo) {
    switch (tipo) {
      case 'alerta':
        return _SheetColors.rojo;
      case 'exito':
        return _SheetColors.verde;
      case 'advertencia':
        return _SheetColors.doradoOscuro;
      default:
        return _SheetColors.azul;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                child: Row(
                  children: [
                    const Text(
                      'Notificaciones',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold, color: _SheetColors.navy),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onVerTodas();
                      },
                      child: const Text('Ver todas'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(_error!, style: const TextStyle(color: _SheetColors.rojo)))
                        : _notificaciones.isEmpty
                            ? Center(
                                child: Text('No tienes notificaciones',
                                    style: TextStyle(color: Colors.grey.shade600)),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                itemCount: _notificaciones.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, i) {
                                  final n = _notificaciones[i];
                                  final color = _color(n.tipo);
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: color.withValues(alpha: 0.12),
                                      child: Icon(_icono(n.tipo), size: 16, color: color),
                                    ),
                                    title: Text(
                                      n.titulo,
                                      style: TextStyle(
                                        fontWeight: n.leido ? FontWeight.w500 : FontWeight.bold,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    subtitle: Text(
                                      n.descripcion,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: _SheetColors.textoMuted),
                                    ),
                                    trailing: n.leido
                                        ? null
                                        : Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: _SheetColors.rojo,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}