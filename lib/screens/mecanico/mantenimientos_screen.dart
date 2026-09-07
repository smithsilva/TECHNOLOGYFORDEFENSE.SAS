import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Ajusta esta ruta si tu archivo queda en otra ubicación dentro de lib/.
// Este archivo expone la variable `supabase` ya inicializada en main.dart.
import '../../services/supabase_client.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const azul = Color(0xFF2563EB);
  static const azulFondo = Color(0xFFE3EBFD);
  static const textoMuted = Color(0xFF6B7280);
  static const encabezado = Color(0xFF13202E);
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

// ============================================================
// PANTALLA
// ============================================================

class MantenimientosScreen extends StatefulWidget {
  /// Debe contener al menos 'id_usuario' (el id del mecánico logueado).
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

  RealtimeChannel? _canalAsignaciones;
  RealtimeChannel? _canalNotificaciones;

  int? get _idMecanico => widget.usuario?['id_usuario'] as int?;

  @override
  void initState() {
    super.initState();
    _cargarAsignaciones();
    _suscribirRealtime();
  }

  @override
  void dispose() {
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

    // IMPORTANTE: en Supabase, la tabla 'asignaciones_tareas' y
    // 'notificaciones' deben tener Realtime habilitado
    // (Database > Replication en el panel de Supabase).

    // 1) Cualquier cambio en asignaciones_tareas de este mecánico
    //    (INSERT cuando el admin crea una nueva, UPDATE cuando cambia
    //    de estado desde otro dispositivo, etc.) recarga la lista.
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

    // 2) Notificación nueva dirigida a este mecánico: mostramos un
    //    aviso visual además de refrescar la lista.
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
                  backgroundColor: AppColors.doradoOscuro,
                  content: Text(
                    (nuevo['titulo'] as String?) ?? 'Nueva asignación',
                  ),
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
        backgroundColor: esError ? Colors.red.shade700 : AppColors.verde,
        content: Text(texto),
      ),
    );
  }

  // ── Helpers de formato / estilo ───────────────────────────────
  Map<String, dynamic> _estiloEstado(String estado) {
    switch (estado) {
      case 'Finalizada':
        return {
          'texto': 'Finalizada',
          'color': AppColors.verde,
          'fondo': AppColors.verdeFondo
        };
      case 'En proceso':
        return {
          'texto': 'En proceso',
          'color': AppColors.azul,
          'fondo': AppColors.azulFondo
        };
      default:
        return {
          'texto': 'Pendiente',
          'color': AppColors.doradoOscuro,
          'fondo': AppColors.doradoClaro.withValues(alpha: 0.35),
        };
    }
  }

  String _formatoFecha(DateTime? f) {
    if (f == null) return '—';
    final dia = f.day.toString().padLeft(2, '0');
    final mes = f.month.toString().padLeft(2, '0');
    return '$dia/$mes/${f.year}';
  }

  String _formatoCOP(double v) {
    final entero = v.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < entero.length; i++) {
      final posDesdeElFinal = entero.length - i;
      buffer.write(entero[i]);
      if (posDesdeElFinal > 1 && posDesdeElFinal % 3 == 1) buffer.write('.');
    }
    return '\$$buffer';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarAsignaciones,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _encabezado(),
            const SizedBox(height: 14),
            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _bloqueError()
            else if (_asignaciones.isEmpty)
              _bloqueVacio()
            else
              ..._asignaciones.map((a) => _tarjetaAsignacion(a)),
          ],
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.doradoClaro),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mis Mantenimientos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text('Trabajos asignados y su estado',
                    style: TextStyle(fontSize: 12, color: AppColors.textoMuted)),
              ],
            ),
          ),
          Text(
            '${_asignaciones.length} tareas',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.doradoOscuro,
            ),
          ),
        ],
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
                style: const TextStyle(color: AppColors.textoMuted)),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _cargarAsignaciones,
              child: const Text('Reintentar'),
            ),
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
            Text('No tienes mantenimientos asignados',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaAsignacion(Asignacion a) {
    final estilo = _estiloEstado(a.estado);
    final bloqueado = _procesando.contains(a.idAsignacion);
    final online = a.metodoPago?.permiteOnline ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  a.vehiculo,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: estilo['fondo'] as Color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  estilo['texto'] as String,
                  style: TextStyle(
                    color: estilo['color'] as Color,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(a.tipoTrabajo,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.doradoOscuro)),
          if ((a.descripcion ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(a.descripcion!,
                style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
          ],

          // Cliente
          if (a.cliente != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 13, color: AppColors.textoMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${a.cliente!.nombreCompleto} · ${a.cliente!.tipoDocumento} ${a.cliente!.numeroDocumento}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textoMuted),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _formatoCOP(a.costo),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: online ? AppColors.azulFondo : AppColors.doradoClaro,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  online ? 'Online' : 'Presencial',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: online ? AppColors.azul : AppColors.doradoOscuro,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textoMuted),
              const SizedBox(width: 4),
              Text('Límite: ${_formatoFecha(a.fechaLimite)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
              const Spacer(),
              if (a.estado == 'Pendiente')
                _botonAccion(
                  texto: 'Aceptar',
                  color: AppColors.doradoOscuro,
                  bloqueado: bloqueado,
                  onTap: () => _aceptarTarea(a),
                ),
              if (a.estado == 'En proceso')
                _botonAccion(
                  texto: 'Finalizar',
                  color: AppColors.verde,
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
    required Color color,
    required bool bloqueado,
    required VoidCallback onTap,
  }) {
    return TextButton(
      onPressed: bloqueado ? null : onTap,
      style: TextButton.styleFrom(
        backgroundColor: bloqueado ? color.withValues(alpha: 0.5) : color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(texto,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}