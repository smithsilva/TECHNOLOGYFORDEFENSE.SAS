import 'package:flutter/material.dart';
import 'Historial precios screen.dart' show AppColors;

// ============================================================
// TIPOS DE DOCUMENTO
// ============================================================
enum DocType { cc, ce, pasaporte, nit }

extension DocTypeData on DocType {
  String get label {
    switch (this) {
      case DocType.cc:
        return 'CC';
      case DocType.ce:
        return 'CE';
      case DocType.pasaporte:
        return 'Pasaporte';
      case DocType.nit:
        return 'NIT';
    }
  }

  Color get color {
    switch (this) {
      case DocType.cc:
        return AppColors.neutral;
      case DocType.ce:
        return AppColors.orange;
      case DocType.pasaporte:
        return const Color(0xFF7C3AED);
      case DocType.nit:
        return const Color(0xFF0D9488);
    }
  }
}

// ============================================================
// MODELO DE DATOS
// ============================================================
class ClientRecord {
  final DocType docType;
  final String docNumber;
  final String name;
  final String email;
  final String date;
  final bool active;
  final Color avatarColor;

  const ClientRecord({
    required this.docType,
    required this.docNumber,
    required this.name,
    required this.email,
    required this.date,
    required this.avatarColor,
    this.active = true,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

// Paleta usada para los avatares (colorida, decorativa; se deja
// igual porque identifica visualmente a cada cliente).
const List<Color> _avatarPalette = [
  Color(0xFF8B5CF6), // morado
  Color(0xFFF59E0B), // naranja
  Color(0xFF2563EB), // azul (solo decorativo de avatar)
  Color(0xFFEF4444), // rojo
  Color(0xFF10B981), // verde
  Color(0xFF0EA5E9), // celeste
  Color(0xFFEC4899), // rosado
];

// Datos tomados de las capturas enviadas.
// Reemplaza esta lista por la respuesta real de tu API/backend.
final List<ClientRecord> mockClients = [
  ClientRecord(
    docType: DocType.cc,
    docNumber: '102078588',
    name: 'Camila Torrez',
    email: 'camilatorrez@gmail.com',
    date: '20/05/2026',
    avatarColor: _avatarPalette[0],
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '922234455',
    name: 'Andrés Martinez',
    email: 'andresmartinez@yahoo.com',
    date: '20/06/2026',
    avatarColor: _avatarPalette[1],
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '134456867',
    name: 'Sofia Rodriguez',
    email: 'sofiarodriguez@gmail.com',
    date: '20/05/2026',
    avatarColor: _avatarPalette[1],
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: '445566778',
    name: 'Carlos Fernández',
    email: 'carlosfernandez@hotmail.com',
    date: '20/06/2026',
    avatarColor: _avatarPalette[2],
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1059887766',
    name: 'Cristian Muñoz',
    email: 'cristianm@gmail.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[2],
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '1023456789',
    name: 'Juan Esteban Gómez',
    email: 'juan.gomez@gmail.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[3],
  ),
  ClientRecord(
    docType: DocType.nit,
    docNumber: '205687788',
    name: 'Miguel Ángel Rojas',
    email: 'miguel.rojas@gmail.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[4],
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P44556677',
    name: 'Natalia Ramirez',
    email: 'natalia.ramirez@gmail.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[1],
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1123334455',
    name: 'Felipe Torres',
    email: 'felipe.torres@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[0],
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1003245678',
    name: 'María Fernanda López',
    email: 'marialopez@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[4],
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '105566778',
    name: 'Sara Jiménez',
    email: 'sara.jimenez@gmail.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[6],
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P99887766',
    name: 'Andrés Cárdenas',
    email: 'andrescardenas@gmail.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[2],
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1009887663',
    name: 'Daniela Herrera',
    email: 'daniela.herrera@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[3],
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '209765431',
    name: 'Alejandro Martínez',
    email: 'alejandro.martinez@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[4],
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1033445568',
    name: 'Paula Sánchez',
    email: 'paula.sanchez@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[0],
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '201234567',
    name: 'Nicolás Castro',
    email: 'nicolas.castro@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[1],
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P95778899',
    name: 'Juliana Moreno',
    email: 'juliana.moreno@email.com',
    date: '26/06/2026',
    avatarColor: _avatarPalette[5],
  ),
];

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================
class GestionClientesScreen extends StatefulWidget {
  final bool embedded;

  const GestionClientesScreen({super.key, this.embedded = false});

  @override
  State<GestionClientesScreen> createState() => _GestionClientesScreenState();
}

class _GestionClientesScreenState extends State<GestionClientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _estadoFiltro = 'Todos los estados';

  int get total => mockClients.length;
  int get activos => mockClients.where((c) => c.active).length;
  final int esteMes = 0;
  final int direcciones = 28;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        _TitleCard(total: total, activos: activos, esteMes: esteMes, direcciones: direcciones),
        const SizedBox(height: 14),
        _FiltersCard(
          controller: _searchController,
          estado: _estadoFiltro,
          onEstadoChanged: (v) => setState(() => _estadoFiltro = v),
          onClear: () => setState(() {
            _searchController.clear();
            _estadoFiltro = 'Todos los estados';
          }),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Base de Datos de Clientes',
                style: TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Text(
                '$total clientes',
                style: const TextStyle(color: AppColors.grayText, fontSize: 11.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _ClientsTable(clients: mockClients),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _TopHeader(),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HEADER SUPERIOR
// ============================================================
class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => InkWell(
              onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.menu, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text('T4D',
                style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('BIENVENIDO',
                    style: TextStyle(
                        color: AppColors.goldLight, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                Text('Cliente',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.notifications_none, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(color: AppColors.panelDark, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: AppColors.gold,
                  child: Icon(Icons.person, size: 11, color: AppColors.navy),
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
// TARJETA BLANCA SUPERIOR (título + botón + estadísticas)
// ============================================================
class _TitleCard extends StatelessWidget {
  final int total;
  final int activos;
  final int esteMes;
  final int direcciones;

  const _TitleCard({
    required this.total,
    required this.activos,
    required this.esteMes,
    required this.direcciones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gestión de Clientes',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                    SizedBox(height: 4),
                    Text('Administración de base de datos',
                        style: TextStyle(fontSize: 12, color: AppColors.cardWhiteSubtitle)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: navegar a formulario de nuevo cliente
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.navy,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nuevo Cliente', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'registrados',
                  title: 'Total Clientes',
                  value: '$total',
                  icon: Icons.people_outline,
                  iconColor: const Color(0xFF9CA3AF),
                  iconBg: const Color(0xFFF3F4F6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'clientes activos',
                  title: 'Activos',
                  value: '$activos',
                  icon: Icons.check_circle_outline,
                  iconColor: AppColors.green,
                  iconBg: AppColors.greenBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'nuevos registros',
                  title: 'Este Mes',
                  value: '$esteMes',
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF9CA3AF),
                  iconBg: const Color(0xFFF3F4F6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'registrados',
                  title: 'Direcciones',
                  value: '$direcciones',
                  icon: Icons.location_on_outlined,
                  iconColor: AppColors.goldDark,
                  iconBg: AppColors.goldBg,
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
  final String title;
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatBox({
    required this.title,
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
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280))),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
              ],
            ),
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
  final String estado;
  final ValueChanged<String> onEstadoChanged;
  final VoidCallback onClear;

  const _FiltersCard({
    required this.controller,
    required this.estado,
    required this.onEstadoChanged,
    required this.onClear,
  });

  static const List<String> _estados = [
    'Todos los estados',
    'Activo',
    'Inactivo',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.gold),
              SizedBox(width: 6),
              Text('Filtros y Búsqueda',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, documento, teléfono o correo',
              hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.grayText),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.grayText),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: estado,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.grayText),
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF111827)),
                      items: _estados.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {
                        if (v != null) onEstadoChanged(v);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                  side: const BorderSide(color: AppColors.borderLight),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.close, size: 14),
                label: const Text('Limpiar Filtros', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TABLA DE CLIENTES
// ============================================================
class _ClientsTable extends StatelessWidget {
  final List<ClientRecord> clients;
  const _ClientsTable({required this.clients});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Container(
              color: AppColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: const Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text('TIPO DOC.',
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.grayText, letterSpacing: 0.4)),
                  ),
                  Expanded(
                    child: Text('CLIENTE',
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.4)),
                  ),
                  Text('ACCIONES',
                      style: TextStyle(
                          fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.goldLight, letterSpacing: 0.4)),
                ],
              ),
            ),
            for (int i = 0; i < clients.length; i++) ...[
              _ClientRow(client: clients[i]),
              if (i != clients.length - 1) const Divider(height: 1, color: AppColors.borderLight),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClientRow extends StatelessWidget {
  final ClientRecord client;
  const _ClientRow({required this.client});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.docType.label,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: client.docType.color)),
                const SizedBox(height: 2),
                Text(client.docNumber, style: const TextStyle(fontSize: 9, color: AppColors.grayText), maxLines: 2),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: client.avatarColor,
                  child: Text(
                    client.initials,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.name,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                      Text(client.email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.neutral)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(client.date, style: const TextStyle(fontSize: 10, color: AppColors.grayText)),
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle, size: 11, color: client.active ? AppColors.green : AppColors.grayText),
                          const SizedBox(width: 2),
                          Text(
                            client.active ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: client.active ? AppColors.green : AppColors.grayText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Column(
            children: [
              _ActionIcon(icon: Icons.remove_red_eye_outlined, bg: AppColors.orangeBg, fg: AppColors.orange, onTap: () {}),
              const SizedBox(height: 4),
              _ActionIcon(icon: Icons.edit_outlined, bg: AppColors.orangeBg, fg: AppColors.orange, onTap: () {}),
              const SizedBox(height: 4),
              _ActionIcon(icon: Icons.delete_outline, bg: AppColors.redBg, fg: AppColors.red, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.bg, required this.fg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
        alignment: Alignment.center,
        child: Icon(icon, size: 13, color: fg),
      ),
    );
  }
}