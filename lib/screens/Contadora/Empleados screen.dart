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

  // NOTA: este morado NO viene en tu paleta original. Lo agregué
  // únicamente para el avatar de "Camilo García" porque en tu imagen
  // de referencia se ve morado y tu paleta no trae ningún tono de
  // morado. Si prefieres usar solo tus colores originales, cámbialo
  // por AppColors.navy o AppColors.lightBlue.
  static const violeta = Color(0xFF7C5CD9);

  // Colores auxiliares que no vienen en la paleta pero se necesitan
  // para texto general (no son parte del branding, solo legibilidad).
  static const textDark = Color(0xFF111827);
  static const textGrey = Color(0xFF6B7280);
  static const white = Colors.white;
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
class EmpleadoModel {
  final String initials;
  final Color avatarColor;
  final String nombre;
  final String cargo;
  final String correo;
  final String telefono;
  final String salario;
  final String estado;

  const EmpleadoModel({
    required this.initials,
    required this.avatarColor,
    required this.nombre,
    required this.cargo,
    required this.correo,
    required this.telefono,
    required this.salario,
    required this.estado,
  });
}

// Colores de avatar tomados de tu paleta: dorado oscuro y rojo.
// "Camilo García" usa AppColors.violeta (ver nota arriba).
final List<EmpleadoModel> empleadosData = [
  const EmpleadoModel(
    initials: 'CG',
    avatarColor: AppColors.violeta,
    nombre: 'Camilo García',
    cargo: 'Mecánico',
    correo: 'camilo@t4d.com',
    telefono: '310 111 2222',
    salario: '\$2.800.000',
    estado: 'Activo',
  ),
  const EmpleadoModel(
    initials: 'JP',
    avatarColor: AppColors.goldDark,
    nombre: 'Juan Pérez',
    cargo: 'Admin',
    correo: 'juan@t4d.com',
    telefono: '310 333 4444',
    salario: '\$3.500.000',
    estado: 'Activo',
  ),
  const EmpleadoModel(
    initials: 'CT',
    avatarColor: AppColors.red,
    nombre: 'Contadora T4D',
    cargo: 'Contadora',
    correo: 'contadora@gmail.com',
    telefono: '310 555 6666',
    salario: '\$4.200.000',
    estado: 'Activo',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key});

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  String _filtroEstado = 'Todos';
  bool _filtrosExpandido = true;

  List<EmpleadoModel> get _empleadosFiltrados {
    final query = _busquedaCtrl.text.trim().toLowerCase();
    return empleadosData.where((e) {
      final coincideEstado =
          _filtroEstado == 'Todos' || e.estado == _filtroEstado;
      final coincideBusqueda = query.isEmpty ||
          e.nombre.toLowerCase().contains(query) ||
          e.cargo.toLowerCase().contains(query);
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

  @override
  Widget build(BuildContext context) {
    final visibles = _empleadosFiltrados;

    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - EMPLEADOS',
            title: 'Empleados',
            subtitle: '${empleadosData.length} empleados registrados',
          ),
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
            onLimpiarFiltros: _limpiarFiltros,
          ),
          const SizedBox(height: 14),
          if (visibles.isEmpty)
            const _SinResultados()
          else
            ...visibles.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _EmpleadoCard(empleado: e),
                )),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// Fondo azul marino oscuro, borde dorado, etiqueta dorada,
// título blanco y subtítulo azul claro.
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
        border: Border.all(color: AppColors.gold, width: 1.2),
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

// ============================================================
// TARJETA "FILTROS Y BÚSQUEDA"
// Colapsable: header con icono de filtro + chevron. Contiene un
// buscador (filtra por nombre/cargo) y chips de estado
// (Todos / Activo / Inactivo), más un enlace "Limpiar filtros".
// ============================================================
class _FiltrosYBusquedaCard extends StatelessWidget {
  final bool expandido;
  final VoidCallback onToggleExpandido;
  final TextEditingController controladorBusqueda;
  final ValueChanged<String> onBusquedaChanged;
  final String filtroEstado;
  final ValueChanged<String> onFiltroEstadoChanged;
  final VoidCallback onLimpiarFiltros;

  const _FiltrosYBusquedaCard({
    required this.expandido,
    required this.onToggleExpandido,
    required this.controladorBusqueda,
    required this.onBusquedaChanged,
    required this.filtroEstado,
    required this.onFiltroEstadoChanged,
    required this.onLimpiarFiltros,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
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
                const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.gold),
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
                  color: AppColors.textGrey,
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
                  hintText: 'Buscar por nombre o cargo...',
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
          border: Border.all(
            color: seleccionado ? AppColors.gold : AppColors.cardBorder,
            width: seleccionado ? 1.2 : 1,
          ),
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
          'No se encontraron empleados con esos filtros.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
        ),
      ),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================
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

// Tarjeta de empleado con franja de acento a la izquierda (color del
// avatar) y borde dorado en todo el cuadro.
class _EmpleadoCard extends StatelessWidget {
  final EmpleadoModel empleado;

  const _EmpleadoCard({required this.empleado});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: empleado.avatarColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: empleado.avatarColor,
                      child: Text(
                        empleado.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  empleado.nombre,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              _EstadoBadge(estado: empleado.estado),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            empleado.cargo,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.goldText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            empleado.correo,
                            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                empleado.telefono,
                                style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                              ),
                              Text(
                                empleado.salario,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
