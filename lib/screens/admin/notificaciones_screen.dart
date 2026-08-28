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

  // Colores del header oscuro (mismos que en Movimientos)
  static const headerOscuro = Color(0xFF15151F);
  static const headerOscuro2 = Color(0xFF1E1E2C);
  static const botonOscuro = Color(0xFF2B2B3A);
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
        return {
          'texto': AppColors.doradoOscuro,
          'fondo': AppColors.doradoClaro.withValues(alpha: 0.35),
          'borde': AppColors.dorado,
        };
      default: // info
        return {'texto': AppColors.azul, 'fondo': AppColors.azulFondo, 'borde': AppColors.azul};
    }
  }

  IconData _iconoTipo(String tipo) {
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
            _encabezado(),
            const SizedBox(height: 18),

            // Separador "N NOTIFICACIONES"
            _separadorNotificaciones(_notificaciones.length),
            const SizedBox(height: 12),

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
                      Text('No tienes notificaciones',
                          style: TextStyle(color: Colors.grey.shade600)),
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

  // ---------- ENCABEZADO OSCURO ----------
  Widget _encabezado() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.headerOscuro, AppColors.headerOscuro2],
          ),
        ),
        child: Stack(
          children: [
            // círculo decorativo
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.dorado.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        (widget.usuario?['rol']?.toString().toUpperCase() ??
                                'ADMINISTRADOR') +
                            ' · NOTIFICACIONES',
                        style: const TextStyle(
                          color: AppColors.dorado,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
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
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Notificaciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Alertas y eventos del sistema',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _mostrarProximamente('Nueva notificación'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dorado,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 17),
                        label: const Text(
                          'Nueva notificación',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _totalNuevas > 0 ? _marcarTodasLeidas : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.botonOscuro,
                          disabledBackgroundColor: AppColors.botonOscuro.withValues(alpha: 0.5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        icon: const Icon(Icons.check, size: 17),
                        label: const Text(
                          'Marcar leídas',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- SEPARADOR "N NOTIFICACIONES" ----------
  Widget _separadorNotificaciones(int cantidad) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.doradoClaro.withValues(alpha: 0.6))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$cantidad NOTIFICACION${cantidad == 1 ? '' : 'ES'}',
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textoMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.doradoClaro.withValues(alpha: 0.6))),
      ],
    );
  }

  // ---------- TARJETA DE NOTIFICACIÓN ----------
  // Nota: la franja de color superior se separa del borde (Container aparte
  // dentro de una Column, no un Border con colores distintos + borderRadius)
  // para evitar el error de Flutter "borderRadius can only be given on
  // borders with uniform colors" que rompía el pintado en Movimientos.
  Widget _tarjetaNotificacion(Notificacion n) {
    final colores = _coloresTipo(n.tipo);
    final colorPrincipal = colores['texto'] as Color;
    final colorFondo = colores['fondo'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: n.leida ? Colors.white : colorFondo,
            border: Border.all(
              color: colorPrincipal.withValues(alpha: n.leida ? 0.25 : 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 3, color: colorPrincipal), // franja superior
              InkWell(
                onTap: n.leida ? null : () => _marcarLeida(n),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: colorFondo,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _iconoTipo(n.tipo),
                              size: 14,
                              color: colorPrincipal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                n.titulo,
                                style:
                                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
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
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 34),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorPrincipal.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _etiquetaTipo(n.tipo),
                                style: TextStyle(
                                  color: colorPrincipal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Text(
                              _tiempoRelativo(n.fecha),
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textoMuted),
                            ),
                            if (!n.leida)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.rojo,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Nueva',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 34),
                        child: Text(
                          n.mensaje,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}