import 'package:flutter/material.dart';

// ============================================================
// PALETA — tomada de las maquetas
// ============================================================
class AppColorsDir {
  static const fondo = Color(0xFFF7EFDD); // crema de fondo
  static const navy = Color(0xFF101B33); // header oscuro
  static const navyTexto = Color(0xFF16233F); // títulos
  static const subtitulo = Color(0xFF8D9CBB); // subtítulo del header

  static const dorado = Color(0xFFC9A24A); // botones / acentos
  static const doradoOscuro = Color(0xFF8A6D1F); // texto sobre crema
  static const doradoSuave = Color(0xFFF6EDD8); // fondo de pastillas/acciones
  static const doradoBorde = Color(0xFFECE0BD); // divisores

  static const azul = Color(0xFF2F6BE4); // acento de "Direcciones"
  static const verde = Color(0xFF22A45D); // acento de "Principales"
  static const verdeFondo = Color(0xFFDCF2E3);
  static const verdeTexto = Color(0xFF1E7A3D);

  static const rojo = Color(0xFFE05B66);
  static const rojoSuave = Color(0xFFFBE9EA);

  static const rosa = Color(0xFFE8548B); // ícono de teléfono
  static const gris = Color(0xFF8A8F98); // etiquetas
  static const grisTexto = Color(0xFF6B7280);
  static const inputBg = Color(0xFFEFE4CB); // fondo del buscador
  static const filaTinte = Color(0xFFFBF8F1); // fila de dirección principal

  // Alias conservados
  static const navyOscuro = navy;
  static const encabezado = navy;
  static const doradoClaro = doradoBorde;
  static const doradoTexto = dorado;
  static const textoMuted = grisTexto;
}

// ==================== MODELOS ====================
class AddressModel {
  final String id;
  String street;
  String city;
  String neighborhood;
  String status;
  String note;
  bool isPrincipal;

  AddressModel({
    required this.id,
    required this.street,
    required this.city,
    required this.neighborhood,
    required this.status,
    required this.note,
    this.isPrincipal = false,
  });
}

class ClientModel {
  String initials;
  Color avatarColor;
  String name;
  String idType;
  String idNumber;
  String status;
  String date;
  String phone;
  String email;
  final List<AddressModel> addresses;

  ClientModel({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.idType,
    required this.idNumber,
    required this.status,
    required this.date,
    required this.phone,
    required this.email,
    required this.addresses,
  });

  int get dirCount => addresses.length;
}

