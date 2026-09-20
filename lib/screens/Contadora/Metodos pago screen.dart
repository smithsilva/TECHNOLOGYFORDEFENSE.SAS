import 'package:flutter/material.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const background = Color(0xFFF7EFDD);
  static const navy = Color(0xFF101B33);
  static const gold = Color(0xFFC9A24A);
  static const goldDark = Color(0xFF8A6D1F);
  static const goldText = Color(0xFFD2A03C);
  static const lightBlue = Color(0xFF9FB4DE);
  static const inputBg = Color(0xFFEFE4CB);
  static const iconBg = Color(0xFFF0E3BE);
  static const cardBorder = Color(0xFFECE0BD);

  static const green = Color(0xFF2E9E4E);
  static const greenBg = Color(0xFFDCF2E3);
  static const olive = Color(0xFF8B7920);
  static const oliveBg = Color(0xFFF3ECD2);
  static const red = Color(0xFFC24555);
  static const redBg = Color(0xFFF8DCE0);

  // Colores auxiliares que no vienen en la paleta pero se necesitan
  // para texto general (no son parte del branding, solo legibilidad).
  static const textDark = Color(0xFF111827);
  static const textGrey = Color(0xFF6B7280);
  static const white = Colors.white;
  static const cardShadow = Color(0x14000000);

  // Fondo de la tarjeta "Filtros y Búsqueda". Se usa blanco puro
  // (igual que las demás tarjetas) para que resalte contra el
  // fondo general en vez de mezclarse con él.
  static const filtroCardBg = white;
}

// ==================== FORMATO DE MONEDA ====================
String _formatoPesos(num monto) {
  final texto = monto.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < texto.length; i++) {
    final posDesdeFinal = texto.length - i;
    buffer.write(texto[i]);
    if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
  }
  return '\$${buffer.toString()}';
}

// ==================== MODELO: ASIGNACIÓN VINCULADA ====================
// Representa un mantenimiento/reparación/blindamiento de un vehículo que
// quedó pagado con este método de pago (mismo origen de datos que la
// pantalla de Movimientos Contables).
class AsignacionMetodo {
  final int numero;
  final String vehiculoId;
  final String vehiculoNombre;
  final String servicio;
  final String fechaVencimiento;
  final double monto;
  final String estado;

  const AsignacionMetodo({
    required this.numero,
    required this.vehiculoId,
    required this.vehiculoNombre,
    required this.servicio,
    required this.fechaVencimiento,
    required this.monto,
    required this.estado,
  });
}

// ==================== MODELO ====================
// Nota: dejó de ser 100% inmutable "const" porque ahora se crea
// dinámicamente desde el formulario (el usuario define el % real).
class MetodoPagoModel {
  final int id;
  final String nombre;
  final String tipo;
  final String descripcion;
  final double comisionValor; // porcentaje numérico real, ej: 2.5
  final String estado;
  final bool permiteOnline;
  // TODO: Reemplaza esto por tu fetch real a Supabase (tabla
  // asignaciones/mantenimiento filtrada por id_metodo_pago).
  final List<AsignacionMetodo> asignaciones;

  const MetodoPagoModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
    required this.comisionValor,
    required this.estado,
    required this.permiteOnline,
    this.asignaciones = const [],
  });

  String get comisionTexto {
    // Si es entero (0, 2, 5...) no muestra decimales; si no, muestra 1 decimal.
    final esEntero = comisionValor == comisionValor.roundToDouble();
    final texto = esEntero
        ? comisionValor.toStringAsFixed(0)
        : comisionValor.toStringAsFixed(1);
    return '$texto%';
  }
}

