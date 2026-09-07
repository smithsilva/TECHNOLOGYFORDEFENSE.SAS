import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Ajusta esta ruta si tu archivo queda en otra ubicación dentro de lib/.
// Este archivo expone la variable `supabase` ya inicializada en main.dart.
import '../../services/supabase_client.dart';

class _TareasColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const doradoMezcla = Color(0xFFAB812E);
  static const fondo = Color(0xFFFAF3E4);

  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);

  static const verde = Color(0xFF2E9E5B);
  static const verdeFondo = Color(0xFFDDF2E1);

  static const naranja = Color(0xFFA17A2E);
  static const naranjaFondo = Color(0xFFF5E3C3);

  static const rojo = Color(0xFFC0293B);
  static const rojoFondo = Color(0xFFFADCE0);

  static const textoMuted = Color(0xFF6B7280);
  static const enlace = Color(0xFF2563EB);

  static const white = Color(0xFFFFFFFF);
  static const gold = dorado;
  static const grayText = textoMuted;
  static const encabezado = navyOscuro;
  static const headerBg = navyOscuro;

  static const blue = enlace;
  static const blueBg = Color(0xFFE1EEFE);
  static const green = verde;
  static const greenBg = verdeFondo;
  static const orange = doradoOscuro;
  static const orangeBg = Color(0xFFFDF3DA);

  static const navy = encabezado;
}

// ============================================================
// MODELOS
// ============================================================

class ClienteInfo {
  final int idCliente;
  final String nombreCompleto;
  final String tipoDocumento;
  final String numeroDocumento;
  final String? telefono;
  final String? email;
  final String estado;

  ClienteInfo({
    required this.idCliente,
    required this.nombreCompleto,
    required this.tipoDocumento,
    required this.numeroDocumento,
    this.telefono,
    this.email,
    required this.estado,
  });

  factory ClienteInfo.fromMap(Map<String, dynamic> m) => ClienteInfo(
        idCliente: m['id_cliente'] as int,
        nombreCompleto: (m['nombre_completo'] ?? '') as String,
        tipoDocumento: (m['tipo_documento'] ?? '') as String,
        numeroDocumento: (m['numero_documento'] ?? '') as String,
        telefono: m['telefono'] as String?,
        email: m['email'] as String?,
        estado: (m['estado'] ?? '') as String,
      );
}

class MetodoPagoInfo {
  final String nombreMetodo;
  final bool permiteOnline;

  MetodoPagoInfo({required this.nombreMetodo, required this.permiteOnline});

  factory MetodoPagoInfo.fromMap(Map<String, dynamic> m) => MetodoPagoInfo(
        nombreMetodo: (m['nombre_metodo'] ?? '') as String,
        permiteOnline: (m['permite_online'] ?? false) as bool,
      );
}

class Asignacion {
  final int idAsignacion;
  final int? idMantenimiento;
  final int idMecanico;
  final String vehiculo;
  final String tipoTrabajo;
  final String? descripcion;
  final String prioridad;
  final DateTime? fechaLimite;
  final String estado; // 'Pendiente' | 'En proceso' | 'Finalizada'
  final DateTime fechaAsignacion;
  final double costo;
  final int idMetodoPago;
  final int? idCliente;
  final int idSucursal;
  final MetodoPagoInfo? metodoPago;
  final ClienteInfo? cliente;

  Asignacion({
    required this.idAsignacion,
    this.idMantenimiento,
    required this.idMecanico,
    required this.vehiculo,
    required this.tipoTrabajo,
    this.descripcion,
    required this.prioridad,
    this.fechaLimite,
    required this.estado,
    required this.fechaAsignacion,
    required this.costo,
    required this.idMetodoPago,
    this.idCliente,
    required this.idSucursal,
    this.metodoPago,
    this.cliente,
  });

