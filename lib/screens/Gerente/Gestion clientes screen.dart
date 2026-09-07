import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Fondo general de la app
  static const Color fondo = Color(0xFFFAF3E4);

  // Header oscuro superior
  static const Color encabezado = Color(0xFF0F1B2E);
  static const Color navyClaro = Color(0xFF16233A);
  static const Color subtitulo = Color(0xFF8FA3C4);

  // Dorado (marca / acentos)
  static const Color dorado = Color(0xFFC9962E);
  static const Color doradoClaro = Color(0xFFE8C97A);
  static const Color doradoOscuro = Color(0xFF8C6B2E);
  // Punto medio exacto entre dorado y doradoOscuro
  static const Color doradoMezcla = Color(0xFFAB812E);

  // Básicos
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color grayText = Color(0xFF6B7280);
  static const Color textoMuted = Color(0xFF6B7280);
  static const Color neutral = grayText; // actualizado según nueva paleta
  static const Color orange = doradoOscuro; // actualizado según nueva paleta
  static const Color naranjaFondo = Color(0xFFF5E3C3);

  // Estados
  static const Color green = Color(0xFF2E9E5B);
  static const Color greenBg = Color(0xFFDDF2E1);
  static const Color red = Color(0xFFC0293B);
  static const Color redBg = Color(0xFFFADCE0);
  static const Color enlace = Color(0xFF2563EB);

  // Fondos suaves para los botones de acción (ver / editar / eliminar)
  static const Color viewBg = Color(0xFFF3F4F6);
  static const Color viewBorder = Color(0xFFE1E4E9);
  static const Color viewIcon = Color(0xFF6B7280);

  // ---- Nueva paleta unificada (aliases adicionales) ----
  static const navy = encabezado;
  static const background = fondo;
  static const panelDark = encabezado;
  static const gold = dorado;
  static const goldLight = doradoClaro;
  static const goldDark = doradoOscuro;
  static const goldBg = doradoClaro;
  static const borderLight = dorado;
  static const cardWhiteSubtitle = grayText;
  static const orangeBg = doradoClaro;
}

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

  // En el diseño final la etiqueta del tipo de documento siempre se
  // muestra en dorado (igual para CC, CE, Pasaporte y NIT), tal como
  // aparece en las imágenes de referencia.
  Color get color => AppColors.dorado;
}

// ============================================================
// MODELO DE DATOS
// ============================================================
class ClientRecord {
  final DocType docType;
  final String docNumber;
  final String name;
  final String phone;
  final String email;
  final String date;
  final bool active;
  final Color avatarColor;

  const ClientRecord({
    required this.docType,
    required this.docNumber,
    required this.name,
    required this.phone,
    required this.email,
    required this.date,
    required this.avatarColor,
    this.active = true,
  });

