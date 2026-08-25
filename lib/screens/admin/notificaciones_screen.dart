import 'package:flutter/material.dart';
import '../../models/notificacion.dart';
// import '../services/notificaciones_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const azul = Color(0xFF2563EB);
  static const azulFondo = Color(0xFFE3EBFD);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const textoMuted = Color(0xFF6B7280);
}

class NotificacionesScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const NotificacionesScreen({super.key, this.usuario});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  bool _cargando = false;
  List<Notificacion> _notificaciones = [];

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  /// Por ahora carga datos de ejemplo (mock) para la parte visual.
  /// Cuando conectes el backend, reemplaza el contenido de este método
  /// por una llamada a tu NotificacionesService, por ejemplo:
  ///
  /// final data = await NotificacionesService().obtenerNotificaciones();
  /// setState(() => _notificaciones = data);
  Future<void> _cargarNotificaciones() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _notificaciones = [
        Notificacion(
          id: 1,
          titulo: 'Stock Bajo — Llantaa',
          tipo: 'alerta',
          mensaje: 'Solo quedan 3 unidades disponibles.',
          fecha: DateTime.now().subtract(const Duration(hours: 2)),
          leida: false,
        ),
        Notificacion(
          id: 2,
          titulo: 'Stock Bajo — Amortiguador Delantero',
          tipo: 'alerta',
          mensaje: 'Solo quedan 5 unidades disponibles.',
          fecha: DateTime.now().subtract(const Duration(days: 1)),
          leida: false,
        ),
        Notificacion(
          id: 3,
          titulo: 'Movimiento registrado',
          tipo: 'info',
          mensaje: 'Juan realizó una salida de 7 unidades de Amortiguador Delantero Reforzado.',
          fecha: DateTime.now().subtract(const Duration(days: 1)),
          leida: true,
        ),
      ];
      _cargando = false;
    });
  }

  int get _totalNuevas => _notificaciones.where((n) => !n.leida).length;

  void _marcarTodasLeidas() {
    setState(() {
      for (final n in _notificaciones) {
        n.leida = true;
      }
    });
  }

  void _marcarLeida(Notificacion n) {
    setState(() => n.leida = true);
  }

  void _eliminar(Notificacion n) {
    setState(() => _notificaciones.removeWhere((x) => x.id == n.id));
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }

  Map<String, Color> _coloresTipo(String tipo) {
    switch (tipo) {
      case 'alerta':
        return {'texto': AppColors.rojo, 'fondo': AppColors.rojoFondo, 'borde': AppColors.rojo};
      case 'exito':
        return {'texto': AppColors.verde, 'fondo': AppColors.verdeFondo, 'borde': AppColors.verde};
      case 'advertencia':
        return {'texto': AppColors.doradoOscuro, 'fondo': AppColors.doradoClaro.withValues(alpha: 0.35), 'borde': AppColors.dorado};
      default: // info
        return {'texto': AppColors.azul, 'fondo': AppColors.azulFondo, 'borde': AppColors.azul};
    }
  }

  String _etiquetaTipo(String tipo) {
    switch (tipo) {
      case 'alerta':
        return 'Alerta';
      case 'exito':
        return 'Éxito';
      case 'advertencia':
        return 'Advertencia';
      default:
        return 'Info';
    }
  }

  String _tiempoRelativo(DateTime fecha) {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} horas';
    if (diff.inDays == 1) return 'Hace 1 día';
    return 'Hace ${diff.inDays} días';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarNotificaciones,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Encabezado / título de la sección
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.doradoClaro),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Notificaciones',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      if (_totalNuevas > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.rojo,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_totalNuevas nuevas',
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Alertas y eventos del sistema',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ),
                      if (_totalNuevas > 0)
                        InkWell(
                          onTap: _marcarTodasLeidas,
                          child: const Text(
                            'Marcar todas como leídas',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.doradoOscuro,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Botón nueva notificación
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _mostrarProximamente('Nueva notificación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dorado,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva notificación',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 14),

            // Lista de notificaciones
            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_notificaciones.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No tienes notificaciones', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._notificaciones.map((n) => _tarjetaNotificacion(n)),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaNotificacion(Notificacion n) {
    final colores = _coloresTipo(n.tipo);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: n.leida ? Colors.white : colores['fondo'],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: (colores['borde'] as Color).withValues(alpha: n.leida ? 0.25 : 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: n.leida ? null : () => _marcarLeida(n),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Punto de estado (no leída = color, leída = gris)
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 8),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: n.leida ? Colors.grey.shade400 : colores['texto'],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    n.titulo,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: () => _eliminar(n),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.close, size: 16, color: AppColors.textoMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (colores['texto'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _etiquetaTipo(n.tipo),
                      style: TextStyle(
                        color: colores['texto'],
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _tiempoRelativo(n.fecha),
                    style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                n.mensaje,
                style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}