// ==================== DATOS ====================
// Todos los clientes tienen ahora sus dos direcciones registradas.
final List<ClientModel> clientsData = [
  ClientModel(
    initials: 'CT',
    avatarColor: const Color(0xFF7F77DD),
    name: 'Camila Torres',
    idType: 'CC',
    idNumber: '110278588',
    status: 'Activo',
    date: '19/05/2026',
    phone: '35267894',
    email: 'camilatorrez@gmail.com',
    addresses: [
      AddressModel(
        id: '#29',
        street: 'Calle 72 #15-30 Oficina 401',
        city: 'Bogotá',
        neighborhood: 'Chapinero',
        status: 'Activa',
        note: 'Edificio azul, piso 4',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#2',
        street: 'Calle 10 #45-90 Casa 2',
        city: 'Medellín',
        neighborhood: 'Belén',
        status: 'Activa',
        note: 'Casa color blanco frente al parque',
      ),
    ],
  ),
  ClientModel(
    initials: 'AM',
    avatarColor: const Color(0xFFE85D9E),
    name: 'Andrés Martínez',
    idType: 'CC',
    idNumber: '112233445',
    status: 'Activo',
    date: '19/05/2026',
    phone: '3204567890',
    email: 'andresmartinez@yahoo.com',
    addresses: [
      AddressModel(
        id: '#30',
        street: 'Diagonal 25G #95A-55',
        city: 'Bogotá',
        neighborhood: 'Kennedy',
        status: 'Activa',
        note: 'Bloque 4 apartamento 203',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#17',
        street: 'Calle 50 #12-40',
        city: 'Bogotá',
        neighborhood: 'Suba',
        status: 'Activa',
        note: 'Casa esquinera',
      ),
    ],
  ),
  ClientModel(
    initials: 'SR',
    avatarColor: const Color(0xFFF2994A),
    name: 'Sofía Rodríguez',
    idType: 'CE',
    idNumber: '334455987',
    status: 'Activo',
    date: '19/05/2026',
    phone: '3107891234',
    email: 'sofiarodriguez@gmail.com',
    addresses: [
      AddressModel(
        id: '#11',
        street: 'Carrera 18 #45-90',
        city: 'Medellín',
        neighborhood: 'El Poblado',
        status: 'Activa',
        note: 'Apartamento 502',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#12',
        street: 'Calle 100 #20-55',
        city: 'Bogotá',
        neighborhood: 'Usaquén',
        status: 'Activa',
        note: 'Tocar intercomunicador',
      ),
    ],
  ),
  ClientModel(
    initials: 'PS',
    avatarColor: const Color(0xFF8B7FE8),
    name: 'Paula Sánchez',
    idType: 'CC',
    idNumber: '1033445566',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3259012346',
    email: 'paula.sanchez@email.com',
    addresses: [
      AddressModel(
        id: '#51',
        street: 'Calle 26 #68-35',
        city: 'Bogotá',
        neighborhood: 'Salitre',
        status: 'Activa',
        note: 'Torre 1, apto 704',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#52',
        street: 'Carrera 15 #93-60',
        city: 'Bogotá',
        neighborhood: 'Chicó',
        status: 'Activa',
        note: 'Oficina 302',
      ),
    ],
  ),
  ClientModel(
    initials: 'CF',
    avatarColor: const Color(0xFF16A085),
    name: 'Carlos Fernández',
    idType: 'Pasaporte',
    idNumber: '445566778',
    status: 'Activo',
    date: '19/05/2026',
    phone: '3012345678',
    email: 'carlosfernandez@hotmail.com',
    addresses: [
      AddressModel(
        id: '#13',
        street: 'Avenida 45 #80-12',
        city: 'Cali',
        neighborhood: 'Granada',
        status: 'Activa',
        note: 'Torre 3 apartamento 601',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#14',
        street: 'Calle 44 #11-89',
        city: 'Cartagena',
        neighborhood: 'Manga',
        status: 'Activa',
        note: 'Recepción principal',
      ),
    ],
  ),
  ClientModel(
    initials: 'CM',
    avatarColor: const Color(0xFF2F80ED),
    name: 'Cristian Muñoz',
    idType: 'CC',
    idNumber: '1099887766',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3226895675',
    email: 'cristianm@gmail.com',
    addresses: [
      AddressModel(
        id: '#31',
        street: 'Calle 10 #15-20',
        city: 'Bogotá',
        neighborhood: 'Chapinero',
        status: 'Activa',
        note: 'Casa blanca, timbre 1 vez',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#32',
        street: 'Carrera 18 #45-67',
        city: 'Bogotá',
        neighborhood: 'Teusaquillo',
        status: 'Activa',
        note: 'Apartamento 302, portería',
      ),
    ],
  ),
  ClientModel(
    initials: 'JE',
    avatarColor: const Color(0xFFEB5757),
    name: 'Juan Esteban Gómez',
    idType: 'CE',
    idNumber: '1023456789',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3104567890',
    email: 'juan.gomez@gmail.com',
    addresses: [
      AddressModel(
        id: '#34',
        street: 'Carrera 8 #15-99',
        city: 'Cúcuta',
        neighborhood: 'La Playa',
        status: 'Activa',
        note: 'Timbre rojo',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#33',
        street: 'Calle 40 #20-55',
        city: 'Cúcuta',
        neighborhood: 'Caobos',
        status: 'Activa',
        note: 'Frente al supermercado',
      ),
    ],
  ),
  ClientModel(
    initials: 'MA',
    avatarColor: const Color(0xFF9B51E0),
    name: 'Miguel Ángel Rojas',
    idType: 'NIT',
    idNumber: '205667788',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3126789012',
    email: 'miguel.rojas@gmail.com',
    addresses: [
      AddressModel(
        id: '#35',
        street: 'Calle 18 #7-40',
        city: 'Pereira',
        neighborhood: 'Cuba',
        status: 'Activa',
        note: 'Casa de dos pisos',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#36',
        street: 'Carrera 11 #24-33',
        city: 'Pereira',
        neighborhood: 'Álamos',
        status: 'Activa',
        note: 'Portería Torre A',
      ),
    ],
  ),
  ClientModel(
    initials: 'NR',
    avatarColor: const Color(0xFFF2994A),
    name: 'Natalia Ramírez',
    idType: 'Pasaporte',
    idNumber: 'P44556677',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3137890123',
    email: 'natalia.ramirez@gmail.com',
    addresses: [
      AddressModel(
        id: '#38',
        street: 'Carrera 30 #12-18',
        city: 'Manizales',
        neighborhood: 'La Francia',
        status: 'Activa',
        note: 'Casa blanca',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#37',
        street: 'Calle 48 #19-22',
        city: 'Manizales',
        neighborhood: 'Palermo',
        status: 'Activa',
        note: 'Apartamento 503',
      ),
    ],
  ),
  ClientModel(
    initials: 'FT',
    avatarColor: const Color(0xFF56CCF2),
    name: 'Felipe Torres',
    idType: 'CC',
    idNumber: '1122334455',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3148901234',
    email: 'felipe.torres@gmail.com',
    addresses: [
      AddressModel(
        id: '#39',
        street: 'Calle 16 #14-50',
        city: 'Ibagué',
        neighborhood: 'Cádiz',
        status: 'Activa',
        note: 'Frente al parqueadero',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#40',
        street: 'Carrera 5 #38-42',
        city: 'Ibagué',
        neighborhood: 'Piedra Pintada',
        status: 'Activa',
        note: 'Portón café',
      ),
    ],
  ),
  ClientModel(
    initials: 'MF',
    avatarColor: const Color(0xFFF2C94C),
    name: 'María Fernanda López',
    idType: 'CC',
    idNumber: '1002345678',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3159012345',
    email: 'maria.lopez@gmail.com',
    addresses: [
      AddressModel(
        id: '#41',
        street: 'Calle 70 #90-15',
        city: 'Bogotá',
        neighborhood: 'Suba',
        status: 'Activa',
        note: 'Torre 3, apto 901',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#42',
        street: 'Carrera 92 #128-44',
        city: 'Bogotá',
        neighborhood: 'Suba',
        status: 'Activa',
        note: 'Recepción principal',
      ),
    ],
  ),
  ClientModel(
    initials: 'SJ',
    avatarColor: const Color(0xFFBB6BD9),
    name: 'Sara Jiménez',
    idType: 'CE',
    idNumber: '105566778',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3171234567',
    email: 'sara.jimenez@gmail.com',
    addresses: [
      AddressModel(
        id: '#44',
        street: 'Carrera 7 #170-22',
        city: 'Bogotá',
        neighborhood: 'Usaquén',
        status: 'Activa',
        note: 'Portería, preguntar apto 504',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#43',
        street: 'Calle 140 #19-50',
        city: 'Bogotá',
        neighborhood: 'Cedritos',
        status: 'Activa',
        note: 'Casa de fachada amarilla',
      ),
    ],
  ),
  ClientModel(
    initials: 'AC',
    avatarColor: const Color(0xFF2D9CDB),
    name: 'Andrés Cárdenas',
    idType: 'Pasaporte',
    idNumber: 'P99887766',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3248901235',
    email: 'andres.cardenas@gmail.com',
    addresses: [
      AddressModel(
        id: '#46',
        street: 'Carrera 80 #14-56',
        city: 'Cali',
        neighborhood: 'Ciudad Jardín',
        status: 'Activa',
        note: 'Portería principal',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#45',
        street: 'Calle 5 #66-40',
        city: 'Cali',
        neighborhood: 'San Fernando',
        status: 'Activa',
        note: 'Casa de rejas blancas',
      ),
    ],
  ),
  ClientModel(
    initials: 'DH',
    avatarColor: const Color(0xFFF06292),
    name: 'Daniela Herrera',
    idType: 'CC',
    idNumber: '1009876543',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3215678902',
    email: 'daniela.herrera@gmail.com',
    addresses: [
      AddressModel(
        id: '#47',
        street: 'Carrera 27 #61-15',
        city: 'Barranquilla',
        neighborhood: 'Alto Prado',
        status: 'Activa',
        note: 'Torre 2, apto 504',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#48',
        street: 'Carrera 46 #74-12',
        city: 'Barranquilla',
        neighborhood: 'Boston',
        status: 'Activa',
        note: 'Casa color crema',
      ),
    ],
  ),
  ClientModel(
    initials: 'AM',
    avatarColor: const Color(0xFF27AE60),
    name: 'Alejandro Martínez',
    idType: 'CE',
    idNumber: '208765432',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3226789013',
    email: 'alejandro.martinez@gmail.com',
    addresses: [
      AddressModel(
        id: '#49',
        street: 'Calle 30 #21-45',
        city: 'Cartagena',
        neighborhood: 'Bocagrande',
        status: 'Activa',
        note: 'Recepción del edificio',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#50',
        street: 'Calle 12 #8-25',
        city: 'Cartagena',
        neighborhood: 'Getsemaní',
        status: 'Activa',
        note: 'Casa azul',
      ),
    ],
  ),
  ClientModel(
    initials: 'NC',
    avatarColor: const Color(0xFFF2994A),
    name: 'Nicolás Castro',
    idType: 'CE',
    idNumber: '201234567',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3260123457',
    email: 'nicolas.castro@gmail.com',
    addresses: [
      AddressModel(
        id: '#53',
        street: 'Calle 9 #43-18',
        city: 'Bucaramanga',
        neighborhood: 'Cabecera',
        status: 'Activa',
        note: 'Edificio Portal, apto 803',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#54',
        street: 'Carrera 33 #52-70',
        city: 'Bucaramanga',
        neighborhood: 'Sotomayor',
        status: 'Activa',
        note: 'Casa con portón negro',
      ),
    ],
  ),
  ClientModel(
    initials: 'JM',
    avatarColor: const Color(0xFF2F80ED),
    name: 'Juliana Moreno',
    idType: 'Pasaporte',
    idNumber: 'P66778899',
    status: 'Activo',
    date: '25/06/2026',
    phone: '3282345679',
    email: 'juliana.moreno@gmail.com',
    addresses: [
      AddressModel(
        id: '#55',
        street: 'Calle 22 #6-40',
        city: 'Villavicencio',
        neighborhood: 'Barzal',
        status: 'Activa',
        note: 'Casa de dos pisos, reja blanca',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#56',
        street: 'Carrera 40 #26-11',
        city: 'Villavicencio',
        neighborhood: 'La Esperanza',
        status: 'Activa',
        note: 'Local 2, al lado de la panadería',
      ),
    ],
  ),
];