// Datos iniciales (ya no son "const" con 0% fijo a fuerza; son el punto
// de partida, y cada método nuevo que agregues define SU PROPIO %).
final List<MetodoPagoModel> metodosPagoDataInicial = [
  const MetodoPagoModel(
    id: 1,
    nombre: 'Efectivo',
    tipo: 'Efectivo',
    descripcion: 'Pago en efectivo en punto físico',
    comisionValor: 0,
    estado: 'Activo',
    permiteOnline: false,
    asignaciones: [
      AsignacionMetodo(
        numero: 1,
        vehiculoId: 'VT-001',
        vehiculoNombre: 'Humvee Blindado',
        servicio: 'Mantenimiento',
        fechaVencimiento: '01/07/2026',
        monto: 850000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 2,
        vehiculoId: 'VT-002',
        vehiculoNombre: 'Toyota Hilux',
        servicio: 'Mantenimiento',
        fechaVencimiento: '18/06/2026',
        monto: 420000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 7,
        vehiculoId: 'VT-007',
        vehiculoNombre: 'Chevrolet Colorado',
        servicio: 'Blindamiento',
        fechaVencimiento: '10/06/2026',
        monto: 2399997,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 8,
        vehiculoId: 'VT-008',
        vehiculoNombre: 'Mitsubishi L200',
        servicio: 'Mantenimiento',
        fechaVencimiento: '10/06/2026',
        monto: 220000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 9,
        vehiculoId: 'VT-009',
        vehiculoNombre: 'Mazda BT-50',
        servicio: 'Mantenimiento',
        fechaVencimiento: '13/06/2026',
        monto: 349998,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 10,
        vehiculoId: 'VT-010',
        vehiculoNombre: 'Isuzu D-Max',
        servicio: 'Reparación',
        fechaVencimiento: '18/06/2026',
        monto: 3200001,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 11,
        vehiculoId: 'VT-011',
        vehiculoNombre: 'Renault Duster',
        servicio: 'Mantenimiento',
        fechaVencimiento: '17/06/2026',
        monto: 180000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 12,
        vehiculoId: 'VT-012',
        vehiculoNombre: 'Kia Sportage',
        servicio: 'Reparación',
        fechaVencimiento: '02/04/2026',
        monto: 980000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 13,
        vehiculoId: 'VT-013',
        vehiculoNombre: 'Hyundai Tucson',
        servicio: 'Mantenimiento',
        fechaVencimiento: '25/03/2026',
        monto: 270000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 14,
        vehiculoId: 'VT-014',
        vehiculoNombre: 'Toyota Prado',
        servicio: 'Mantenimiento',
        fechaVencimiento: '19/08/2026',
        monto: 450003,
        estado: 'Pendiente',
      ),
    ],
  ),
  const MetodoPagoModel(
    id: 2,
    nombre: 'Transferencia Bancaria',
    tipo: 'Transferencia',
    descripcion: 'Transferencia entre cuentas bancarias',
    comisionValor: 0,
    estado: 'Activo',
    permiteOnline: true,
    asignaciones: [
      AsignacionMetodo(
        numero: 3,
        vehiculoId: 'VT-013',
        vehiculoNombre: 'Hyundai Tucson',
        servicio: 'Mantenimiento',
        fechaVencimiento: '30/06/2026',
        monto: 270000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 4,
        vehiculoId: 'VT-012',
        vehiculoNombre: 'Kia Sportage',
        servicio: 'Reparación',
        fechaVencimiento: '30/06/2026',
        monto: 980000,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 5,
        vehiculoId: 'VT-011',
        vehiculoNombre: 'Renault Duster',
        servicio: 'Mantenimiento',
        fechaVencimiento: '30/06/2026',
        monto: 180000,
        estado: 'Pendiente',
      ),
    ],
  ),
  const MetodoPagoModel(
    id: 3,
    nombre: 'Nequi',
    tipo: 'Transferencia',
    descripcion: 'Pago digital a través de la aplicación Nequi',
    comisionValor: 0,
    estado: 'Activo',
    permiteOnline: true,
    asignaciones: [
      AsignacionMetodo(
        numero: 6,
        vehiculoId: 'VT-010',
        vehiculoNombre: 'Isuzu D-Max',
        servicio: 'Reparación',
        fechaVencimiento: '30/06/2026',
        monto: 3200001,
        estado: 'Pendiente',
      ),
      AsignacionMetodo(
        numero: 9,
        vehiculoId: 'VT-009',
        vehiculoNombre: 'Mazda BT-50',
        servicio: 'Mantenimiento',
        fechaVencimiento: '30/06/2026',
        monto: 349998,
        estado: 'Pendiente',
      ),
    ],
  ),
  const MetodoPagoModel(
    id: 4,
    nombre: 'Tarjeta Crédito/Débito',
    tipo: 'Tarjeta',
    descripcion: 'Pago con tarjeta mediante datáfono o pasarela',
    comisionValor: 2.5,
    estado: 'Activo',
    permiteOnline: true,
    asignaciones: [
      AsignacionMetodo(
        numero: 8,
        vehiculoId: 'VT-008',
        vehiculoNombre: 'Mitsubishi L200',
        servicio: 'Mantenimiento',
        fechaVencimiento: '30/06/2026',
        monto: 220000,
        estado: 'Pendiente',
      ),
    ],
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class MetodosPagoScreen extends StatefulWidget {
  const MetodosPagoScreen({super.key});

  @override
  State<MetodosPagoScreen> createState() => _MetodosPagoScreenState();
}

class _MetodosPagoScreenState extends State<MetodosPagoScreen> {
  // Esta lista vive en memoria mientras la app está abierta.
  // Si necesitas que sobreviva a cerrar la app, aquí es donde
  // conectarías shared_preferences/sqflite, o una API si varios
  // dispositivos deben ver lo mismo.
  final List<MetodoPagoModel> _metodos = List.of(metodosPagoDataInicial);

  final TextEditingController _busquedaCtrl = TextEditingController();
  String _filtroEstado = 'Todos';
  bool _filtrosExpandido = true;

  int get _totalMetodos => _metodos.length;
  int get _activos => _metodos.where((m) => m.estado == 'Activo').length;

  bool get _hayFiltrosActivos =>
      _busquedaCtrl.text.trim().isNotEmpty || _filtroEstado != 'Todos';

  List<MetodoPagoModel> get _metodosFiltrados {
    final query = _busquedaCtrl.text.trim().toLowerCase();
    return _metodos.where((m) {
      final coincideEstado =
          _filtroEstado == 'Todos' || m.estado == _filtroEstado;
      final coincideBusqueda = query.isEmpty ||
          m.nombre.toLowerCase().contains(query) ||
          m.descripcion.toLowerCase().contains(query);
      return coincideEstado && coincideBusqueda;
    }).toList();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _filtroEstado = 'Todos';
    });
  }

  // NOTA: se dejó este método intacto (sin quitarlo) aunque ya no se
  // dispara desde ningún botón en pantalla, por si luego quieres
  // volver a engancharlo (por ejemplo desde una tarjeta o un menú).
  Future<void> _abrirFormulario({MetodoPagoModel? existente, int? index}) async {
    final nombreCtrl = TextEditingController(text: existente?.nombre ?? '');
    final descCtrl = TextEditingController(text: existente?.descripcion ?? '');
    final comisionCtrl = TextEditingController(
      text: existente != null ? existente.comisionValor.toString() : '',
    );
    String estadoSeleccionado = existente?.estado ?? 'Activo';

    final resultado = await showDialog<MetodoPagoModel>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existente == null
                  ? 'Agregar método de pago'
                  : 'Editar método de pago'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: comisionCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Comisión (%)',
                        hintText: 'Ej: 2.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: estadoSeleccionado,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const [
                        DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                        DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => estadoSeleccionado = v);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nombre = nombreCtrl.text.trim();
                    final comision =
                        double.tryParse(comisionCtrl.text.trim().replaceAll(',', '.'));
                    if (nombre.isEmpty || comision == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Ingresa un nombre válido y una comisión numérica.'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      MetodoPagoModel(
                        id: existente?.id ?? (_metodos.length + 1),
                        nombre: nombre,
                        tipo: existente?.tipo ?? 'Efectivo',
                        descripcion: descCtrl.text.trim(),
                        comisionValor: comision,
                        estado: estadoSeleccionado,
                        permiteOnline: existente?.permiteOnline ?? false,
                        asignaciones: existente?.asignaciones ?? const [],
                      ),
                    );
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          _metodos[index] = resultado;
        } else {
          _metodos.add(resultado);
        }
      });
    }
  }

  // ------------------------------------------------------------
  // Modal "Detalle del Método" — mismo diseño de la imagen de
  // referencia: datos generales arriba y lista de asignaciones
  // vinculadas abajo, con botón "Cerrar" fijo.
  // ------------------------------------------------------------
  void _verDetalle(MetodoPagoModel metodo) {
    showDialog(
      context: context,
      builder: (context) => _DetalleMetodoDialog(metodo: metodo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metodosVisibles = _metodosFiltrados;

    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          const _PageHeaderCard(
            eyebrow: 'CONTADORA - PAGOS',
            title: 'Métodos de Pago',
            subtitle: 'Canales de pago aceptados',
          ),
          const SizedBox(height: 14),
          _buildStatsRow(),
          const SizedBox(height: 14),
          _FiltrosYBusquedaCard(
            expandido: _filtrosExpandido,
            onToggleExpandido: () =>
                setState(() => _filtrosExpandido = !_filtrosExpandido),
            controladorBusqueda: _busquedaCtrl,
            onBusquedaChanged: (_) => setState(() {}),
            filtroEstado: _filtroEstado,
            onFiltroEstadoChanged: (valor) =>
                setState(() => _filtroEstado = valor),
            hayFiltrosActivos: _hayFiltrosActivos,
            onLimpiarFiltros: _limpiarFiltros,
          ),
          const SizedBox(height: 14),
          if (metodosVisibles.isEmpty)
            const _SinResultados()
          else
            ...metodosVisibles.map(
              (metodo) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MetodoCard(
                  metodo: metodo,
                  onVerDetalle: () => _verDetalle(metodo),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total',
            value: '$_totalMetodos',
            accentColor: AppColors.gold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Activos',
            value: '$_activos',
            accentColor: AppColors.green,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// ============================================================
class _PageHeaderCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _PageHeaderCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.lightBlue,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ESTADÍSTICA ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(height: 4, color: accentColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA "FILTROS Y BÚSQUEDA"
// Colapsable: header con icono de filtro + chevron. Contiene un
// buscador (filtra por nombre/descripción) y chips de estado
// (Todos / Activo / Inactivo), más un enlace "Limpiar filtros".
// ============================================================
class _FiltrosYBusquedaCard extends StatelessWidget {
  final bool expandido;
  final VoidCallback onToggleExpandido;
  final TextEditingController controladorBusqueda;
  final ValueChanged<String> onBusquedaChanged;
  final String filtroEstado;
  final ValueChanged<String> onFiltroEstadoChanged;
  final bool hayFiltrosActivos;
  final VoidCallback onLimpiarFiltros;

  const _FiltrosYBusquedaCard({
    required this.expandido,
    required this.onToggleExpandido,
    required this.controladorBusqueda,
    required this.onBusquedaChanged,
    required this.filtroEstado,
    required this.onFiltroEstadoChanged,
    required this.hayFiltrosActivos,
    required this.onLimpiarFiltros,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.filtroCardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggleExpandido,
            child: Row(
              children: [
                const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.navy),
                const SizedBox(width: 8),
                const Text(
                  'Filtros y Búsqueda',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const Spacer(),
                Icon(
                  expandido ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.navy,
                ),
              ],
            ),
          ),
          if (expandido) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controladorBusqueda,
                onChanged: onBusquedaChanged,
                style: const TextStyle(fontSize: 12.5, color: AppColors.goldDark),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'Buscar método de pago...',
                  hintStyle: TextStyle(fontSize: 12.5, color: AppColors.goldDark),
                  prefixIcon: Icon(Icons.search, size: 18, color: AppColors.goldDark),
                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipFiltro(
                  texto: 'Todos',
                  seleccionado: filtroEstado == 'Todos',
                  onTap: () => onFiltroEstadoChanged('Todos'),
                ),
                _ChipFiltro(
                  texto: 'Activo',
                  seleccionado: filtroEstado == 'Activo',
                  onTap: () => onFiltroEstadoChanged('Activo'),
                ),
                _ChipFiltro(
                  texto: 'Inactivo',
                  seleccionado: filtroEstado == 'Inactivo',
                  onTap: () => onFiltroEstadoChanged('Inactivo'),
                ),
              ],
            ),
            if (hayFiltrosActivos) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onLimpiarFiltros,
                  child: const Text(
                    '\u00D7 Limpiar filtros',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ChipFiltro extends StatelessWidget {
  final String texto;
  final bool seleccionado;
  final VoidCallback onTap;

  const _ChipFiltro({
    required this.texto,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: seleccionado ? AppColors.iconBg : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: seleccionado ? FontWeight.w700 : FontWeight.w500,
            color: seleccionado ? AppColors.goldDark : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: const Center(
        child: Text(
          'No se encontraron métodos de pago con esos filtros.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
        ),
      ),
    );
  }
}

// ==================== TARJETA DE MÉTODO DE PAGO ====================
class _MetodoCard extends StatelessWidget {
  final MetodoPagoModel metodo;
  final VoidCallback onVerDetalle;

  const _MetodoCard({
    required this.metodo,
    required this.onVerDetalle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: AppColors.lightBlue),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            metodo.nombre,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        _EstadoBadge(estado: metodo.estado),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      metodo.descripcion,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comisión',
                          style: TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                        ),
                        Text(
                          metodo.comisionTexto,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.lightBlue),
                  onPressed: onVerDetalle,
                  tooltip: 'Ver detalle',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final String estado;

  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final bool activo = estado.toLowerCase() == 'activo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? AppColors.greenBg : const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: activo ? AppColors.green : AppColors.textGrey,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================
// MODAL "Detalle del Método" — igual al diseño de referencia:
// datos generales (ID, Nombre, Tipo, Descripción, Permite online)
// y debajo la lista de "Asignaciones vinculadas", con un botón
// "Cerrar" fijo en la parte inferior.
// ============================================================
class _DetalleMetodoDialog extends StatelessWidget {
  final MetodoPagoModel metodo;

  const _DetalleMetodoDialog({required this.metodo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 420,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Encabezado ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 8, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalle del Método',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(width: 42, height: 3, color: AppColors.gold),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textGrey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // ---- Contenido con scroll ----
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.iconBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.payments_outlined,
                            size: 28, color: AppColors.goldDark),
                      ),
                    ),
                    _filaDetalle('ID', '#${metodo.id}'),
                    _filaDetalle('Nombre', metodo.nombre),
                    _filaDetalle('Tipo', metodo.tipo),
                    _filaDetalle('Descripción', metodo.descripcion),
                    _filaDetalle('Permite online', metodo.permiteOnline ? 'Sí' : 'No',
                        conDivisor: false),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.link, size: 16, color: AppColors.lightBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Asignaciones vinculadas (${metodo.asignaciones.length})',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (metodo.asignaciones.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Sin asignaciones vinculadas.',
                          style: TextStyle(
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textGrey),
                        ),
                      )
                    else
                      ...metodo.asignaciones.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _AsignacionTile(asignacion: a),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // ---- Botón Cerrar fijo ----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Center(
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaDetalle(String label, String valor, {bool conDivisor = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  valor,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
                ),
              ),
            ],
          ),
        ),
        if (conDivisor) const Divider(height: 1, color: AppColors.cardBorder),
      ],
    );
  }
}

// ==================== TARJETA DE ASIGNACIÓN VINCULADA ====================
class _AsignacionTile extends StatelessWidget {
  final AsignacionMetodo asignacion;

  const _AsignacionTile({required this.asignacion});

  @override
  Widget build(BuildContext context) {
    final esPendiente = asignacion.estado.toLowerCase() == 'pendiente';
    final colorEstado = esPendiente ? AppColors.olive : AppColors.green;
    final fondoEstado = esPendiente ? AppColors.oliveBg : AppColors.greenBg;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '#${asignacion.numero} — ${asignacion.vehiculoId} - ${asignacion.vehiculoNombre}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: fondoEstado,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  asignacion.estado,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colorEstado,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                asignacion.servicio,
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
              const SizedBox(width: 10),
              Text(
                'Vence ${asignacion.fechaVencimiento}',
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
              const Spacer(),
              Text(
                _formatoPesos(asignacion.monto),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}