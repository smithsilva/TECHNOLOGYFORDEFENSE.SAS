import 'package:flutter/material.dart';

class _TareasColors {
  // ---- Paleta nueva (la que enviaste) ----
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const doradoMezcla = Color(0xFFAB812E); // punto medio dorado/doradoOscuro
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

  // Alias usados en el resto del archivo (no cambian nombres para
  // no tener que tocar cada referencia). Ahora apuntan a la paleta nueva.
  static const white = Color(0xFFFFFFFF); // tarjetas en blanco puro
  static const gold = dorado;
  static const grayText = textoMuted;
  static const encabezado = navyOscuro; // se usa como color de TEXTO/ícono oscuro, no como fondo
  static const headerBg = white; // fondo del header: blanco, ya no azul marino

  static const blue = enlace;
  static const blueBg = Color(0xFFE1EEFE); // tinte claro de "enlace", no venía en la paleta
  static const green = verde;
  static const greenBg = verdeFondo;
  static const orange = doradoOscuro; // actualizado según nueva paleta
  static const orangeBg = doradoClaro; // actualizado según nueva paleta

  // ---- Nueva paleta unificada (aliases adicionales) ----
  static const navy = encabezado;
  static const background = fondo;
  static const panelDark = encabezado;
  static const goldLight = doradoClaro;
  static const goldDark = doradoOscuro;
  static const goldBg = doradoClaro;
  static const borderLight = dorado;
  static const cardWhiteSubtitle = grayText;
  static const neutral = grayText;
}

// ============================================================
// ENUMS
// ============================================================
enum TaskStatus { pendiente, enProceso, finalizada }

enum TaskPriority { alta, media, baja }

enum PaymentModality { online, presencial }

extension TaskStatusData on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pendiente:
        return 'Pendiente';
      case TaskStatus.enProceso:
        return 'En proceso';
      case TaskStatus.finalizada:
        return 'Finalizada';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pendiente:
        return _TareasColors.textoMuted;
      case TaskStatus.enProceso:
        return _TareasColors.blue;
      case TaskStatus.finalizada:
        return _TareasColors.green;
    }
  }
}

extension TaskPriorityData on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.alta:
        return 'Alta';
      case TaskPriority.media:
        return 'Media';
      case TaskPriority.baja:
        return 'Baja';
    }
  }

  Color get bg {
    switch (this) {
      case TaskPriority.alta:
        return _TareasColors.naranjaFondo;
      case TaskPriority.media:
        return _TareasColors.doradoClaro;
      case TaskPriority.baja:
        return const Color(0xFFE5E7EB);
    }
  }

  Color get fg {
    switch (this) {
      case TaskPriority.alta:
        return _TareasColors.naranja;
      case TaskPriority.media:
        return _TareasColors.doradoMezcla;
      case TaskPriority.baja:
        return _TareasColors.textoMuted;
    }
  }
}

extension PaymentModalityData on PaymentModality {
  String get label => this == PaymentModality.online ? 'Online' : 'Presencial';
  Color get bg => this == PaymentModality.online
      ? _TareasColors.blueBg
      : _TareasColors.naranjaFondo;
  Color get fg => this == PaymentModality.online
      ? _TareasColors.blue
      : _TareasColors.naranja;
  // Íconos más específicos: nube para online, mostrador para presencial
  // (antes eran genéricos wifi / storefront sin más criterio).
  IconData get icon =>
      this == PaymentModality.online ? Icons.cloud_done_rounded : Icons.storefront_rounded;
}

// ============================================================
// MODELO DE DATOS
// ============================================================
class TaskAssignment {
  final String clientName;
  final String docLabel; // ej: "CE", "CC", "Pasaporte"
  final String docNumber;
  final String vehicleCode; // ej: VT-013
  final String vehicleModel; // ej: Hyundai Tucson
  final String serviceType; // Mantenimiento / Reparación / Blindamiento
  final String taskDescription;
  final String mechanic;
  final String sucursal;
  final int price;
  final String paymentMethod; // Efectivo / Transferencia Bancaria / Nequi / etc
  final PaymentModality modality;
  final TaskPriority priority;
  final String date;
  final TaskStatus status;

