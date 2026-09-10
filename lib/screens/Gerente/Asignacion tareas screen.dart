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
// MODELOS DESDE SUPABASE
// ============================================================

class MecanicoInfo {
  final int idUsuario;
  final String username;
  MecanicoInfo({required this.idUsuario, required this.username});
  factory MecanicoInfo.fromMap(Map<String, dynamic> m) => MecanicoInfo(
        idUsuario: m['id_usuario'] as int,
        username: (m['username'] ?? '') as String,
      );
}

class SucursalInfo {
  final int idSucursal;
  final String nombreSucursal;
  SucursalInfo({required this.idSucursal, required this.nombreSucursal});
  factory SucursalInfo.fromMap(Map<String, dynamic> m) => SucursalInfo(
        idSucursal: m['id_sucursal'] as int,
        nombreSucursal: (m['nombre_sucursal'] ?? '') as String,
      );
}

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
  final int idMetodoPago;
  final String nombreMetodo;
  final bool permiteOnline;
  MetodoPagoInfo({
    required this.idMetodoPago,
    required this.nombreMetodo,
    required this.permiteOnline,
  });
  factory MetodoPagoInfo.fromMap(Map<String, dynamic> m) => MetodoPagoInfo(
        idMetodoPago: m['id_metodo_pago'] as int,
        nombreMetodo: (m['nombre_metodo'] ?? '') as String,
        permiteOnline: (m['permite_online'] ?? false) as bool,
      );
}

class AsignacionAdmin {
  final int idAsignacion;
  final String vehiculo;
  final String tipoTrabajo;
  final String? descripcion;
  final String prioridad;
  final DateTime? fechaLimite;
  final String estado;
  final double costo;
  final MetodoPagoInfo? metodoPago;
  final MecanicoInfo? mecanico;
  final ClienteInfo? cliente;
  final SucursalInfo? sucursal;

  AsignacionAdmin({
    required this.idAsignacion,
    required this.vehiculo,
    required this.tipoTrabajo,
    this.descripcion,
    required this.prioridad,
    this.fechaLimite,
    required this.estado,
    required this.costo,
    this.metodoPago,
    this.mecanico,
    this.cliente,
    this.sucursal,
  });

  factory AsignacionAdmin.fromMap(Map<String, dynamic> m) => AsignacionAdmin(
        idAsignacion: m['id_asignacion'] as int,
        vehiculo: (m['vehiculo'] ?? '') as String,
        tipoTrabajo: (m['tipo_trabajo'] ?? '') as String,
        descripcion: m['descripcion'] as String?,
        prioridad: (m['prioridad'] ?? 'Media') as String,
        fechaLimite: m['fecha_limite'] != null
            ? DateTime.tryParse(m['fecha_limite'] as String)
            : null,
        estado: (m['estado'] ?? 'Pendiente') as String,
        costo: ((m['costo'] as num?) ?? 0).toDouble(),
        metodoPago: m['metodos_pago'] != null
            ? MetodoPagoInfo.fromMap(m['metodos_pago'] as Map<String, dynamic>)
            : null,
        mecanico: m['usuarios'] != null
            ? MecanicoInfo.fromMap(m['usuarios'] as Map<String, dynamic>)
            : null,
        cliente: m['clientes'] != null
            ? ClienteInfo.fromMap(m['clientes'] as Map<String, dynamic>)
            : null,
        sucursal: m['sucursales'] != null
            ? SucursalInfo.fromMap(m['sucursales'] as Map<String, dynamic>)
            : null,
      );
}

String fmtFecha(DateTime? f) {
  if (f == null) return '—';
  final d = f.day.toString().padLeft(2, '0');
  final m = f.month.toString().padLeft(2, '0');
  return '$d/$m/${f.year}';
}

