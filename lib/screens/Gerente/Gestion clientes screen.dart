import 'package:flutter/material.dart';

// ============================================================
// COLORES
// ============================================================
class AppColors {
  AppColors._();

  static const Color fondo = Color(0xFFFAF3E4);
  static const Color encabezado = Color(0xFF0F1B2E);
  static const Color navyClaro = Color(0xFF16233A);
  static const Color subtitulo = Color(0xFF8FA3C4);

  static const Color dorado = Color(0xFFC9962E);
  static const Color doradoClaro = Color(0xFFE8C97A);
  static const Color doradoOscuro = Color(0xFF8C6B2E);

  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color grayText = Color(0xFF6B7280);
  static const Color textoMuted = Color(0xFF9CA3AF);

  static const Color green = Color(0xFF2E9E5B);
  static const Color greenBg = Color(0xFFDDF2E1);
  static const Color red = Color(0xFFC0293B);
  static const Color redBg = Color(0xFFFADCE0);

  // Fondo blanco puro + borde tenue para el buscador, para que la
  // lupa y el placeholder se lean con claridad.
  static const Color searchBg = Colors.white;
  static const Color searchBorder = Color(0xFFD9B26A);

  // Fondos suaves para los botones de acción (editar / eliminar)
  static const Color editBg = Color(0xFFF5E3C3);
  static const Color cancelBg = Color(0xFFEFE6D0);

  // Colores usados para el texto del tipo de documento en cada
  // tarjeta de cliente (igual a como aparece en las capturas).
  static const Color docCC = Color(0xFF2F80ED);
  static const Color docCE = Color(0xFF9B51E0);
  static const Color docPasaporte = Color(0xFFF2994A);
  static const Color docNIT = Color(0xFF27AE60);
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

  String get fullLabel {
    switch (this) {
      case DocType.cc:
        return 'Cédula (CC)';
      case DocType.ce:
        return 'Cédula de Extranjería (CE)';
      case DocType.pasaporte:
        return 'Pasaporte';
      case DocType.nit:
        return 'NIT';
    }
  }