  const TaskAssignment({
    required this.clientName,
    required this.docLabel,
    required this.docNumber,
    required this.vehicleCode,
    required this.vehicleModel,
    required this.serviceType,
    required this.taskDescription,
    required this.mechanic,
    required this.sucursal,
    required this.price,
    required this.paymentMethod,
    required this.modality,
    required this.priority,
    required this.date,
    required this.status,
  });
}

String formatCOP(int value) {
  final str = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    final posFromEnd = str.length - i;
    buffer.write(str[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
  }
  return '\$$buffer';
}

// Datos tomados de las capturas enviadas.
// Reemplaza esta lista por la respuesta real de tu API/backend.
final List<TaskAssignment> mockAssignments = [
  const TaskAssignment(
    clientName: 'Sara Jiménez',
    docLabel: 'CE',
    docNumber: '105566778',
    vehicleCode: 'VT-00123',
    vehicleModel: '',
    serviceType: 'Mantenimiento',
    taskDescription: 'arreglo',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Norte',
    price: 34000,
    paymentMethod: 'Transferencia Bancaria',
    modality: PaymentModality.online,
    priority: TaskPriority.alta,
    date: '03/08/2025',
    status: TaskStatus.finalizada,
  ),
  const TaskAssignment(
    clientName: 'Felipe Torres',
    docLabel: 'CC',
    docNumber: '1123334455',
    vehicleCode: 'VT-014',
    vehicleModel: 'Toyota Prado',
    serviceType: 'Mantenimiento',
    taskDescription: 'Revisión de transmisión',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Santa Marta',
    price: 450003,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.media,
    date: '',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Cristian Muñoz',
    docLabel: 'CC',
    docNumber: '105887756',
    vehicleCode: 'VT-013',
    vehicleModel: 'Hyundai Tucson',
    serviceType: 'Mantenimiento',
    taskDescription: 'Cambio de filtros',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 270000,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.media,
    date: '25/03/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Camila Torres',
    docLabel: 'CC',
    docNumber: '110276588',
    vehicleCode: 'VT-012',
    vehicleModel: 'Kia Sportage',
    serviceType: 'Reparación',
    taskDescription: 'Cambio de amortiguadores',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 980000,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.media,
    date: '02/04/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Andrés Martínez',
    docLabel: 'CC',
    docNumber: '112233445',
    vehicleCode: 'VT-011',
    vehicleModel: 'Renault Duster',
    serviceType: 'Mantenimiento',
    taskDescription: 'Alineación y balanceo',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Cúcuta',
    price: 180000,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.media,
    date: '17/06/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Carlos Fernández',
    docLabel: 'Pasaporte',
    docNumber: '445566778',
    vehicleCode: 'VT-010',
    vehicleModel: 'Isuzu D-Max',
    serviceType: 'Reparación',
    taskDescription: 'Reparación de caja de cambios',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 3200001,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.alta,
    date: '18/06/2025',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Andrés Martínez',
    docLabel: 'CC',
    docNumber: '112233445',
    vehicleCode: 'VT-009',
    vehicleModel: 'Mazda BT-50',
    serviceType: 'Mantenimiento',
    taskDescription: 'Cambio de aceite',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Norte',
    price: 349998,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.media,
    date: '13/06/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Carlos Fernández',
    docLabel: 'Pasaporte',
    docNumber: '445566778',
    vehicleCode: 'VT-008',
    vehicleModel: 'Mitsubishi L200',
    serviceType: 'Mantenimiento',
    taskDescription: 'Revisión de frenos',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Principal',
    price: 220000,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.baja,
    date: '18/06/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Juan Esteban Gómez',
    docLabel: 'CE',
    docNumber: '1023456789',
    vehicleCode: 'VT-007',
    vehicleModel: 'Chevrolet Colorado',
    serviceType: 'Blindamiento',
    taskDescription: 'Cambio de llantas',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Medellín',
    price: 2399997,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.alta,
    date: '10/06/2025',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Cristian Muñoz',
    docLabel: 'CC',
    docNumber: '1059887766',
    vehicleCode: 'VT-006',
    vehicleModel: 'Jeep Wrangler',
    serviceType: 'Mantenimiento',
    taskDescription: 'Reparación de suspensión',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 1750000,
    paymentMethod: 'Nequi',
    modality: PaymentModality.online,
    priority: TaskPriority.baja,
    date: '25/06/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Andrés Cárdenas',
    docLabel: 'Pasaporte',
    docNumber: 'P99887766',
    vehicleCode: 'VT-005',
    vehicleModel: 'Ford Ranger',
    serviceType: 'Mantenimiento',
    taskDescription: 'Cambio de batería',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 650000,
    paymentMethod: 'Transferencia Bancaria',
    modality: PaymentModality.online,
    priority: TaskPriority.media,
    date: '25/06/2026',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Natalia Ramírez',
    docLabel: 'Pasaporte',
    docNumber: 'P44556677',
    vehicleCode: 'VT-004',
    vehicleModel: 'Nissan Frontier',
    serviceType: 'Reparación',
    taskDescription: 'Diagnóstico del sistema',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 179999,
    paymentMethod: 'Transferencia Bancaria',
    modality: PaymentModality.online,
    priority: TaskPriority.alta,
    date: '25/06/2025',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Andrés Martínez',
    docLabel: 'CC',
    docNumber: '112233445',
    vehicleCode: 'VT-003',
    vehicleModel: 'Chevrolet D-Max',
    serviceType: 'Reparación',
    taskDescription: 'Revisión general del motor',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Norte',
    price: 750000,
    paymentMethod: 'Tarjeta Crédito/Débito',
    modality: PaymentModality.online,
    priority: TaskPriority.alta,
    date: '04/08/2025',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Cristian Muñoz',
    docLabel: 'CC',
    docNumber: '1059887766',
    vehicleCode: 'VT-002',
    vehicleModel: 'Toyota Hilux',
    serviceType: 'Mantenimiento',
    taskDescription: 'Cambio de pastillas de frenos',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Pasto',
    price: 420000,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.media,
    date: '',
    status: TaskStatus.pendiente,
  ),
  const TaskAssignment(
    clientName: 'Andrés Cárdenas',
    docLabel: 'Pasaporte',
    docNumber: 'P99887766',
    vehicleCode: 'VT-001',
    vehicleModel: 'Humvee Blindado',
    serviceType: 'Mantenimiento',
    taskDescription: 'Cambio de aceite del motor',
    mechanic: 'Camilo',
    sucursal: 'Sucursal Centro',
    price: 850000,
    paymentMethod: 'Efectivo',
    modality: PaymentModality.presencial,
    priority: TaskPriority.alta,
    date: '03/07/2026',
    status: TaskStatus.pendiente,
  ),
];

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================
class AsignacionTareasScreen extends StatefulWidget {
  // Si embedded = true, no dibuja su propio Scaffold/Drawer/header
  // (se usa así dentro de main_shell.dart, que ya los provee).
  final bool embedded;

  const AsignacionTareasScreen({super.key, this.embedded = false});

  @override
  State<AsignacionTareasScreen> createState() => _AsignacionTareasScreenState();
}

class _AsignacionTareasScreenState extends State<AsignacionTareasScreen> {
  final TextEditingController _searchController = TextEditingController();

  int get pendientes =>
      mockAssignments.where((a) => a.status == TaskStatus.pendiente).length;
  int get enProceso =>
      mockAssignments.where((a) => a.status == TaskStatus.enProceso).length;
  int get finalizadas =>
      mockAssignments.where((a) => a.status == TaskStatus.finalizada).length;
  int get altaPrioridad =>
      mockAssignments.where((a) => a.priority == TaskPriority.alta).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // NOTA: aquí ya NO se llama el panel con el título "Asignación de Tareas"
  // como texto suelto: ahora ese título vive en la tarjeta oscura
  // _PageHeaderCard, igual que "Historial de Precios".
  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        const _PageHeaderCard(
          eyebrow: 'ADMINISTRADOR - TAREAS',
          title: 'Asignación de Tareas',
          subtitle: 'Gestiona y asigna tareas a los mecánicos',
        ),
        const SizedBox(height: 14),
        _StatsAndActionCard(
          pendientes: pendientes,
          enProceso: enProceso,
          finalizadas: finalizadas,
          altaPrioridad: altaPrioridad,
        ),
        const SizedBox(height: 14),
        _FiltersCard(controller: _searchController),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            '${mockAssignments.length} asignaciones',
            style: const TextStyle(color: _TareasColors.grayText, fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        ...mockAssignments.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AssignmentCard(assignment: a),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }

    return Scaffold(
      backgroundColor: _TareasColors.fondo,
      body: SafeArea(
        child: Builder(
          builder: (context) => Column(
            children: [
              _TopHeader(onMenuTap: () {
                // Si usas esta pantalla suelta (sin main_shell), conecta
                // aquí tu propio Drawer/Scaffold.key para abrirlo.
              }),
              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// Fondo azul marino oscuro, etiqueta dorada, título blanco,
// subtítulo azul claro y dos estrellitas doradas.
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
        color: _TareasColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(
              color: _TareasColors.gold,
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
              color: _TareasColors.subtitulo,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.star_rounded, size: 14, color: _TareasColors.gold),
              SizedBox(width: 3),
              Icon(Icons.star_rounded, size: 14, color: _TareasColors.gold),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HEADER SUPERIOR (único lugar con el título "Asignación de Tareas"
// que aparece dentro del top bar, para navegación con Scaffold suelto)
// ============================================================
class _TopHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _TopHeader({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _TareasColors.headerBg,
        border: Border(
          bottom: BorderSide(color: _TareasColors.dorado.withOpacity(0.5), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: onMenuTap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.menu_rounded, color: _TareasColors.encabezado, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _TareasColors.dorado,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('T4D',
                style: TextStyle(
                    color: _TareasColors.encabezado,
                    fontWeight: FontWeight.w900,
                    fontSize: 11)),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('BIENVENIDO',
                    style: TextStyle(
                        color: _TareasColors.doradoOscuro,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
                Text('Asignación de Tareas',
                    style: TextStyle(
                        color: _TareasColors.encabezado,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.notifications_none_rounded, color: _TareasColors.encabezado, size: 20),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: _TareasColors.fondo,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _TareasColors.doradoClaro),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: _TareasColors.dorado,
                  child: Icon(Icons.person_rounded, size: 11, color: _TareasColors.encabezado),
                ),
                SizedBox(width: 5),
                Text('Gerente', style: TextStyle(color: _TareasColors.encabezado, fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA DE ESTADÍSTICAS + BOTÓN "NUEVA ASIGNACIÓN"
// (sin título, para no repetir "Asignación de Tareas")
// ============================================================
class _StatsAndActionCard extends StatelessWidget {
  final int pendientes;
  final int enProceso;
  final int finalizadas;
  final int altaPrioridad;

  const _StatsAndActionCard({
    required this.pendientes,
    required this.enProceso,
    required this.finalizadas,
    required this.altaPrioridad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _TareasColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _TareasColors.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _TareasColors.doradoOscuro.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: navegar a formulario de nueva asignación
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _TareasColors.gold,
                foregroundColor: _TareasColors.encabezado,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text(
                'Nueva Asignación',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'Pendientes',
                  value: '$pendientes',
                  icon: Icons.schedule_rounded,
                  iconColor: _TareasColors.orange,
                  iconBg: _TareasColors.orangeBg,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'En proceso',
                  value: '$enProceso',
                  icon: Icons.sync_rounded,
                  iconColor: _TareasColors.blue,
                  iconBg: _TareasColors.blueBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'Finalizadas',
                  value: '$finalizadas',
                  icon: Icons.task_alt_rounded,
                  iconColor: _TareasColors.green,
                  iconBg: _TareasColors.greenBg,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'Alta prioridad',
                  value: '$altaPrioridad',
                  icon: Icons.priority_high_rounded,
                  iconColor: _TareasColors.doradoMezcla,
                  iconBg: const Color(0xFFF3F4F6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _TareasColors.fondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _TareasColors.dorado, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 17, color: iconColor),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA DE FILTROS Y BÚSQUEDA
// ============================================================
class _FiltersCard extends StatelessWidget {
  final TextEditingController controller;
  const _FiltersCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _TareasColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _TareasColors.dorado, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tune_rounded, size: 16, color: _TareasColors.gold),
              SizedBox(width: 6),
              Text(
                'Filtros y Búsqueda',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar vehículo, mecánico, cliente o sucursal...',
              hintStyle: const TextStyle(fontSize: 12, color: _TareasColors.grayText),
              prefixIcon: const Icon(Icons.search_rounded, size: 18, color: _TareasColors.grayText),
              filled: true,
              fillColor: _TareasColors.fondo,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _TareasColors.doradoClaro),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _TareasColors.doradoClaro),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _TareasColors.dorado),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA INDIVIDUAL DE ASIGNACIÓN
// ============================================================
class _AssignmentCard extends StatelessWidget {
  final TaskAssignment assignment;
  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final vehicleLabel = assignment.vehicleModel.isEmpty
        ? assignment.vehicleCode
        : '${assignment.vehicleCode} - ${assignment.vehicleModel}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _TareasColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _TareasColors.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _TareasColors.doradoOscuro.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
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
                  assignment.clientName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              _StatusBadge(status: assignment.status),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${assignment.docLabel} ${assignment.docNumber}',
            style: const TextStyle(fontSize: 10.5, color: _TareasColors.grayText),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.directions_car_filled_rounded, size: 14, color: _TareasColors.orange),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  vehicleLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _TareasColors.orange,
                  ),
                ),
              ),
              Text(
                assignment.serviceType,
                style: const TextStyle(fontSize: 11, color: _TareasColors.blue, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            assignment.taskDescription,
            style: const TextStyle(fontSize: 11.5, color: _TareasColors.grayText),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.badge_outlined, size: 13, color: _TareasColors.grayText),
              const SizedBox(width: 3),
              Text(
                assignment.mechanic,
                style: const TextStyle(fontSize: 11, color: _TareasColors.grayText),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.location_on_rounded, size: 13, color: _TareasColors.grayText),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  assignment.sucursal,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: _TareasColors.grayText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formatCOP(assignment.price),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            assignment.paymentMethod,
            style: const TextStyle(fontSize: 11, color: _TareasColors.grayText),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ModalityBadge(modality: assignment.modality),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PriorityBadge(priority: assignment.priority),
                  const SizedBox(height: 4),
                  if (assignment.date.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.event_rounded, size: 11, color: _TareasColors.grayText),
                        const SizedBox(width: 3),
                        Text(
                          assignment.date,
                          style: const TextStyle(fontSize: 10.5, color: _TareasColors.grayText),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TaskStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: status.color),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: priority.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.label,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: priority.fg),
      ),
    );
  }
}

class _ModalityBadge extends StatelessWidget {
  final PaymentModality modality;
  const _ModalityBadge({required this.modality});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: modality.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(modality.icon, size: 11, color: modality.fg),
          const SizedBox(width: 4),
          Text(
            modality.label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: modality.fg),
          ),
        ],
      ),
    );
  }
}