// ==================== PANTALLA PRINCIPAL ====================
class DireccionesClienteScreen extends StatefulWidget {
  final bool embedded;

  const DireccionesClienteScreen({super.key, this.embedded = false});

  @override
  State<DireccionesClienteScreen> createState() => _DireccionesClienteScreenState();
}

class _DireccionesClienteScreenState extends State<DireccionesClienteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _filtrosAbiertos = true;

  late List<ClientModel> _clients;
  int _addressIdCounter = 56;

  @override
  void initState() {
    super.initState();
    _clients = clientsData;
  }

  List<ClientModel> get _filteredClients {
    if (_query.trim().isEmpty) return _clients;
    final q = _query.toLowerCase();
    return _clients.where((c) {
      return c.name.toLowerCase().contains(q) || c.idNumber.toLowerCase().contains(q);
    }).toList();
  }

  int get _totalClientes => _clients.length;
  int get _totalDirecciones => _clients.fold(0, (sum, c) => sum + c.dirCount);
  int get _totalPrincipales =>
      _clients.fold(0, (sum, c) => sum + c.addresses.where((a) => a.isPrincipal).length);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // ACCIONES
  // ============================================================

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        backgroundColor: AppColorsDir.navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _computeInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].length >= 2 ? parts[0].substring(0, 2).toUpperCase() : parts[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  InputDecoration _dialogDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColorsDir.grisTexto, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsDir.doradoBorde, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsDir.dorado, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsDir.rojo),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsDir.rojo, width: 1.5),
      ),
    );
  }

  Widget _dialogField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: AppColorsDir.navyTexto),
      decoration: _dialogDecoration(label),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null : null,
    );
  }

  Widget _dialogHeader({
    required BuildContext dialogContext,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      color: AppColorsDir.navy,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorsDir.dorado.withValues(alpha: 0.18),
            ),
            child: Icon(icon, color: AppColorsDir.dorado, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColorsDir.subtitulo, fontSize: 12.5)),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(dialogContext, false),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close, color: Colors.white70, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogShell({required Widget child, double maxHeight = 640}) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(maxWidth: 420, maxHeight: maxHeight),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }

  Widget _dialogCancelButton(VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsDir.grisTexto,
        side: const BorderSide(color: AppColorsDir.doradoBorde),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _dialogConfirmButton({
    required String label,
    required VoidCallback onTap,
    Color background = AppColorsDir.dorado,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: background == AppColorsDir.dorado ? AppColorsDir.navy : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // -------- Editar cliente --------
  Future<void> _showEditClientDialog(ClientModel client) async {
    final nameCtrl = TextEditingController(text: client.name);
    final idNumberCtrl = TextEditingController(text: client.idNumber);
    final phoneCtrl = TextEditingController(text: client.phone);
    final emailCtrl = TextEditingController(text: client.email);
    String idType = client.idType;
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => _dialogShell(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogHeader(
                  dialogContext: ctx,
                  icon: Icons.manage_accounts_outlined,
                  title: 'Editar cliente',
                  subtitle: client.name,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogField(label: 'Nombre completo', controller: nameCtrl),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: idType,
                          decoration: _dialogDecoration('Tipo de documento'),
                          items: const ['CC', 'CE', 'NIT', 'Pasaporte']
                              .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t, style: const TextStyle(fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (v) => setDialogState(() => idType = v ?? idType),
                        ),
                        const SizedBox(height: 12),
                        _dialogField(label: 'Número de documento', controller: idNumberCtrl),
                        const SizedBox(height: 12),
                        _dialogField(label: 'Teléfono', controller: phoneCtrl, keyboardType: TextInputType.phone),
                        const SizedBox(height: 12),
                        _dialogField(
                            label: 'Correo electrónico',
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 16),
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
          ),
        ),
      ),
    );

    if (saved == true) {
      setState(() {
        client.name = nameCtrl.text.trim();
        client.idType = idType;
        client.idNumber = idNumberCtrl.text.trim();
        client.phone = phoneCtrl.text.trim();
        client.email = emailCtrl.text.trim();
        client.initials = _computeInitials(client.name);
      });
      _showSnack('Cliente actualizado correctamente');
    }
  }

  // -------- Agregar / editar dirección --------
  Future<void> _showAddressDialog(ClientModel client, {AddressModel? existing}) async {
    final isEditing = existing != null;
    final streetCtrl = TextEditingController(text: existing?.street ?? '');
    final cityCtrl = TextEditingController(text: existing?.city ?? '');
    final neighborhoodCtrl = TextEditingController(text: existing?.neighborhood ?? '');
    final noteCtrl = TextEditingController(text: existing?.note ?? '');
    String status = existing?.status ?? 'Activa';
    bool isPrincipal = existing?.isPrincipal ?? false;
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => _dialogShell(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogHeader(
                  dialogContext: ctx,
                  icon: isEditing ? Icons.edit_location_alt_outlined : Icons.add_location_alt_outlined,
                  title: isEditing ? 'Editar dirección' : 'Agregar dirección',
                  subtitle: 'Cliente: ${client.name}',
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogField(label: 'Dirección completa', controller: streetCtrl),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _dialogField(label: 'Ciudad', controller: cityCtrl)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _dialogField(
                                  label: 'Barrio', controller: neighborhoodCtrl, required: false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _dialogField(label: 'Indicaciones de entrega', controller: noteCtrl, required: false),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: status,
                          decoration: _dialogDecoration('Estado'),
                          items: const ['Activa', 'Inactiva']
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s, style: const TextStyle(fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (v) => setDialogState(() => status = v ?? status),
                        ),
                        CheckboxListTile(
                          value: isPrincipal,
                          onChanged: (v) => setDialogState(() => isPrincipal = v ?? false),
                          title: const Text(
                            'Marcar como dirección principal',
                            style: TextStyle(fontSize: 12.5, color: AppColorsDir.navyTexto),
                          ),
                          activeColor: AppColorsDir.dorado,
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
                                label: isEditing ? 'Guardar' : 'Guardar',
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
          ),
        ),
      ),
    );

    if (saved == true) {
      setState(() {
        if (isPrincipal) {
          for (final a in client.addresses) {
            a.isPrincipal = false;
          }
        }
        if (isEditing) {
          existing.street = streetCtrl.text.trim();
          existing.city = cityCtrl.text.trim();
          existing.neighborhood = neighborhoodCtrl.text.trim();
          existing.note = noteCtrl.text.trim();
          existing.status = status;
          existing.isPrincipal = isPrincipal;
        } else {
          _addressIdCounter++;
          client.addresses.add(AddressModel(
            id: '#$_addressIdCounter',
            street: streetCtrl.text.trim(),
            city: cityCtrl.text.trim(),
            neighborhood: neighborhoodCtrl.text.trim(),
            status: status,
            note: noteCtrl.text.trim(),
            isPrincipal: isPrincipal,
          ));
        }
      });
      _showSnack(isEditing ? 'Dirección actualizada' : 'Dirección agregada correctamente');
    }
  }

  // -------- Eliminar dirección --------
  Future<void> _confirmDeleteAddress(ClientModel client, AddressModel address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _dialogShell(
        maxHeight: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogHeader(
              dialogContext: ctx,
              icon: Icons.delete_outline,
              title: 'Eliminar dirección',
              subtitle: 'Cliente: ${client.name}',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Seguro que deseas eliminar la dirección "${address.street}"? Esta acción no se puede deshacer.',
                    style: const TextStyle(fontSize: 13.5, color: AppColorsDir.grisTexto, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _dialogCancelButton(() => Navigator.pop(ctx, false))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dialogConfirmButton(
                          label: 'Eliminar',
                          background: AppColorsDir.rojo,
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
      setState(() => client.addresses.remove(address));
      _showSnack('Dirección eliminada');
    }
  }

  // -------- Menú de acciones del cliente (editar / actualizar) --------
  Future<void> _showClientMenu(ClientModel client) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColorsDir.doradoBorde,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts_outlined, color: AppColorsDir.dorado),
              title: const Text('Editar cliente', style: TextStyle(fontSize: 14, color: AppColorsDir.navyTexto)),
              onTap: () {
                Navigator.pop(ctx);
                _showEditClientDialog(client);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: AppColorsDir.dorado),
              title: const Text('Actualizar datos', style: TextStyle(fontSize: 14, color: AppColorsDir.navyTexto)),
              onTap: () {
                Navigator.pop(ctx);
                _actualizarCliente(client);
              },
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // -------- Selector de cliente para agregar dirección --------
  Future<void> _showAddClientAddressPicker() async {
    if (_clients.isEmpty) return;
    final selected = await showDialog<ClientModel>(
      context: context,
      builder: (ctx) => _dialogShell(
        maxHeight: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogHeader(
              dialogContext: ctx,
              icon: Icons.add_location_alt_outlined,
              title: 'Agregar dirección',
              subtitle: 'Selecciona el cliente',
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: _clients.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, thickness: 0.6, color: AppColorsDir.doradoBorde),
                itemBuilder: (ctx2, i) {
                  final c = _clients[i];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: c.avatarColor,
                      child: Text(
                        c.initials,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(c.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600, color: AppColorsDir.navyTexto)),
                    subtitle: Text('${c.idType} — ${c.idNumber}',
                        style: const TextStyle(fontSize: 11.5, color: AppColorsDir.gris)),
                    onTap: () => Navigator.pop(ctx, c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) await _showAddressDialog(selected);
  }

  void _actualizarCliente(ClientModel client) {
    setState(() {});
    _showSnack('Datos de ${client.name} actualizados');
  }

  void _actualizarTodos() {
    setState(() {});
    _showSnack('Todos los clientes fueron actualizados');
  }

  // ============================================================
  // UI
  // ============================================================

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 16),
        _buildStatsRow(),
        const SizedBox(height: 16),
        _buildSearchCard(),
        const SizedBox(height: 20),
        Center(
          child: Text(
            '${_filteredClients.length} CLIENTES',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.6,
              color: AppColorsDir.gris,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._filteredClients.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ClientCard(
                client: c,
                onAddAddress: () => _showAddressDialog(c),
                onEditAddress: (a) => _showAddressDialog(c, existing: a),
                onDeleteAddress: (a) => _confirmDeleteAddress(c, a),
                onMenu: () => _showClientMenu(c),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) return _buildContent(context);

    return Scaffold(
      backgroundColor: AppColorsDir.fondo,
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColorsDir.navy,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_outlined, color: Colors.white),
        onPressed: () {},
      ),
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorsDir.dorado.withValues(alpha: 0.18),
            ),
            child: const Center(
              child: Text('T4D',
                  style: TextStyle(color: AppColorsDir.dorado, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('BIENVENIDO',
                  style: TextStyle(color: AppColorsDir.subtitulo, fontSize: 10, letterSpacing: 0.6)),
              Text('Direcciones Cliente',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
      ],
    );
  }

  // ---------- Encabezado navy ----------
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        color: AppColorsDir.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GERENTE · DIRECCIONES',
            style: TextStyle(
              color: AppColorsDir.dorado,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Direcciones\nde Clientes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gestión y administración de direcciones registradas',
            style: TextStyle(color: AppColorsDir.subtitulo, fontSize: 13, height: 1.35),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _GoldButton(
                  icon: Icons.add_location_alt_outlined,
                  label: 'Agregar dirección',
                  onTap: _showAddClientAddressPicker,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _GhostButton(onTap: _actualizarTodos)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Estadísticas con línea de color arriba ----------
  // IntrinsicHeight es obligatorio aquí: este Row vive directo dentro
  // de un ListView (altura infinita) y usa crossAxisAlignment.stretch,
  // así que necesita que algo le calcule una altura concreta antes de
  // poder "estirar" las tres tarjetas a la misma altura.
  Widget _buildStatsRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatCard(accent: AppColorsDir.dorado, value: '$_totalClientes', label: 'Clientes'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(accent: AppColorsDir.azul, value: '$_totalDirecciones', label: 'Direcciones'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(accent: AppColorsDir.verde, value: '$_totalPrincipales', label: 'Principales'),
          ),
        ],
      ),
    );
  }

  // ---------- Filtros y búsqueda (desplegable) ----------
  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _filtrosAbiertos = !_filtrosAbiertos),
            child: Row(
              children: [
                const Icon(Icons.filter_alt_outlined, color: AppColorsDir.dorado, size: 19),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Filtros y Búsqueda',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.5, color: AppColorsDir.navyTexto),
                  ),
                ),
                Icon(
                  _filtrosAbiertos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColorsDir.gris,
                  size: 22,
                ),
              ],
            ),
          ),
          if (_filtrosAbiertos) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(fontSize: 14, color: AppColorsDir.navyTexto),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o documento...',
                hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFA79B85)),
                prefixIcon: const Icon(Icons.search, size: 21, color: Color(0xFFA79B85)),
                filled: true,
                fillColor: AppColorsDir.inputBg,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColorsDir.dorado, width: 1.4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================