String fmtCOP(num? v) {
  if (v == null) return '—';
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

Color _colorPrioridad(String p) {
  switch (p) {
    case 'Alta':
      return _TareasColors.rojo;
    case 'Media':
      return _TareasColors.doradoMezcla;
    default:
      return _TareasColors.textoMuted;
  }
}

Color _colorPrioridadBg(String p) {
  switch (p) {
    case 'Alta':
      return _TareasColors.rojoFondo;
    case 'Media':
      return _TareasColors.doradoClaro;
    default:
      return const Color(0xFFE5E7EB);
  }
}

// ============================================================
// PANTALLA PRINCIPAL (ADMIN / GERENTE)
// ============================================================
class AsignacionTareasScreen extends StatefulWidget {
  final bool embedded;
  const AsignacionTareasScreen({super.key, this.embedded = false});

  @override
  State<AsignacionTareasScreen> createState() => _AsignacionTareasScreenState();
}

class _AsignacionTareasScreenState extends State<AsignacionTareasScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _cargando = true;
  String? _error;
  List<AsignacionAdmin> _asignaciones = [];
  String _busqueda = '';
  String _filtroEstado = ''; // '' = Todos
  RealtimeChannel? _canal;

  static const _tabsEstado = ['Todos', 'Pendiente', 'En proceso', 'Finalizada'];

  List<AsignacionAdmin> get _filtradas {
    Iterable<AsignacionAdmin> lista = _asignaciones;
    if (_filtroEstado.isNotEmpty) {
      lista = lista.where((a) => a.estado == _filtroEstado);
    }
    if (_busqueda.trim().isNotEmpty) {
      final q = _busqueda.toLowerCase();
      lista = lista.where((a) {
        final mec = a.mecanico?.username.toLowerCase() ?? '';
        final cli = a.cliente?.nombreCompleto.toLowerCase() ?? '';
        final suc = a.sucursal?.nombreSucursal.toLowerCase() ?? '';
        return a.vehiculo.toLowerCase().contains(q) ||
            mec.contains(q) ||
            cli.contains(q) ||
            suc.contains(q);
      });
    }
    return lista.toList();
  }

  int get pendientes => _asignaciones.where((a) => a.estado == 'Pendiente').length;
  int get enProceso => _asignaciones.where((a) => a.estado == 'En proceso').length;
  int get finalizadas => _asignaciones.where((a) => a.estado == 'Finalizada').length;
  int get altaPrioridad => _asignaciones.where((a) => a.prioridad == 'Alta').length;

  @override
  void initState() {
    super.initState();
    _cargarAsignaciones();
    _suscribirRealtime();
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_canal != null) supabase.removeChannel(_canal!);
    super.dispose();
  }

  Future<void> _cargarAsignaciones() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final data = await supabase.from('asignaciones_tareas').select('''
            id_asignacion, vehiculo, tipo_trabajo, descripcion,
            prioridad, fecha_limite, estado, costo,
            metodos_pago(id_metodo_pago, nombre_metodo, permite_online),
            usuarios!fk_mecanico(id_usuario, username),
            clientes(id_cliente, nombre_completo, tipo_documento, numero_documento, telefono, email, estado),
            sucursales(id_sucursal, nombre_sucursal)
          ''').order('id_asignacion', ascending: false);

      final lista = (data as List)
          .map((e) => AsignacionAdmin.fromMap(e as Map<String, dynamic>))
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
        _error = 'No se pudieron cargar las asignaciones: $e';
      });
    }
  }

  void _suscribirRealtime() {
    _canal = supabase
        .channel('admin_asignaciones')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'asignaciones_tareas',
          callback: (payload) => _cargarAsignaciones(),
        )
        .subscribe();
  }

  Future<void> _abrirModalNueva() async {
    final creada = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _NuevaAsignacionDialog(),
    );
    if (creada == true) {
      _cargarAsignaciones();
    }
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        _PageHeaderCard(onNuevaAsignacion: _abrirModalNueva),
        const SizedBox(height: 14),
        _StatsRow(
          pendientes: pendientes,
          enProceso: enProceso,
          finalizadas: finalizadas,
          altaPrioridad: altaPrioridad,
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
            '${_filtradas.length} ASIGNACIONES',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Column(
                children: [
                  Text(_error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _cargarAsignaciones, child: const Text('Reintentar')),
                ],
              ),
            ),
          )
        else if (_filtradas.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: Text('Sin resultados')),
          )
        else
          ...List.generate(_filtradas.length, (i) {
            final numero = _asignaciones.length - _asignaciones.indexOf(_filtradas[i]);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AssignmentCard(assignment: _filtradas[i], numero: numero),
            );
          }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) return _buildContent(context);

    return Scaffold(
      backgroundColor: _TareasColors.fondo,
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(onMenuTap: () {}),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HEADER SUPERIOR OSCURO
// ============================================================
class _TopHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _TopHeader({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _TareasColors.headerBg,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: onMenuTap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.menu_rounded, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _TareasColors.dorado,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('T4D',
                style: TextStyle(color: _TareasColors.navyOscuro, fontWeight: FontWeight.w900, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('BIENVENIDO',
                    style: TextStyle(
                        color: _TareasColors.dorado, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                Text('Asignación de Tareas',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: _TareasColors.navyClaro,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: _TareasColors.dorado,
                  child: Icon(Icons.person_rounded, size: 11, color: _TareasColors.navyOscuro),
                ),
                SizedBox(width: 5),
                Text('Gerente', style: TextStyle(color: Colors.white, fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA OSCURA CON TÍTULO Y BOTÓN "+ NUEVA ASIGNACIÓN"
// ============================================================
class _PageHeaderCard extends StatelessWidget {
  final VoidCallback onNuevaAsignacion;
  const _PageHeaderCard({required this.onNuevaAsignacion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: _TareasColors.navy, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GERENTE · ASIGNACIONES',
                    style: TextStyle(
                        color: _TareasColors.dorado, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                const SizedBox(height: 6),
                const Text('Asignación\nde Tareas',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.15)),
                const SizedBox(height: 6),
                const Text('Gestiona el trabajo de los mecánicos',
                    style: TextStyle(color: _TareasColors.subtitulo, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _GoldButton(icon: Icons.add_rounded, label: 'Nueva Asignación', onTap: onNuevaAsignacion),
        ],
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _GoldButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _TareasColors.gold,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: _TareasColors.navyOscuro),
            const SizedBox(width: 5),
            Flexible(
              child: Text(label,
                  style: const TextStyle(
                      color: _TareasColors.navyOscuro, fontWeight: FontWeight.w700, fontSize: 11.5),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
            ),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
// FILA DE 4 ESTADÍSTICAS COMPACTAS (con borde superior de color)
// ============================================================
class _StatsRow extends StatelessWidget {
  final int pendientes;
  final int enProceso;
  final int finalizadas;
  final int altaPrioridad;

  const _StatsRow({
    required this.pendientes,
    required this.enProceso,
    required this.finalizadas,
    required this.altaPrioridad,
  });

  @override
  Widget build(BuildContext context) {
    Widget box(String valor, String label, Color color) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border(
                top: BorderSide(color: color, width: 3),
                left: const BorderSide(color: Color(0xFFE9E1D0)),
                right: const BorderSide(color: Color(0xFFE9E1D0)),
                bottom: const BorderSide(color: Color(0xFFE9E1D0)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
        box('$altaPrioridad', 'Alta prio.', _TareasColors.rojo),
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
        hintText: 'Buscar vehículo, mecánico, cliente...',
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
// PASTILLAS DE FILTRO (Todos / Pendiente / En proceso / Finalizada)
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

// ============================================================
// TARJETA INDIVIDUAL CON BORDE DE COLOR SEGÚN ESTADO
// ============================================================
class _AssignmentCard extends StatelessWidget {
  final AsignacionAdmin assignment;
  final int numero;
  const _AssignmentCard({required this.assignment, required this.numero});

  @override
  Widget build(BuildContext context) {
    final a = assignment;
    final colorEstado = _colorEstado(a.estado);
    final bgEstado = _colorEstadoBg(a.estado);
    final colorPrio = _colorPrioridad(a.prioridad);
    final bgPrio = _colorPrioridadBg(a.prioridad);
    final online = a.metodoPago?.permiteOnline ?? false;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
                child: Text(
                  '#$numero ${a.cliente?.nombreCompleto ?? "Sin cliente"}',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: a.cliente != null ? const Color(0xFF111827) : _TareasColors.grayText,
                    fontStyle: a.cliente != null ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: bgEstado, borderRadius: BorderRadius.circular(20)),
                child: Text(a.estado,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: colorEstado)),
              ),
            ],
          ),
          if (a.cliente != null) ...[
            const SizedBox(height: 2),
            Text('${a.cliente!.tipoDocumento} ${a.cliente!.numeroDocumento}',
                style: const TextStyle(fontSize: 10.5, color: _TareasColors.grayText)),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 14, color: _TareasColors.grayText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(a.vehiculo,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: _TareasColors.blueBg, borderRadius: BorderRadius.circular(20)),
                child: Text(a.tipoTrabajo,
                    style: const TextStyle(fontSize: 10.5, color: _TareasColors.blue, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          if ((a.descripcion ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(a.descripcion!, style: const TextStyle(fontSize: 12, color: _TareasColors.grayText)),
          ],
          const SizedBox(height: 10),
          Text(fmtCOP(a.costo),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 13, color: _TareasColors.grayText),
              const SizedBox(width: 3),
              Text(a.mecanico?.username ?? '—', style: const TextStyle(fontSize: 11, color: _TareasColors.grayText)),
              const SizedBox(width: 10),
              const Icon(Icons.location_on_outlined, size: 13, color: _TareasColors.grayText),
              const SizedBox(width: 3),
              Expanded(
                child: Text(a.sucursal?.nombreSucursal ?? '—',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: _TareasColors.grayText)),
              ),
              const SizedBox(width: 6),
              if (a.fechaLimite != null) ...[
                const Icon(Icons.calendar_today_outlined, size: 12, color: _TareasColors.grayText),
                const SizedBox(width: 3),
                Text(fmtFecha(a.fechaLimite), style: const TextStyle(fontSize: 10.5, color: _TareasColors.grayText)),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: bgPrio, borderRadius: BorderRadius.circular(20)),
                child: Text(a.prioridad,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: colorPrio)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DIÁLOGO: NUEVA ASIGNACIÓN (conectado a Supabase)
// ============================================================
class _NuevaAsignacionDialog extends StatefulWidget {
  const _NuevaAsignacionDialog();

  @override
  State<_NuevaAsignacionDialog> createState() => _NuevaAsignacionDialogState();
}

class _NuevaAsignacionDialogState extends State<_NuevaAsignacionDialog> {
  bool _cargandoOpciones = true;
  bool _guardando = false;
  bool _enviando = false; // candado sincrónico anti doble-tap
  String? _errorCarga;

  List<MecanicoInfo> _mecanicos = [];
  List<SucursalInfo> _sucursales = [];
  List<ClienteInfo> _clientes = [];
  List<MetodoPagoInfo> _metodosPago = [];

  final _vehiculoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _costoCtrl = TextEditingController();

  int? _idMecanico;
  int? _idSucursal;
  int? _idCliente;
  int? _idMetodoPago;
  String _tipoTrabajo = 'Mantenimiento';
  String _prioridad = 'Alta';
  DateTime? _fechaLimite;

  static const _tiposTrabajo = ['Mantenimiento', 'Reparación', 'Blindamiento', 'Inspección'];
  static const _prioridades = ['Alta', 'Media', 'Baja'];

  @override
  void initState() {
    super.initState();
    _cargarOpciones();
  }

  @override
  void dispose() {
    _vehiculoCtrl.dispose();
    _descripcionCtrl.dispose();
    _costoCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarOpciones() async {
    setState(() {
      _cargandoOpciones = true;
      _errorCarga = null;
    });
    try {
      final results = await Future.wait([
        supabase
            .from('usuarios')
            .select('id_usuario, username')
            .eq('rol', 'Mecanico')
            .eq('activo', true)
            .order('username'),
        supabase.from('sucursales').select('id_sucursal, nombre_sucursal').order('id_sucursal'),
        supabase
            .from('clientes')
            .select('id_cliente, nombre_completo, tipo_documento, numero_documento, telefono, email, estado')
            .order('nombre_completo'),
        supabase.from('metodos_pago').select('id_metodo_pago, nombre_metodo, permite_online').order('id_metodo_pago'),
      ]);

      final mecanicosRaw = (results[0] as List).cast<Map<String, dynamic>>();
      final vistos = <int>{};
      final mecanicosUnicos = <MecanicoInfo>[];
      for (final m in mecanicosRaw) {
        final id = m['id_usuario'] as int;
        if (vistos.add(id)) mecanicosUnicos.add(MecanicoInfo.fromMap(m));
      }

      final sucursales = (results[1] as List)
          .map((e) => SucursalInfo.fromMap(e as Map<String, dynamic>))
          .toList();
      final clientes = (results[2] as List)
          .map((e) => ClienteInfo.fromMap(e as Map<String, dynamic>))
          .toList();
      final metodosPago = (results[3] as List)
          .map((e) => MetodoPagoInfo.fromMap(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _mecanicos = mecanicosUnicos;
        _sucursales = sucursales;
        _clientes = clientes;
        _metodosPago = metodosPago;
        if (mecanicosUnicos.length == 1) _idMecanico = mecanicosUnicos.first.idUsuario;
        if (metodosPago.isNotEmpty) _idMetodoPago = metodosPago.first.idMetodoPago;
        _cargandoOpciones = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargandoOpciones = false;
        _errorCarga = 'No se pudieron cargar las opciones: $e';
      });
    }
  }

  void _alerta(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
    );
  }

  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaLimite ?? ahora,
      firstDate: ahora.subtract(const Duration(days: 1)),
      lastDate: ahora.add(const Duration(days: 730)),
    );
    if (seleccionada != null) setState(() => _fechaLimite = seleccionada);
  }

  // ── Crear asignación: mismo flujo que crearAsignacion() en React ──
  Future<void> _crearAsignacion() async {
    if (_enviando) return;

    final vehiculo = _vehiculoCtrl.text.trim();
    final costo = double.tryParse(_costoCtrl.text.replaceAll(',', '.'));

    if (vehiculo.isEmpty) return _alerta('El vehículo es obligatorio.');
    if (_idMecanico == null) return _alerta('Selecciona el mecánico a asignar.');
    if (costo == null || costo <= 0) return _alerta('Ingresa un costo válido.');
    if (_idMetodoPago == null) return _alerta('Selecciona un método de pago.');
    if (_idSucursal == null) return _alerta('Selecciona la sucursal.');

    _enviando = true;
    setState(() => _guardando = true);

    try {
      final asignada = await supabase
          .from('asignaciones_tareas')
          .insert({
            'id_cliente': _idCliente,
            'vehiculo': vehiculo,
            'tipo_trabajo': _tipoTrabajo,
            'descripcion': _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
            'id_mecanico': _idMecanico,
            'prioridad': _prioridad,
            'fecha_limite': _fechaLimite != null
                ? _fechaLimite!.toIso8601String().split('T').first
                : null,
            'estado': 'Pendiente',
            'costo': costo,
            'id_metodo_pago': _idMetodoPago,
            'id_sucursal': _idSucursal,
          })
          .select('id_asignacion, id_mecanico')
          .single();

      final idAsignacion = asignada['id_asignacion'] as int;
      final idMecanicoAsignado = asignada['id_mecanico'] as int;

      final clienteSel = _idCliente != null
          ? _clientes.firstWhere((c) => c.idCliente == _idCliente)
          : null;

      final conceptoContable =
          '$_tipoTrabajo — Vehículo: $vehiculo${clienteSel != null ? ' — Cliente: ${clienteSel.nombreCompleto}' : ''}';

      try {
        await supabase.from('movimientos_contables').insert({
          'tipo_movimiento': 'Egreso',
          'concepto': conceptoContable,
          'id_asignacion': idAsignacion,
          'id_mantenimiento': null,
          'valor': costo,
          'fecha_movimiento': DateTime.now().toIso8601String().split('T').first,
          'id_usuario_registro': null,
        });
      } catch (e) {
        debugPrint('Error creando movimiento contable: $e');
      }

      final parteCliente = clienteSel != null
          ? ' | Cliente: ${clienteSel.nombreCompleto} (${clienteSel.tipoDocumento} ${clienteSel.numeroDocumento})'
          : '';
      try {
        await supabase.from('notificaciones').insert({
          'titulo': 'Nueva asignación',
          'descripcion': 'Nuevo trabajo de $_tipoTrabajo — Vehículo: $vehiculo$parteCliente',
          'leido': false,
          'rol_destino': 'Mecanico',
          'id_usuario': idMecanicoAsignado,
          'id_asignacion': idAsignacion,
        });
      } catch (e) {
        debugPrint('Error creando notificación: $e');
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _alerta('Error al guardar: $e');
    } finally {
      _enviando = false;
      if (mounted) setState(() => _guardando = false);
    }
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: _TareasColors.fondo,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _TareasColors.dorado),
        ),
      );

  Widget _label(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 2),
        child: Text(texto, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    final metodoSel = _metodosPago.where((m) => m.idMetodoPago == _idMetodoPago).toList();
    final clienteSel = _clientes.where((c) => c.idCliente == _idCliente).toList();
    final mecanicoSel = _mecanicos.where((m) => m.idUsuario == _idMecanico).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Encabezado oscuro
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
                  color: _TareasColors.navy,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: _TareasColors.dorado, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Icon(Icons.local_shipping_outlined, color: _TareasColors.navyOscuro, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Nueva Asignación',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 2),
                            Text('Gerente · Asignaciones',
                                style: TextStyle(color: _TareasColors.subtitulo, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.white),
                        onPressed: _guardando ? null : () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                ),

                // Cuerpo del formulario
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _cargandoOpciones
                        ? const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : _errorCarga != null
                            ? SizedBox(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_errorCarga!, textAlign: TextAlign.center),
                                      const SizedBox(height: 10),
                                      TextButton(onPressed: _cargarOpciones, child: const Text('Reintentar')),
                                    ],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label('Mecánico asignado'),
                                    if (_mecanicos.isEmpty)
                                      const Text('No se encontraron mecánicos activos',
                                          style: TextStyle(color: Colors.red, fontSize: 12))
                                    else
                                      DropdownButtonFormField<int>(
                                        initialValue: _idMecanico,
                                        decoration: _dec('Selecciona mecánico'),
                                        items: _mecanicos
                                            .map((m) => DropdownMenuItem(value: m.idUsuario, child: Text(m.username)))
                                            .toList(),
                                        onChanged: (v) => setState(() => _idMecanico = v),
                                      ),
                                    const SizedBox(height: 14),

                                    _label('Sucursal *'),
                                    DropdownButtonFormField<int>(
                                      initialValue: _idSucursal,
                                      decoration: _dec('— Selecciona sucursal —'),
                                      items: _sucursales
                                          .map((s) => DropdownMenuItem(
                                              value: s.idSucursal, child: Text(s.nombreSucursal)))
                                          .toList(),
                                      onChanged: (v) => setState(() => _idSucursal = v),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Cliente'),
                                    DropdownButtonFormField<int>(
                                      initialValue: _idCliente,
                                      decoration: _dec('— Sin cliente asignado (opcional) —'),
                                      items: _clientes
                                          .map((c) => DropdownMenuItem(
                                                value: c.idCliente,
                                                child: Text(
                                                  '${c.nombreCompleto} · ${c.tipoDocumento} ${c.numeroDocumento}',
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (v) => setState(() => _idCliente = v),
                                    ),
                                    if (clienteSel.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: _TareasColors.fondo,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(clienteSel.first.nombreCompleto,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            Text(
                                                '${clienteSel.first.tipoDocumento} · ${clienteSel.first.numeroDocumento}',
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 14),

                                    _label('Vehículo *'),
                                    TextField(
                                      controller: _vehiculoCtrl,
                                      decoration: _dec('Ej: VT-001 - Humvee Blindado'),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Tipo de trabajo'),
                                    DropdownButtonFormField<String>(
                                      initialValue: _tipoTrabajo,
                                      decoration: _dec(''),
                                      items: _tiposTrabajo
                                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                          .toList(),
                                      onChanged: (v) => setState(() => _tipoTrabajo = v!),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Descripción'),
                                    TextField(
                                      controller: _descripcionCtrl,
                                      maxLines: 3,
                                      decoration: _dec('Detalle del trabajo...'),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Prioridad'),
                                    DropdownButtonFormField<String>(
                                      initialValue: _prioridad,
                                      decoration: _dec(''),
                                      items: _prioridades
                                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                          .toList(),
                                      onChanged: (v) => setState(() => _prioridad = v!),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Fecha límite'),
                                    InkWell(
                                      onTap: _seleccionarFecha,
                                      child: InputDecorator(
                                        decoration: _dec(''),
                                        child: Text(_fechaLimite == null
                                            ? 'Seleccionar fecha'
                                            : fmtFecha(_fechaLimite)),
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Costo del trabajo * (COP)'),
                                    TextField(
                                      controller: _costoCtrl,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: _dec('0'),
                                    ),
                                    const SizedBox(height: 14),

                                    _label('Método de pago *'),
                                    DropdownButtonFormField<int>(
                                      initialValue: _idMetodoPago,
                                      decoration: _dec('Selecciona método'),
                                      items: _metodosPago
                                          .map((m) => DropdownMenuItem(
                                              value: m.idMetodoPago, child: Text(m.nombreMetodo)))
                                          .toList(),
                                      onChanged: (v) => setState(() => _idMetodoPago = v),
                                    ),
                                    if (metodoSel.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: metodoSel.first.permiteOnline
                                              ? _TareasColors.blueBg
                                              : _TareasColors.naranjaFondo,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          metodoSel.first.permiteOnline ? 'Pago Online' : 'Pago Presencial',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: metodoSel.first.permiteOnline
                                                ? _TareasColors.enlace
                                                : _TareasColors.naranja,
                                          ),
                                        ),
                                      ),
                                    ],

                                    if (_costoCtrl.text.isNotEmpty &&
                                        (double.tryParse(_costoCtrl.text) ?? 0) > 0) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          border: Border.all(color: const Color(0xFF86EFAC)),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '✓ Se registrará en movimientos contables: $_tipoTrabajo'
                                          '${_vehiculoCtrl.text.isNotEmpty ? ' — ${_vehiculoCtrl.text}' : ''}'
                                          '${clienteSel.isNotEmpty ? ' — Cliente: ${clienteSel.first.nombreCompleto}' : ''}'
                                          ' · ${fmtCOP(double.tryParse(_costoCtrl.text))}',
                                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF166534)),
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: _guardando ? null : () => Navigator.of(context).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: (_guardando || _mecanicos.isEmpty || _idMecanico == null)
                                                ? null
                                                : _crearAsignacion,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _TareasColors.dorado,
                                              foregroundColor: _TareasColors.navyOscuro,
                                            ),
                                            child: Text(
                                              _guardando
                                                  ? 'Guardando...'
                                                  : mecanicoSel.isNotEmpty
                                                      ? 'Asignar a ${mecanicoSel.first.username}'
                                                      : 'Asignar tarea',
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}