  factory Asignacion.fromMap(Map<String, dynamic> m) {
    return Asignacion(
      idAsignacion: m['id_asignacion'] as int,
      idMantenimiento: m['id_mantenimiento'] as int?,
      idMecanico: m['id_mecanico'] as int,
      vehiculo: (m['vehiculo'] ?? '') as String,
      tipoTrabajo: (m['tipo_trabajo'] ?? '') as String,
      descripcion: m['descripcion'] as String?,
      prioridad: (m['prioridad'] ?? 'Media') as String,
      fechaLimite: m['fecha_limite'] != null
          ? DateTime.tryParse(m['fecha_limite'] as String)
          : null,
      estado: (m['estado'] ?? 'Pendiente') as String,
      fechaAsignacion:
          DateTime.tryParse((m['fecha_asignacion'] ?? '') as String) ??
              DateTime.now(),
      costo: ((m['costo'] as num?) ?? 0).toDouble(),
      idMetodoPago: m['id_metodo_pago'] as int,
      idCliente: m['id_cliente'] as int?,
      idSucursal: m['id_sucursal'] as int,
      metodoPago: m['metodos_pago'] != null
          ? MetodoPagoInfo.fromMap(m['metodos_pago'] as Map<String, dynamic>)
          : null,
      cliente: m['clientes'] != null
          ? ClienteInfo.fromMap(m['clientes'] as Map<String, dynamic>)
          : null,
    );
  }
}

String _fmtFecha(DateTime? f) {
  if (f == null) return '—';
  final dia = f.day.toString().padLeft(2, '0');
  final mes = f.month.toString().padLeft(2, '0');
  return '$dia/$mes/${f.year}';
}

String _fmtCOP(double v) {
  final entero = v.round().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < entero.length; i++) {
    final posDesdeElFinal = entero.length - i;
    buffer.write(entero[i]);
    if (posDesdeElFinal > 1 && posDesdeElFinal % 3 == 1) buffer.write('.');
  }
  return '\$$buffer';
}

Color _colorEstado(String estado) {
  switch (estado) {
    case 'Finalizada':
      return _TareasColors.green;
    case 'En proceso':
      return _TareasColors.blue;
    default:
      return _TareasColors.orange;
  }
}

Color _colorEstadoBg(String estado) {
  switch (estado) {
    case 'Finalizada':
      return _TareasColors.greenBg;
    case 'En proceso':
      return _TareasColors.blueBg;
    default:
      return _TareasColors.orangeBg;
  }
}

// ============================================================
// PANTALLA
// ============================================================

class MantenimientosScreen extends StatefulWidget {
  /// Debe contener al menos 'id_usuario' (el id del mecánico logueado)
  /// y opcionalmente 'username' para saludarlo.
  final Map<String, dynamic>? usuario;

  const MantenimientosScreen({super.key, this.usuario});

  @override
  State<MantenimientosScreen> createState() => _MantenimientosScreenState();
}

class _MantenimientosScreenState extends State<MantenimientosScreen> {
  bool _cargando = true;
  String? _error;
  List<Asignacion> _asignaciones = [];
  final Set<int> _procesando = {};

  final TextEditingController _searchController = TextEditingController();
  String _busqueda = '';
  String _filtroEstado = ''; // '' = Todos

  static const _tabsEstado = ['Todos', 'Pendiente', 'En proceso', 'Finalizada'];

  RealtimeChannel? _canalAsignaciones;
  RealtimeChannel? _canalNotificaciones;

  int? get _idMecanico => widget.usuario?['id_usuario'] as int?;

  List<Asignacion> get _filtradas {
    Iterable<Asignacion> lista = _asignaciones;
    if (_filtroEstado.isNotEmpty) {
      lista = lista.where((a) => a.estado == _filtroEstado);
    }
    if (_busqueda.trim().isNotEmpty) {
      final q = _busqueda.toLowerCase();
      lista = lista.where((a) {
        final cli = a.cliente?.nombreCompleto.toLowerCase() ?? '';
        return a.vehiculo.toLowerCase().contains(q) ||
            a.tipoTrabajo.toLowerCase().contains(q) ||
            cli.contains(q);
      });
    }
    return lista.toList();
  }