  ClientRecord copyWith({
    DocType? docType,
    String? docNumber,
    String? name,
    String? phone,
    String? email,
    String? date,
    bool? active,
    Color? avatarColor,
  }) {
    return ClientRecord(
      docType: docType ?? this.docType,
      docNumber: docNumber ?? this.docNumber,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      date: date ?? this.date,
      active: active ?? this.active,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

// Colores de avatar tomados EXACTAMENTE de las capturas enviadas, uno
// por cliente (no aleatorios), para que la lista luzca igual a la
// imagen de referencia.
final List<ClientRecord> mockClients = [
  ClientRecord(
    docType: DocType.cc,
    docNumber: '102078588',
    name: 'Camila Torrez',
    phone: '352 678 9794',
    email: 'camilatorrez@gmail.com',
    date: '20/05/2026',
    avatarColor: const Color(0xFF8B7FE8), // morado
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '922234455',
    name: 'Andrés Martinez',
    phone: '320 456 7890',
    email: 'andresmartinez@yahoo.com',
    date: '20/06/2026',
    avatarColor: const Color(0xFFE85D9E), // rosa/magenta
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '134456867',
    name: 'Sofia Rodriguez',
    phone: '310 789 1234',
    email: 'sofiarodriguez@gmail.com',
    date: '20/05/2026',
    avatarColor: const Color(0xFFF2994A), // naranja
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: '445566778',
    name: 'Carlos Fernández',
    phone: '301 234 5678',
    email: 'carlosfernandez@hotmail.com',
    date: '20/06/2026',
    avatarColor: const Color(0xFF16A085), // verde azulado
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1059887766',
    name: 'Cristian Muñoz',
    phone: '322 689 5675',
    email: 'cristianm@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF2F80ED), // azul
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '1023456789',
    name: 'Juan Esteban Gómez',
    phone: '310 456 7890',
    email: 'juan.gomez@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFEB5757), // rojo
  ),
  ClientRecord(
    docType: DocType.nit,
    docNumber: '205687788',
    name: 'Miguel Ángel Rojas',
    phone: '312 678 9012',
    email: 'miguel.rojas@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF9B51E0), // morado
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P44556677',
    name: 'Natalia Ramirez',
    phone: '313 789 0123',
    email: 'natalia.ramirez@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF2994A), // naranja
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1123334455',
    name: 'Felipe Torres',
    phone: '314 890 1234',
    email: 'felipe.torres@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF56CCF2), // celeste
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1003245678',
    name: 'María Fernanda López',
    phone: '315 901 2345',
    email: 'marialopez@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF2C94C), // amarillo/verde
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '105566778',
    name: 'Sara Jiménez',
    phone: '317 123 4567',
    email: 'sara.jimenez@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFBB6BD9), // fucsia
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P99887766',
    name: 'Andrés Cárdenas',
    phone: '324 890 1235',
    email: 'andrescardenas@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF2D9CDB), // azul cielo
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1009887663',
    name: 'Daniela Herrera',
    phone: '321 567 8902',
    email: 'daniela.herrera@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF06292), // rosado
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '209765431',
    name: 'Alejandro Martínez',
    phone: '322 678 9013',
    email: 'alejandro.martinez@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF27AE60), // verde
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1033445568',
    name: 'Paula Sánchez',
    phone: '325 901 2346',
    email: 'paula.sanchez@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF8B7FE8), // morado
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '201234567',
    name: 'Nicolás Castro',
    phone: '326 012 3467',
    email: 'nicolas.castro@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF2994A), // naranja
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P95778899',
    name: 'Juliana Moreno',
    phone: '328 234 5679',
    email: 'juliana.moreno@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF2F80ED), // azul
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

  // Lista mutable en memoria para que Ver / Editar / Eliminar
  // funcionen en tiempo real dentro de la pantalla.
  late List<ClientRecord> _clients;

  int get total => _clients.length;
  int get activos => _clients.where((c) => c.active).length;
  final int esteMes = 0;
  final int direcciones = 28;

  @override
  void initState() {
    super.initState();
    _clients = List.of(mockClients);
    _searchController.addListener(_onSearchChanged);
  }

  // ------------------------------------------------------------
  // FILTRADO: aplica búsqueda de texto + estado sobre _clients.
  // ------------------------------------------------------------
  List<ClientRecord> get _filteredClients {
    final query = _searchController.text.trim().toLowerCase();
    return _clients.where((c) {
      final matchesQuery = query.isEmpty ||
          c.name.toLowerCase().contains(query) ||
          c.docNumber.toLowerCase().contains(query) ||
          c.phone.toLowerCase().contains(query) ||
          c.email.toLowerCase().contains(query);

      final matchesEstado = _estadoFiltro == 'Todos los estados' ||
          (_estadoFiltro == 'Activo' && c.active) ||
          (_estadoFiltro == 'Inactivo' && !c.active);

      return matchesQuery && matchesEstado;
    }).toList();
  }

  void _onSearchChanged() => setState(() {});

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _estadoFiltro = 'Todos los estados';
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        backgroundColor: color ?? AppColors.encabezado,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ------------------------------------------------------------
  // Encabezado navy reutilizable para los diálogos (Ver / Editar /
  // Eliminar), con avatar/ícono, título y botón de cerrar.
  // ------------------------------------------------------------
  Widget _dialogHeader({
    required BuildContext dialogContext,
    required Widget leading,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: const BoxDecoration(
        color: AppColors.encabezado,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.doradoClaro, fontSize: 11.5),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(dialogContext),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close_rounded, color: Colors.white70, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogShell({required Widget child}) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.dorado, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(child: child),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.grayText, fontSize: 13),
      filled: true,
      fillColor: AppColors.fondo,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.doradoClaro),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
      ),
    );
  }

  Widget _dialogCancelButton(VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.grayText,
        side: const BorderSide(color: AppColors.doradoClaro),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.close_rounded, size: 16),
      label: const Text('Cancelar'),
    );
  }

  Widget _dialogConfirmButton({
    required String label,
    required VoidCallback onTap,
    Color bg = AppColors.dorado,
    Color fg = AppColors.encabezado,
    IconData icon = Icons.check_rounded,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.fondo,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.doradoClaro),
            ),
            child: Icon(icon, size: 15, color: AppColors.doradoOscuro),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.grayText)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------- VER CLIENTE --------
  void _showViewDialog(ClientRecord c) {
    showDialog(
      context: context,
      builder: (ctx) => _dialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogHeader(
              dialogContext: ctx,
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: c.avatarColor,
                child: Text(c.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: c.name,
              subtitle: '${c.docType.label} • ${c.docNumber}',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.call_rounded, 'Teléfono', c.phone),
                  _infoRow(Icons.mail_outline_rounded, 'Correo electrónico', c.email),
                  _infoRow(Icons.event_rounded, 'Fecha de registro', c.date),
                  _infoRow(
                    c.active ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    'Estado',
                    c.active ? 'Activo' : 'Inactivo',
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: _dialogConfirmButton(
                      label: 'Cerrar',
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.pop(ctx),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------- EDITAR CLIENTE --------
  Future<void> _showEditDialog(ClientRecord c) async {
    final nameCtrl = TextEditingController(text: c.name);
    final phoneCtrl = TextEditingController(text: c.phone);
    final emailCtrl = TextEditingController(text: c.email);
    final docNumberCtrl = TextEditingController(text: c.docNumber);
    DocType docType = c.docType;
    bool active = c.active;
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return _dialogShell(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    dialogContext: ctx,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.dorado, width: 1.5),
                      ),
                      child: const Icon(Icons.manage_accounts_rounded, color: AppColors.dorado, size: 18),
                    ),
                    title: 'Editar cliente',
                    subtitle: c.name,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _fieldDecoration('Nombre completo'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<DocType>(
                            value: docType,
                            decoration: _fieldDecoration('Tipo de documento'),
                            items: DocType.values
                                .map((t) => DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 13))))
                                .toList(),
                            onChanged: (v) => setDialogState(() => docType = v ?? docType),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: docNumberCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _fieldDecoration('Número de documento'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _fieldDecoration('Teléfono'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _fieldDecoration('Correo electrónico'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 4),
                          CheckboxListTile(
                            value: active,
                            onChanged: (v) => setDialogState(() => active = v ?? active),
                            title: const Text('Cliente activo', style: TextStyle(fontSize: 12.5, color: AppColors.encabezado)),
                            activeColor: AppColors.dorado,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _dialogCancelButton(() => Navigator.pop(ctx, false))),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _dialogConfirmButton(
                                  label: 'Guardar',
                                  onTap: () {
                                    if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (saved == true) {
      final index = _clients.indexOf(c);
      if (index != -1) {
        setState(() {
          _clients[index] = c.copyWith(
            name: nameCtrl.text.trim(),
            docType: docType,
            docNumber: docNumberCtrl.text.trim(),
            phone: phoneCtrl.text.trim(),
            email: emailCtrl.text.trim(),
            active: active,
          );
        });
        _showSnack('Cliente actualizado correctamente');
      }
    }
  }

  // -------- ELIMINAR CLIENTE --------
  Future<void> _confirmDelete(ClientRecord c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _dialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogHeader(
              dialogContext: ctx,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.red, width: 1.5),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 18),
              ),
              title: 'Eliminar cliente',
              subtitle: c.name,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Seguro que deseas eliminar a "${c.name}"? Esta acción no se puede deshacer.',
                    style: const TextStyle(fontSize: 13, color: AppColors.grayText, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _dialogCancelButton(() => Navigator.pop(ctx, false))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dialogConfirmButton(
                          label: 'Eliminar',
                          icon: Icons.delete_outline_rounded,
                          bg: AppColors.red,
                          fg: Colors.white,
                          onTap: () => Navigator.pop(ctx, true),
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
    );

    if (confirmed == true) {
      setState(() => _clients.remove(c));
      _showSnack('Cliente eliminado', color: AppColors.red);
    }
  }

  Widget _buildContent(BuildContext context) {
    final filtered = _filteredClients;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        const _PageHeaderCard(
          eyebrow: 'ADMINISTRADOR - CLIENTES',
          title: 'Gestión de Clientes',
          subtitle: 'Administra la información de tus clientes',
        ),
        const SizedBox(height: 14),
        _StatsAndActionCard(total: total, activos: activos, esteMes: esteMes, direcciones: direcciones),
        const SizedBox(height: 14),
        _FiltersCard(
          controller: _searchController,
          estado: _estadoFiltro,
          onEstadoChanged: (v) => setState(() => _estadoFiltro = v),
          onClear: _clearFilters,
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
                '${filtered.length} clientes',
                style: const TextStyle(color: AppColors.grayText, fontSize: 11.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (filtered.isEmpty)
          _EmptyState(onClear: _clearFilters)
        else
          _ClientsTable(
            clients: filtered,
            onView: _showViewDialog,
            onEdit: _showEditDialog,
            onDelete: _confirmDelete,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }
    return Scaffold(
      backgroundColor: AppColors.fondo,
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
              color: AppColors.subtitulo,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
              SizedBox(width: 3),
              Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
            ],
          ),
        ],
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
      color: AppColors.encabezado,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => InkWell(
              onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.menu_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: AppColors.dorado, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text(
              'T4D',
              style: TextStyle(color: AppColors.encabezado, fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    color: AppColors.doradoClaro,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Cliente',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.notifications_none_rounded, color: AppColors.subtitulo, size: 20),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(color: AppColors.navyClaro, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: AppColors.dorado,
                  child: Icon(Icons.person_rounded, size: 11, color: AppColors.encabezado),
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
// TARJETA DE ESTADÍSTICAS + BOTÓN "NUEVO CLIENTE"
// ============================================================
class _StatsAndActionCard extends StatelessWidget {
  final int total;
  final int activos;
  final int esteMes;
  final int direcciones;

  const _StatsAndActionCard({
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
        border: Border.all(color: AppColors.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------
          // Botón "Nuevo Cliente": mismo widget/estilo dorado que
          // "Agregar dirección" (Material + InkWell), en vez de
          // ElevatedButton, para que el color quede IDÉNTICO
          // (ElevatedButton en Material 3 aplica un tinte propio
          // que hacía lucir el dorado ligeramente distinto).
          // ---------------------------------------------------
          Align(
            alignment: Alignment.centerRight,
            child: _GoldButton(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Nuevo Cliente',
              onTap: () {
                // TODO: navegar a formulario de nuevo cliente
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'registrados',
                  title: 'Total Clientes',
                  value: '$total',
                  icon: Icons.contact_page_outlined,
                  accentColor: AppColors.dorado,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'clientes activos',
                  title: 'Activos',
                  value: '$activos',
                  icon: Icons.task_alt_rounded,
                  accentColor: AppColors.green,
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
                  icon: Icons.event_note_rounded,
                  accentColor: AppColors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'registradas',
                  title: 'Direcciones',
                  value: '$direcciones',
                  icon: Icons.map_outlined,
                  accentColor: AppColors.doradoOscuro,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BOTÓN DORADO REUTILIZABLE
// Mismo widget (Material + InkWell) que "Agregar dirección", para
// que el color y el aspecto sean EXACTAMENTE iguales en toda la app.
// ============================================================
class _GoldButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool expand;

  const _GoldButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColors.dorado,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: AppColors.encabezado),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.encabezado,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _StatBox({
    required this.title,
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fondo,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textoMuted)),
              ),
              Icon(icon, size: 14, color: accentColor),
            ],
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
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
        border: Border.all(color: AppColors.dorado, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tune_rounded, size: 16, color: AppColors.dorado),
              SizedBox(width: 6),
              Text('Filtros y Búsqueda',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return TextField(
                controller: controller,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, documento, teléfono o correo',
                  hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.grayText),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.grayText),
                  suffixIcon: controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.grayText),
                          onPressed: controller.clear,
                        ),
                  filled: true,
                  fillColor: AppColors.fondo,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.doradoClaro),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.doradoClaro),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.dorado),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.fondo,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.doradoClaro),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: estado,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.grayText),
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
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
                  foregroundColor: AppColors.encabezado,
                  side: const BorderSide(color: AppColors.doradoClaro),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.close_rounded, size: 14),
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
// ESTADO VACÍO
// ============================================================
class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro, width: 1.2),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 34, color: AppColors.grayText),
          const SizedBox(height: 10),
          const Text(
            'No se encontraron clientes',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 4),
          const Text(
            'Intenta con otro término de búsqueda o cambia el filtro de estado.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: AppColors.grayText),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onClear,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.encabezado,
              side: const BorderSide(color: AppColors.doradoClaro),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.close_rounded, size: 14),
            label: const Text('Limpiar Filtros', style: TextStyle(fontSize: 11.5)),
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
  final ValueChanged<ClientRecord> onView;
  final ValueChanged<ClientRecord> onEdit;
  final ValueChanged<ClientRecord> onDelete;

  const _ClientsTable({
    required this.clients,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.dorado, width: 1.2),
        ),
        child: Column(
          children: [
            Container(
              color: AppColors.encabezado,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: const Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text('TIPO DOC.',
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.doradoClaro, letterSpacing: 0.4)),
                  ),
                  Expanded(
                    child: Text('CLIENTE',
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.4)),
                  ),
                  SizedBox(
                    width: 102,
                    child: Text('ACCIONES',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.doradoClaro, letterSpacing: 0.4)),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < clients.length; i++) ...[
              _ClientRow(
                client: clients[i],
                onView: () => onView(clients[i]),
                onEdit: () => onEdit(clients[i]),
                onDelete: () => onDelete(clients[i]),
              ),
              if (i != clients.length - 1) const Divider(height: 1, color: AppColors.doradoClaro),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClientRow extends StatelessWidget {
  final ClientRecord client;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClientRow({
    required this.client,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

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
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 1),
                      Text(client.phone,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.grayText)),
                      Text(client.email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.neutral)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(client.date, style: const TextStyle(fontSize: 10, color: AppColors.grayText)),
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle_rounded,
                              size: 11, color: client.active ? AppColors.green : AppColors.grayText),
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
          _ClientActionIcons(onView: onView, onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}

// ============================================================
// ICONOS DE ACCIÓN (Ver / Editar / Eliminar)
// Tres botones cuadrados independientes, cada uno con su color
// suave de fondo + borde, igual a como aparece en las imágenes
// de referencia.
// ============================================================
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
      ),
    );
  }
}

class _ClientActionIcons extends StatelessWidget {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClientActionIcons({required this.onView, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionIconButton(
          icon: Icons.visibility_outlined,
          iconColor: AppColors.viewIcon,
          bgColor: AppColors.viewBg,
          borderColor: AppColors.viewBorder,
          onTap: onView,
        ),
        const SizedBox(width: 6),
        _ActionIconButton(
          icon: Icons.edit_outlined,
          iconColor: AppColors.doradoOscuro,
          bgColor: AppColors.doradoClaro.withOpacity(0.28),
          borderColor: AppColors.doradoClaro,
          onTap: onEdit,
        ),
        const SizedBox(width: 6),
        _ActionIconButton(
          icon: Icons.delete_outline_rounded,
          iconColor: AppColors.red,
          bgColor: AppColors.redBg,
          borderColor: AppColors.red.withOpacity(0.35),
          onTap: onDelete,
        ),
      ],
    );
  }
}