class _StatCard extends StatelessWidget {
  final Color accent;
  final String value;
  final String label;

  const _StatCard({required this.accent, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4, color: accent),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 14, 4, 14),
            child: Column(
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: accent),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColorsDir.gris),
                ),
              ],
            ),
          ),
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
      color: AppColorsDir.dorado,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: AppColorsDir.navy),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: AppColorsDir.navy, fontWeight: FontWeight.bold, fontSize: 12.5),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GhostButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text('Actualizar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;
  final bool dot;

  const _Pill({required this.text, required this.bg, required this.fg, this.icon, this.dot = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(text, style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.color, required this.bg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }
}

// ==================== TARJETA DE CLIENTE ====================
class ClientCard extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onAddAddress;
  final VoidCallback onMenu;
  final void Function(AddressModel address) onEditAddress;
  final void Function(AddressModel address) onDeleteAddress;

  const ClientCard({
    super.key,
    required this.client,
    required this.onAddAddress,
    required this.onMenu,
    required this.onEditAddress,
    required this.onDeleteAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: AppColorsDir.azul),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Encabezado del cliente ----
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: client.avatarColor),
                          alignment: Alignment.center,
                          child: Text(
                            client.initials,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client.name,
                                style: const TextStyle(
                                    fontSize: 16.5, fontWeight: FontWeight.bold, color: AppColorsDir.navyTexto),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${client.idType} — ${client.idNumber}',
                                style: const TextStyle(fontSize: 12.5, color: AppColorsDir.gris),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 14, color: AppColorsDir.rosa),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      client.phone,
                                      style: const TextStyle(
                                          fontSize: 13.5,
                                          color: AppColorsDir.navyTexto,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _Pill(
                              text: client.status,
                              bg: AppColorsDir.verdeFondo,
                              fg: AppColorsDir.verdeTexto,
                              dot: true,
                            ),
                            const SizedBox(height: 6),
                            _Pill(
                              text: '${client.dirCount} dir.',
                              bg: AppColorsDir.doradoSuave,
                              fg: AppColorsDir.doradoOscuro,
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: onMenu,
                              borderRadius: BorderRadius.circular(16),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.more_horiz, size: 20, color: AppColorsDir.gris),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ---- Direcciones ----
                  if (client.addresses.isEmpty)
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: AppColorsDir.doradoBorde, width: 1)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: const Text(
                        'Sin direcciones registradas',
                        style: TextStyle(
                            fontSize: 13, fontStyle: FontStyle.italic, color: AppColorsDir.gris),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (final a in client.addresses)
                          _AddressRow(
                            address: a,
                            onEdit: () => onEditAddress(a),
                            onDelete: () => onDeleteAddress(a),
                          ),
                      ],
                    ),

                  // ---- Botón principal ----
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: AppColorsDir.dorado,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: onAddAddress,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              '+ Agregar dirección',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColorsDir.navy, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
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
}