  int get _pendientes => _asignaciones.where((a) => a.estado == 'Pendiente').length;
  int get _enProceso => _asignaciones.where((a) => a.estado == 'En proceso').length;
  int get _finalizadas => _asignaciones.where((a) => a.estado == 'Finalizada').length;

  @override
  void initState() {
    super.initState();
    _cargarAsignaciones();
    _suscribirRealtime();
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_canalAsignaciones != null) supabase.removeChannel(_canalAsignaciones!);
    if (_canalNotificaciones != null) {
      supabase.removeChannel(_canalNotificaciones!);
    }
    super.dispose();
  }

  // ── Carga desde Supabase (equivalente a cargarAsignaciones en React) ──
  Future<void> _cargarAsignaciones() async {
    final idMec = _idMecanico;
    if (idMec == null) {
      setState(() {
        _cargando = false;
        _error = 'No se encontró el usuario mecánico.';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final data = await supabase.from('asignaciones_tareas').select('''
            id_asignacion, id_mantenimiento, id_mecanico, vehiculo, tipo_trabajo,
            descripcion, prioridad, fecha_limite, estado, fecha_asignacion,
            costo, id_metodo_pago, id_cliente, id_sucursal,
            metodos_pago(nombre_metodo, permite_online),
            clientes(id_cliente, nombre_completo, tipo_documento, numero_documento, telefono, email, estado)
          ''').eq('id_mecanico', idMec).order('fecha_asignacion', ascending: false);

      final lista = (data as List)
          .map((e) => Asignacion.fromMap(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _asignaciones = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudieron cargar tus tareas: $e';
      });
    }
  }

  // ── Realtime: aquí es donde "se agrega solito" ──────────────
  void _suscribirRealtime() {
    final idMec = _idMecanico;
    if (idMec == null) return;

    _canalAsignaciones = supabase
        .channel('asignaciones_mec_$idMec')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'asignaciones_tareas',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id_mecanico',
            value: idMec,
          ),
          callback: (payload) => _cargarAsignaciones(),
        )
        .subscribe();

    _canalNotificaciones = supabase
        .channel('notif_mec_$idMec')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notificaciones',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id_usuario',
            value: idMec,
          ),
          callback: (payload) {
            final nuevo = payload.newRecord;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _TareasColors.doradoOscuro,
                  content: Text((nuevo['titulo'] as String?) ?? 'Nueva asignación'),
                ),
              );
            }
            _cargarAsignaciones();
          },
        )
        .subscribe();
  }

  // ── Aceptar tarea (equivalente a aceptarTarea en React) ──────
  Future<void> _aceptarTarea(Asignacion a) async {
    if (_procesando.contains(a.idAsignacion)) return;
    setState(() => _procesando.add(a.idAsignacion));

    try {
      await supabase
          .from('asignaciones_tareas')
          .update({'estado': 'En proceso'}).eq('id_asignacion', a.idAsignacion);

      final total = a.costo;
      final subtotal = double.parse((total / 1.19).toStringAsFixed(2));
      final iva = double.parse((total - subtotal).toStringAsFixed(2));

      final mant = await supabase
          .from('mantenimiento')
          .insert({
            'fecha_hora': DateTime.now().toIso8601String(),
            'tipo_de_mantenimiento':
                (a.metodoPago?.permiteOnline ?? false) ? 'Online' : 'Fisica',
            'estado': 'Pendiente',
            'id_sucursal': a.idSucursal,
            'id_cliente': a.idCliente,
            'id_empleado_cajero': null,
            'subtotal': subtotal,
            'iva': iva,
            'total': total,
            'id_metodo_pago': a.idMetodoPago,
            'id_asignacion': a.idAsignacion,
          })
          .select('id_mantenimiento')
          .single();

      await supabase
          .from('asignaciones_tareas')
          .update({'id_mantenimiento': mant['id_mantenimiento']}).eq(
              'id_asignacion', a.idAsignacion);

      await _cargarAsignaciones();
      _mostrarMensaje('Tarea aceptada, se agregó a tus mantenimientos.');
    } catch (e) {
      _mostrarMensaje('Error al aceptar la tarea: $e', esError: true);
    } finally {
      if (mounted) setState(() => _procesando.remove(a.idAsignacion));
    }
  }

  // ── Finalizar tarea (equivalente a finalizarTarea en React) ──
  Future<void> _finalizarTarea(Asignacion a) async {
    if (_procesando.contains(a.idAsignacion)) return;
    setState(() => _procesando.add(a.idAsignacion));

    try {
      await supabase
          .from('asignaciones_tareas')
          .update({'estado': 'Finalizada'}).eq('id_asignacion', a.idAsignacion);

      await supabase
          .from('mantenimiento')
          .update({'estado': 'Completada'}).eq('id_asignacion', a.idAsignacion);

      await _cargarAsignaciones();
      _mostrarMensaje('Trabajo finalizado.');
    } catch (e) {
      _mostrarMensaje('Error al finalizar: $e', esError: true);
    } finally {
      if (mounted) setState(() => _procesando.remove(a.idAsignacion));
    }
  }

  void _mostrarMensaje(String texto, {bool esError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: esError ? Colors.red.shade700 : _TareasColors.verde,
        content: Text(texto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _TareasColors.fondo,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _cargarAsignaciones,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                  children: [
                    const _PageHeaderCard(),
                    const SizedBox(height: 14),
                    _StatsRow(
                      pendientes: _pendientes,
                      enProceso: _enProceso,
                      finalizadas: _finalizadas,
                      total: _asignaciones.length,
                    ),
                    const SizedBox(height: 14),
                    _SearchBar(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _busqueda = v),
                    ),
                    const SizedBox(height: 12),
                    _FilterTabs(
                      tabs: _tabsEstado,
                      seleccionado: _filtroEstado.isEmpty ? 'Todos' : _filtroEstado,
                      onSelected: (t) => setState(() => _filtroEstado = t == 'Todos' ? '' : t),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        '${_filtradas.length} TAREAS',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _TareasColors.grayText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_cargando)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_error != null)
                      _bloqueError()
                    else if (_filtradas.isEmpty)
                      _bloqueVacio()
                    else
                      ..._filtradas.map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _tarjetaAsignacion(a),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloqueError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 40, color: Colors.red.shade300),
            const SizedBox(height: 8),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _TareasColors.grayText)),
            const SizedBox(height: 10),
            TextButton(onPressed: _cargarAsignaciones, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  Widget _bloqueVacio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.build_outlined, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              _asignaciones.isEmpty ? 'No tienes mantenimientos asignados' : 'Sin resultados',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaAsignacion(Asignacion a) {
    final bloqueado = _procesando.contains(a.idAsignacion);
    final online = a.metodoPago?.permiteOnline ?? false;
    final colorEstado = _colorEstado(a.estado);
    final bgEstado = _colorEstadoBg(a.estado);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: colorEstado, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 15, color: _TareasColors.doradoOscuro),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(a.vehiculo,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: bgEstado, borderRadius: BorderRadius.circular(20)),
                child: Text(a.estado,
                    style: TextStyle(color: colorEstado, fontWeight: FontWeight.w700, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: _TareasColors.blueBg, borderRadius: BorderRadius.circular(20)),
            child: Text(a.tipoTrabajo,
                style: const TextStyle(fontSize: 10.5, color: _TareasColors.blue, fontWeight: FontWeight.w600)),
          ),
          if ((a.descripcion ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(a.descripcion!, style: const TextStyle(fontSize: 12, color: _TareasColors.grayText)),
          ],

          if (a.cliente != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 13, color: _TareasColors.grayText),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${a.cliente!.nombreCompleto} · ${a.cliente!.tipoDocumento} ${a.cliente!.numeroDocumento}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: _TareasColors.grayText),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 10),
          Row(
            children: [
              Text(_fmtCOP(a.costo),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: online ? _TareasColors.blueBg : _TareasColors.naranjaFondo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(online ? Icons.cloud_done_rounded : Icons.storefront_rounded,
                      size: 11, color: online ? _TareasColors.blue : _TareasColors.naranja),
                  const SizedBox(width: 4),
                  Text(online ? 'Online' : 'Presencial',
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: online ? _TareasColors.blue : _TareasColors.naranja)),
                ]),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: _TareasColors.grayText),
              const SizedBox(width: 4),
              Text('Límite: ${_fmtFecha(a.fechaLimite)}',
                  style: const TextStyle(fontSize: 11, color: _TareasColors.grayText)),
              const Spacer(),
              if (a.estado == 'Pendiente')
                _botonAccion(
                  texto: 'Aceptar',
                  icono: Icons.check_rounded,
                  bloqueado: bloqueado,
                  onTap: () => _aceptarTarea(a),
                ),
              if (a.estado == 'En proceso')
                _botonAccion(
                  texto: 'Finalizar',
                  icono: Icons.task_alt_rounded,
                  colorSolido: _TareasColors.verde,
                  bloqueado: bloqueado,
                  onTap: () => _finalizarTarea(a),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botonAccion({
    required String texto,
    required IconData icono,
    required bool bloqueado,
    required VoidCallback onTap,
    Color? colorSolido,
  }) {
    return Material(
      color: bloqueado
          ? (colorSolido ?? _TareasColors.dorado).withValues(alpha: 0.5)
          : (colorSolido ?? _TareasColors.dorado),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: bloqueado ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icono, size: 14, color: colorSolido != null ? Colors.white : _TareasColors.navyOscuro),
            const SizedBox(width: 5),
            Text(texto,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: colorSolido != null ? Colors.white : _TareasColors.navyOscuro)),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
// TARJETA OSCURA DE BIENVENIDA
// ============================================================
class _PageHeaderCard extends StatelessWidget {
  const _PageHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: _TareasColors.navy, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MECÁNICO · MIS TAREAS',
                    style: TextStyle(
                        color: _TareasColors.dorado, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                const SizedBox(height: 6),
                const Text('Mis\nMantenimientos',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.15)),
                const SizedBox(height: 6),
                const Text('Trabajos asignados y su estado',
                    style: TextStyle(color: _TareasColors.subtitulo, fontSize: 12.5)),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: _TareasColors.dorado, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.build_rounded, color: _TareasColors.navyOscuro, size: 24),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FILA DE ESTADÍSTICAS COMPACTAS
// ============================================================
class _StatsRow extends StatelessWidget {
  final int pendientes;
  final int enProceso;
  final int finalizadas;
  final int total;

  const _StatsRow({
    required this.pendientes,
    required this.enProceso,
    required this.finalizadas,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    Widget box(String valor, String label, Color color) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE9E1D0)),
            ),
            child: Column(
              children: [
                Text(valor, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: color)),
                const SizedBox(height: 2),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: _TareasColors.grayText)),
              ],
            ),
          ),
        );

    return Row(
      children: [
        box('$pendientes', 'Pendientes', _TareasColors.orange),
        const SizedBox(width: 8),
        box('$enProceso', 'En proceso', _TareasColors.blue),
        const SizedBox(width: 8),
        box('$finalizadas', 'Finalizadas', _TareasColors.green),
        const SizedBox(width: 8),
        box('$total', 'Total', _TareasColors.doradoOscuro),
      ],
    );
  }
}

// ============================================================
// BARRA DE BÚSQUEDA
// ============================================================
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Buscar vehículo, tipo o cliente...',
        hintStyle: const TextStyle(fontSize: 12.5, color: _TareasColors.grayText),
        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: _TareasColors.grayText),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFE9E1D0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFE9E1D0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _TareasColors.dorado),
        ),
      ),
    );
  }
}

// ============================================================
// PASTILLAS DE FILTRO
// ============================================================
class _FilterTabs extends StatelessWidget {
  final List<String> tabs;
  final String seleccionado;
  final ValueChanged<String> onSelected;
  const _FilterTabs({required this.tabs, required this.seleccionado, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((t) {
          final activo = t == seleccionado;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(t),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: activo ? _TareasColors.dorado : const Color(0xFFE9E1D0), width: 1.4),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                    color: activo ? _TareasColors.doradoOscuro : _TareasColors.grayText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}