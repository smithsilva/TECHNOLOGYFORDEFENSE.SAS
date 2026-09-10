import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/notificacion.dart';
import '../../services/notificaciones_service.dart';

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
  final NotificacionesService _service = NotificacionesService();

  bool _cargando = false;
  String? _error;
  List<Notificacion> _notificaciones = [];

  /// El token vive en SharedPreferences (ver login_screen.dart), NO en
  /// widget.usuario. Mismo patrón que en historial_precios_screen.dart.
  Future<String?> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  Future<void> _cargarNotificaciones() async {
    final token = await _obtenerToken();

    if (token == null || token.isEmpty) {
      setState(() {
        _error = 'No se encontró el token de sesión. Vuelve a iniciar sesión.';
        _cargando = false;
      });
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final data = await _service.obtenerNotificaciones(token);
      if (!mounted) return;
      setState(() {
        _notificaciones = data;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar notificaciones: $e';
        _cargando = false;
      });
    }
  }

  int get _totalNuevas => _notificaciones.where((n) => !n.leido).length;

  Future<void> _marcarTodasLeidas() async {
    final token = await _obtenerToken();
    if (token == null) return;

    final pendientes = _notificaciones.where((n) => !n.leido).toList();
    for (final n in pendientes) {
      try {
        await _service.marcarLeida(token, n.id);
        if (mounted) setState(() => n.leido = true);
      } catch (_) {
        // si una falla, seguimos con las demás
      }
    }
  }

  Future<void> _marcarLeida(Notificacion n) async {
    if (n.leido) return;
    final token = await _obtenerToken();
    if (token == null) return;

    try {
      await _service.marcarLeida(token, n.id);
      if (!mounted) return;
      setState(() => n.leido = true);
    } catch (e) {
      _mostrarSnack('No se pudo marcar como leída: $e', color: AppColors.rojo);
    }
  }

  void _mostrarSnack(String texto, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: color),
    );
  }

  // =======================================================================
  // NUEVA NOTIFICACIÓN (envía a todos los roles)
  // =======================================================================
  void _abrirNuevaNotificacion() {
    final tituloCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();
    bool enviando = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Nuevo mensaje'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📢 Esta notificación le llegará a todos los roles del sistema.',
                style: TextStyle(fontSize: 12, color: AppColors.textoMuted),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(
                  labelText: 'Asunto',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descripcionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: enviando ? null : () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.dorado),
              onPressed: enviando
                  ? null
                  : () async {
                      final titulo = tituloCtrl.text.trim();
                      final descripcion = descripcionCtrl.text.trim();
                      if (titulo.isEmpty || descripcion.isEmpty) {
                        _mostrarSnack('Completa asunto y mensaje', color: AppColors.rojo);
                        return;
                      }
                      final token = await _obtenerToken();
                      if (token == null) return;

                      setDialogState(() => enviando = true);
                      try {
                        await _service.enviarATodos(
                          token,
                          titulo: titulo,
                          descripcion: descripcion,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        _mostrarSnack('Notificación enviada', color: AppColors.verde);
                        _cargarNotificaciones();
                      } catch (e) {
                        setDialogState(() => enviando = false);
                        _mostrarSnack('No se pudo enviar: $e', color: AppColors.rojo);
                      }
                    },
              child: Text(enviando ? 'Enviando...' : 'Enviar'),
            ),
          ],
        ),
      ),
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
            const SizedBox(height: 14),

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.rojoFondo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.rojo, fontSize: 13)),
              ),
              const SizedBox(height: 14),
            ],

            _separadorNotificaciones(_notificaciones.length),
            const SizedBox(height: 12),

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
                        (widget.usuario?['rol']?.toString().toUpperCase() ?? 'ADMINISTRADOR') +
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
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Notificaciones',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
                        onPressed: _abrirNuevaNotificacion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dorado,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
            color: n.leido ? Colors.white : colorFondo,
            border: Border.all(color: colorPrincipal.withValues(alpha: n.leido ? 0.25 : 0.5)),
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
              Container(height: 3, color: colorPrincipal),
              InkWell(
                onTap: n.leido ? null : () => _marcarLeida(n),
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
                            decoration: BoxDecoration(color: colorFondo, shape: BoxShape.circle),
                            child: Icon(_iconoTipo(n.tipo), size: 14, color: colorPrincipal),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                n.titulo,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorPrincipal.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _etiquetaTipo(n.tipo),
                                style: TextStyle(color: colorPrincipal, fontWeight: FontWeight.w700, fontSize: 10),
                              ),
                            ),
                            Text(
                              _tiempoRelativo(n.fecha),
                              style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                            ),
                            if (!n.leido)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.rojo,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Nueva',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 34),
                        child: Text(
                          n.descripcion,
                          style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
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