class _AddressRow extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressRow({required this.address, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: address.isPrincipal ? AppColorsDir.filaTinte : Colors.white,
        border: const Border(top: BorderSide(color: AppColorsDir.doradoBorde, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.location_on_outlined, size: 17, color: AppColorsDir.dorado),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.street,
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColorsDir.navyTexto, height: 1.25),
                ),
                const SizedBox(height: 3),
                Text(
                  address.neighborhood.isEmpty ? address.city : '${address.city} · ${address.neighborhood}',
                  style: const TextStyle(fontSize: 12.5, color: AppColorsDir.gris),
                ),
                if (address.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    address.note,
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic, color: AppColorsDir.gris),
                  ),
                ],
                if (address.status.toLowerCase() != 'activa') ...[
                  const SizedBox(height: 6),
                  const _Pill(text: 'Inactiva', bg: Color(0xFFF1F2F4), fg: AppColorsDir.grisTexto),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (address.isPrincipal) ...[
                    const _Pill(
                      text: 'Principal',
                      bg: AppColorsDir.doradoSuave,
                      fg: AppColorsDir.doradoOscuro,
                      icon: Icons.star,
                    ),
                    const SizedBox(width: 8),
                  ],
                  _ActionIcon(
                    icon: Icons.edit_outlined,
                    color: AppColorsDir.dorado,
                    bg: AppColorsDir.doradoSuave,
                    onTap: onEdit,
                  ),
                  const SizedBox(width: 8),
                  _ActionIcon(
                    icon: Icons.delete_outline,
                    color: AppColorsDir.rojo,
                    bg: AppColorsDir.rojoSuave,
                    onTap: onDelete,
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