  Color get color {
    switch (this) {
      case DocType.cc:
        return AppColors.docCC;
      case DocType.ce:
        return AppColors.docCE;
      case DocType.pasaporte:
        return AppColors.docPasaporte;
      case DocType.nit:
        return AppColors.docNIT;
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

const List<Color> _avatarPalette = [
  Color(0xFF8B7FE8),
  Color(0xFFE85D9E),
  Color(0xFFF2994A),
  Color(0xFF16A085),
  Color(0xFF2F80ED),
  Color(0xFFEB5757),
  Color(0xFF9B51E0),
  Color(0xFF56CCF2),
  Color(0xFFF2C94C),
  Color(0xFFBB6BD9),
  Color(0xFF2D9CDB),
  Color(0xFFF06292),
  Color(0xFF27AE60),
];

// Los mismos bordes de color de la izquierda que se ven en las
// capturas, uno por cliente, rotativos.
const List<Color> _cardBorderPalette = [
  Color(0xFF2F80ED),
  Color(0xFF9B51E0),
  Color(0xFFF2994A),
  Color(0xFF16A085),
  Color(0xFFEB5757),
  Color(0xFF27AE60),
  Color(0xFF56CCF2),
  Color(0xFFBB6BD9),
];

final List<ClientRecord> mockClients = [
  ClientRecord(
    docType: DocType.cc,
    docNumber: '110276588',
    name: 'Camila Torrez',
    phone: '35267894',
    email: 'camilatorrez11@gmail.com',
    date: '20/05/2026',
    avatarColor: const Color(0xFF8B7FE8),
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '112233445',
    name: 'Andrés Martínez',
    phone: '3204567890',
    email: 'andresmartinez@yahoo.com',
    date: '20/05/2026',
    avatarColor: const Color(0xFFE85D9E),
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '334455667',
    name: 'Sofía Rodríguez',
    phone: '3107891234',
    email: 'sofiarodriguez@gmail.com',
    date: '20/05/2026',
    avatarColor: const Color(0xFFF2994A),
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: '445566778',
    name: 'Carlos Fernández',
    phone: '3012345678',
    email: 'carlosfernandez@hotmail.com',
    date: '20/05/2026',
    avatarColor: const Color(0xFF16A085),
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1099887766',
    name: 'Cristian Muñoz',
    phone: '3226895675',
    email: 'cristianm@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF2F80ED),
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '1023456789',
    name: 'Juan Esteban Gómez',
    phone: '3104567890',
    email: 'juan.gomez@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFEB5757),
  ),
  ClientRecord(
    docType: DocType.nit,
    docNumber: '205667788',
    name: 'Miguel Ángel Rojas',
    phone: '3126789012',
    email: 'miguel.rojas@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF9B51E0),
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P44556677',
    name: 'Natalia Ramírez',
    phone: '3137890123',
    email: 'natalia.ramirez@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF2994A),
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1122334455',
    name: 'Felipe Torres',
    phone: '3148901234',
    email: 'felipe.torres@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF56CCF2),
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1002345678',
    name: 'María Fernanda López',
    phone: '3159012345',
    email: 'maria.lopez@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF2C94C),
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '105566778',
    name: 'Sara Jiménez',
    phone: '3171234567',
    email: 'sara.jimenez@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFBB6BD9),
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P99887766',
    name: 'Andrés Cárdenas',
    phone: '3248901235',
    email: 'andres.cardenas@gmail.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF2D9CDB),
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1009876543',
    name: 'Daniela Herrera',
    phone: '3215678902',
    email: 'daniela.herrera@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF06292),
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '208765432',
    name: 'Alejandro Martínez',
    phone: '3226789013',
    email: 'alejandro.martinez@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF27AE60),
  ),
  ClientRecord(
    docType: DocType.cc,
    docNumber: '1033445566',
    name: 'Paula Sánchez',
    phone: '3259012346',
    email: 'paula.sanchez@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF8B7FE8),
  ),
  ClientRecord(
    docType: DocType.ce,
    docNumber: '201234567',
    name: 'Nicolás Castro',
    phone: '3260123457',
    email: 'nicolas.castro@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFFF2994A),
  ),
  ClientRecord(
    docType: DocType.pasaporte,
    docNumber: 'P66778899',
    name: 'Juliana Moreno',
    phone: '3282345679',
    email: 'juliana.moreno@email.com',
    date: '26/06/2026',
    avatarColor: const Color(0xFF2F80ED),
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

  // 'Todos', 'Activo' o 'Inactivo'
  String _estadoFiltro = 'Todos';

  late List<ClientRecord> _clients;

  int get total => _clients.length;
  int get activos => _clients.where((c) => c.active).length;
  int get inactivos => _clients.where((c) => !c.active).length;

  @override
  void initState() {
    super.initState();
    _clients = List.of(mockClients);
    _searchController.addListener(_onSearchChanged);
  }

  List<ClientRecord> get _filteredClients {
    final query = _searchController.text.trim().toLowerCase();
    return _clients.where((c) {
      final matchesQuery = query.isEmpty ||
          c.name.toLowerCase().contains(query) ||
          c.docNumber.toLowerCase().contains(query) ||
          c.phone.toLowerCase().contains(query) ||
          c.email.toLowerCase().contains(query);

      final matchesEstado = _estadoFiltro == 'Todos' ||
          (_estadoFiltro == 'Activo' && c.active) ||
          (_estadoFiltro == 'Inactivo' && !c.active);

      return matchesQuery && matchesEstado;
    }).toList();
  }

  void _onSearchChanged() => setState(() {});

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _estadoFiltro = 'Todos';
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

  String _todayFormatted() {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    final y = now.year.toString();
    return '$d/$m/$y';
  }

  // ------------------------------------------------------------
  // Encabezado navy reutilizable para los diálogos.
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
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8)),
          ],
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

  Widget _formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.encabezado),
      ),
    );
  }

  InputDecoration _newClientFieldDecoration([String hint = '']) {
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      hintStyle: const TextStyle(color: AppColors.grayText, fontSize: 13),
      filled: true,
      fillColor: AppColors.fondo,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.doradoClaro),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 1.4),
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

  Widget _wideCancelButton(VoidCallback onTap) {
    return Material(
      color: AppColors.cancelBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.encabezado, fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _wideSaveButton(VoidCallback onTap) {
    return Material(
      color: AppColors.dorado,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: const Text(
            'Guardar',
            style: TextStyle(color: AppColors.encabezado, fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ),
    );
  }

  // -------- NUEVO CLIENTE --------
  Future<void> _showAddDialog() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final docNumberCtrl = TextEditingController();
    DocType docType = DocType.cc;
    bool active = true;
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
                      child: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.dorado, size: 18),
                    ),
                    title: 'Nuevo Cliente',
                    subtitle: 'Gerente • Clientes',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formLabel('Tipo de Documento'),
                          DropdownButtonFormField<DocType>(
                            value: docType,
                            decoration: _newClientFieldDecoration(),
                            items: DocType.values
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t.fullLabel, style: const TextStyle(fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (v) => setDialogState(() => docType = v ?? docType),
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Número de Documento'),
                          TextFormField(
                            controller: docNumberCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration('Ej: 1234567890'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Nombre Completo'),
                          TextFormField(
                            controller: nameCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration('Nombre y apellidos'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Teléfono'),
                          TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration('+57 300 000 0000'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Correo Electrónico'),
                          TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration('correo@email.com'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Estado'),
                          DropdownButtonFormField<bool>(
                            value: active,
                            decoration: _newClientFieldDecoration(),
                            items: const [
                              DropdownMenuItem(value: true, child: Text('Activo', style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(value: false, child: Text('Inactivo', style: TextStyle(fontSize: 13))),
                            ],
                            onChanged: (v) => setDialogState(() => active = v ?? active),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: _wideCancelButton(() => Navigator.pop(ctx, false))),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _wideSaveButton(() {
                                  if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
                                }),
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
      final newClient = ClientRecord(
        docType: docType,
        docNumber: docNumberCtrl.text.trim(),
        name: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        date: _todayFormatted(),
        active: active,
        avatarColor: _avatarPalette[_clients.length % _avatarPalette.length],
      );
      setState(() {
        _clients.insert(0, newClient);
      });
      _showSnack('Cliente agregado correctamente');
    }
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
                      child: const Icon(Icons.edit_rounded, color: AppColors.dorado, size: 18),
                    ),
                    title: 'Editar Cliente',
                    subtitle: 'Gerente • Clientes',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formLabel('Tipo de Documento'),
                          DropdownButtonFormField<DocType>(
                            value: docType,
                            decoration: _newClientFieldDecoration(),
                            items: DocType.values
                                .map((t) => DropdownMenuItem(value: t, child: Text(t.fullLabel, style: const TextStyle(fontSize: 13))))
                                .toList(),
                            onChanged: (v) => setDialogState(() => docType = v ?? docType),
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Número de Documento'),
                          TextFormField(
                            controller: docNumberCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration(),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Nombre Completo'),
                          TextFormField(
                            controller: nameCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration(),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Teléfono'),
                          TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration(),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Correo Electrónico'),
                          TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 13, color: AppColors.encabezado),
                            decoration: _newClientFieldDecoration(),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),
                          _formLabel('Estado'),
                          DropdownButtonFormField<bool>(
                            value: active,
                            decoration: _newClientFieldDecoration(),
                            items: const [
                              DropdownMenuItem(value: true, child: Text('Activo', style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(value: false, child: Text('Inactivo', style: TextStyle(fontSize: 13))),
                            ],
                            onChanged: (v) => setDialogState(() => active = v ?? active),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: _wideCancelButton(() => Navigator.pop(ctx, false))),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _wideSaveButton(() {
                                  if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
                                }),
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
        _HeaderCard(onNewClient: _showAddDialog),
        const SizedBox(height: 14),
        _StatsRow(total: total, activos: activos, inactivos: inactivos),
        const SizedBox(height: 14),
        _FiltersCard(
          controller: _searchController,
          estado: _estadoFiltro,
          onEstadoChanged: (v) => setState(() => _estadoFiltro = v),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            '${filtered.length} CLIENTES',
            style: const TextStyle(
              color: AppColors.doradoOscuro,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (filtered.isEmpty)
          _EmptyState(onClear: _clearFilters)
        else
          for (int i = 0; i < filtered.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ClientCard(
                client: filtered[i],
                borderColor: _cardBorderPalette[i % _cardBorderPalette.length],
                onEdit: () => _showEditDialog(filtered[i]),
                onDelete: () => _confirmDelete(filtered[i]),
              ),
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
// HEADER SUPERIOR (barra de la app)
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
                Text('BIENVENIDO',
                    style: TextStyle(color: AppColors.doradoClaro, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                Text('Gerente', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Icon(Icons.notifications_none_rounded, color: AppColors.subtitulo, size: 20),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO (navy + botón Nuevo Cliente)
// ============================================================
class _HeaderCard extends StatelessWidget {
  final VoidCallback onNewClient;
  const _HeaderCard({required this.onNewClient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.encabezado,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GERENTE · CLIENTES',
                      style: TextStyle(color: AppColors.dorado, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gestión de\nClientes',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Administración de base de datos',
                      style: TextStyle(color: AppColors.subtitulo, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: AppColors.dorado,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onNewClient,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 16, color: AppColors.encabezado),
                      SizedBox(width: 6),
                      Text('Nuevo Cliente',
                          style: TextStyle(color: AppColors.encabezado, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FILA DE ESTADÍSTICAS (Total / Activos / Inactivos)
// ============================================================
class _StatsRow extends StatelessWidget {
  final int total;
  final int activos;
  final int inactivos;

  const _StatsRow({required this.total, required this.activos, required this.inactivos});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatBox(value: '$total', label: 'Total', color: AppColors.dorado)),
        const SizedBox(width: 10),
        Expanded(child: _StatBox(value: '$activos', label: 'Activos', color: AppColors.green)),
        const SizedBox(width: 10),
        Expanded(child: _StatBox(value: '$inactivos', label: 'Inactivos', color: AppColors.red)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatBox({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 1.6),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textoMuted)),
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

  const _FiltersCard({
    required this.controller,
    required this.estado,
    required this.onEstadoChanged,
  });

  static const List<String> _estados = ['Todos', 'Activo', 'Inactivo'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.filter_alt_outlined, size: 17, color: AppColors.dorado),
              SizedBox(width: 6),
              Text('Filtros y Búsqueda',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, documento, teléfono...',
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.doradoOscuro),
                    suffixIcon: controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.grayText),
                            onPressed: controller.clear,
                          ),
                    filled: true,
                    fillColor: AppColors.searchBg,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.searchBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.searchBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.dorado, width: 1.6),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _estados.map((e) {
              final selected = e == estado;
              return _FilterChip(
                label: e,
                selected: selected,
                onTap: () => onEstadoChanged(e),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.dorado : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.dorado : const Color(0xFFE5D9BE)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.grayText,
            ),
          ),
        ),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
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
// TARJETA DE CLIENTE (una por cliente, con borde de color)
// ============================================================
class _ClientCard extends StatelessWidget {
  final ClientRecord client;
  final Color borderColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClientCard({
    required this.client,
    required this.borderColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: client.avatarColor,
                child: Text(client.initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${client.docType.label}  ',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: client.docType.color),
                          ),
                          TextSpan(
                            text: client.docNumber,
                            style: const TextStyle(fontSize: 10.5, color: AppColors.grayText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: client.active ? AppColors.greenBg : AppColors.redBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  client.active ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: client.active ? AppColors.green : AppColors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          _infoLine(Icons.call_outlined, client.phone),
          const SizedBox(height: 6),
          _infoLine(Icons.mail_outline_rounded, client.email),
          const SizedBox(height: 6),
          _infoLine(Icons.calendar_today_outlined, 'Registrado: ${client.date}'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionIconButton(icon: Icons.edit_rounded, iconColor: AppColors.doradoOscuro, bgColor: AppColors.editBg, onTap: onEdit),
              const SizedBox(width: 8),
              _ActionIconButton(icon: Icons.delete_rounded, iconColor: AppColors.red, bgColor: AppColors.redBg, onTap: onDelete),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.grayText),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: AppColors.grayText),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// BOTÓN DE ACCIÓN (editar / eliminar)
// ============================================================
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}