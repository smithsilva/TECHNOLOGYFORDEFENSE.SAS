import 'package:flutter/material.dart';

class AppColorsDir {
  // ---- Paleta nueva ----
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
  static const encabezado = navyOscuro; // header + texto oscuro
  static const verdeFondoAlias = verdeFondo;
  static const grisTexto = textoMuted;
}

// ==================== MODELOS ====================
// NOTA: los campos dejaron de ser "final" (excepto el id de la
// dirección, que es su identificador) para poder editarlos y
// eliminarlos en tiempo real desde la UI.
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
final List<ClientModel> clientsData = [
  ClientModel(
    initials: 'CT',
    avatarColor: const Color(0xFF8B7FE8),
    name: 'Camila Torres',
    idType: 'CC',
    idNumber: '110278588',
    status: 'Active',
    date: '19/05/2026',
    phone: '35267894',
    email: 'camilatorrez@gmail.com',
    addresses: [
      AddressModel(
        id: '#2',
        street: 'Calle 10 #45-90 Casa 2',
        city: 'Medellín',
        neighborhood: 'Belén',
        status: 'Activa',
        note: 'Casa color blanco frente al parque',
      ),
      AddressModel(
        id: '#29',
        street: 'Calle 72 #15-30 Oficina 401',
        city: 'Bogotá',
        neighborhood: 'Chapinero',
        status: 'Activa',
        note: 'Edificio azul, piso 4',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'AM',
    avatarColor: const Color(0xFFE85D9E),
    name: 'Andrés Martínez',
    idType: 'CC',
    idNumber: '112233445',
    status: 'Active',
    date: '19/05/2026',
    phone: '3204567890',
    email: 'andresmartinez@yahoo.com',
    addresses: [
      AddressModel(
        id: '#17',
        street: 'Calle 50 #12-40',
        city: 'Bogotá',
        neighborhood: 'Suba',
        status: 'Activa',
        note: 'Casa esquinera',
      ),
      AddressModel(
        id: '#30',
        street: 'Diagonal 25G #95A-55',
        city: 'Bogotá',
        neighborhood: 'Kennedy',
        status: 'Activa',
        note: 'Bloque 4 apartamento 203',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'SR',
    avatarColor: const Color(0xFFF2994A),
    name: 'Sofía Rodríguez',
    idType: 'CE',
    idNumber: '334455987',
    status: 'Active',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3259012346',
    email: 'paula.sanchez@email.com',
    addresses: [],
  ),

  // ---------------- CLIENTES NUEVOS AGREGADOS ----------------
  ClientModel(
    initials: 'CF',
    avatarColor: const Color(0xFF16A085),
    name: 'Carlos Fernández',
    idType: 'Pasaporte',
    idNumber: '445566778',
    status: 'Active',
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
        note: 'Torre 3 apartamento 601.',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#14',
        street: 'Calle 44 #11-89',
        city: 'Cartagena',
        neighborhood: 'Manga',
        status: 'Activa',
        note: 'Recepción principal.',
      ),
    ],
  ),
  ClientModel(
    initials: 'CM',
    avatarColor: const Color(0xFF2F80ED),
    name: 'Cristian Muñoz',
    idType: 'CC',
    idNumber: '1099887766',
    status: 'Active',
    date: '25/06/2026',
    phone: '3226895675',
    email: 'cristianm@gmail.com',
    addresses: [
      AddressModel(
        id: '#31',
        street: 'Calle 10 # 15-20',
        city: 'Bogotá',
        neighborhood: 'Chapinero',
        status: 'Activa',
        note: 'Casa blanca, timbre 1 vez',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#32',
        street: 'Carrera 18 # 45-67',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3104567890',
    email: 'juan.gomez@gmail.com',
    addresses: [
      AddressModel(
        id: '#33',
        street: 'Calle 40 # 20-55',
        city: 'Cúcuta',
        neighborhood: 'Caobos',
        status: 'Activa',
        note: 'Frente al supermercado',
      ),
      AddressModel(
        id: '#34',
        street: 'Carrera 8 # 15-99',
        city: 'Cúcuta',
        neighborhood: 'La Playa',
        status: 'Activa',
        note: 'Timbre rojo',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'MA',
    avatarColor: const Color(0xFF9B51E0),
    name: 'Miguel Ángel Rojas',
    idType: 'NIT',
    idNumber: '205667788',
    status: 'Active',
    date: '25/06/2026',
    phone: '3126789012',
    email: 'miguel.rojas@gmail.com',
    addresses: [
      AddressModel(
        id: '#35',
        street: 'Calle 18 # 7-40',
        city: 'Pereira',
        neighborhood: 'Cuba',
        status: 'Activa',
        note: 'Casa de dos pisos',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#36',
        street: 'Carrera 11 # 24-33',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3137890123',
    email: 'natalia.ramirez@gmail.com',
    addresses: [
      AddressModel(
        id: '#37',
        street: 'Calle 48 # 19-22',
        city: 'Manizales',
        neighborhood: 'Palermo',
        status: 'Activa',
        note: 'Apartamento 503',
      ),
      AddressModel(
        id: '#38',
        street: 'Carrera 30 # 12-18',
        city: 'Manizales',
        neighborhood: 'La Francia',
        status: 'Activa',
        note: 'Casa blanca',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'FT',
    avatarColor: const Color(0xFF56CCF2),
    name: 'Felipe Torres',
    idType: 'CC',
    idNumber: '1122334455',
    status: 'Active',
    date: '25/06/2026',
    phone: '3148901234',
    email: 'felipe.torres@gmail.com',
    addresses: [
      AddressModel(
        id: '#40',
        street: 'Carrera 5 # 38-42',
        city: 'Ibagué',
        neighborhood: 'Piedra Pintada',
        status: 'Activa',
        note: 'Portón café',
      ),
      AddressModel(
        id: '#39',
        street: 'Calle 16 # 14-50',
        city: 'Ibagué',
        neighborhood: 'Cádiz',
        status: 'Activa',
        note: 'Frente al parqueadero',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'MF',
    avatarColor: const Color(0xFFF2C94C),
    name: 'María Fernanda López',
    idType: 'CC',
    idNumber: '1002345678',
    status: 'Active',
    date: '25/06/2026',
    phone: '3159012345',
    email: 'maria.lopez@gmail.com',
    addresses: [
      AddressModel(
        id: '#41',
        street: 'Calle 70 # 90-15',
        city: 'Bogotá',
        neighborhood: 'Suba',
        status: 'Activa',
        note: 'Torre 3, apto 901',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#42',
        street: 'Carrera 92 # 128-44',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3171234567',
    email: 'sara.jimenez@gmail.com',
    addresses: [
      AddressModel(
        id: '#43',
        street: 'Calle 140 # 19-50',
        city: 'Bogotá',
        neighborhood: 'Cedritos',
        status: 'Activa',
        note: 'Casa de fachada amarilla',
      ),
      AddressModel(
        id: '#44',
        street: 'Carrera 7 # 170-22',
        city: 'Bogotá',
        neighborhood: 'Usaquén',
        status: 'Activa',
        note: 'Portería, preguntar apto 504',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'AC',
    avatarColor: const Color(0xFF2D9CDB),
    name: 'Andrés Cárdenas',
    idType: 'Pasaporte',
    idNumber: 'P99887766',
    status: 'Active',
    date: '25/06/2026',
    phone: '3248901235',
    email: 'andres.cardenas@gmail.com',
    addresses: [
      AddressModel(
        id: '#45',
        street: 'Calle 5 # 66-40',
        city: 'Cali',
        neighborhood: 'San Fernando',
        status: 'Activa',
        note: 'Casa de rejas blancas',
      ),
      AddressModel(
        id: '#46',
        street: 'Carrera 80 # 14-56',
        city: 'Cali',
        neighborhood: 'Ciudad Jardín',
        status: 'Activa',
        note: 'Portería principal',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'DH',
    avatarColor: const Color(0xFFF06292),
    name: 'Daniela Herrera',
    idType: 'CC',
    idNumber: '1009876543',
    status: 'Active',
    date: '25/06/2026',
    phone: '3215678902',
    email: 'daniela.herrera@gmail.com',
    addresses: [
      AddressModel(
        id: '#47',
        street: 'Carrera 27 # 61-15',
        city: 'Barranquilla',
        neighborhood: 'Alto Prado',
        status: 'Activa',
        note: 'Torre 2, apto 504',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#48',
        street: 'Carrera 46 # 74-12',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3226789013',
    email: 'alejandro.martinez@gmail.com',
    addresses: [
      AddressModel(
        id: '#49',
        street: 'Calle 30 # 21-45',
        city: 'Cartagena',
        neighborhood: 'Bocagrande',
        status: 'Activa',
        note: 'Recepción del edificio',
        isPrincipal: true,
      ),
      AddressModel(
        id: '#50',
        street: 'Calle 12 # 8-25',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3260123457',
    email: 'nicolas.castro@gmail.com',
    addresses: [],
  ),
  ClientModel(
    initials: 'JM',
    avatarColor: const Color(0xFF2F80ED),
    name: 'Juliana Moreno',
    idType: 'Pasaporte',
    idNumber: 'P66778899',
    status: 'Active',
    date: '25/06/2026',
    phone: '3282345679',
    email: 'juliana.moreno@gmail.com',
    addresses: [],
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class DireccionesClienteScreen extends StatefulWidget {
  // Si embedded = true, no dibuja su propio Scaffold/AppBar (se usa
  // así dentro de main_shell_gerente.dart, que ya provee el único
  // encabezado "BIENVENIDO" compartido por todas las pantallas).
  final bool embedded;

  const DireccionesClienteScreen({super.key, this.embedded = false});

  @override
  State<DireccionesClienteScreen> createState() => _DireccionesClienteScreenState();
}

class _DireccionesClienteScreenState extends State<DireccionesClienteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  // Lista mutable en memoria (para que agregar/editar/eliminar
  // funcione en tiempo real dentro de la pantalla).
  late List<ClientModel> _clients;

  // Contador para generar IDs de direcciones nuevas (sigue después
  // del ID más alto ya usado en los datos de ejemplo, #50).
  int _addressIdCounter = 50;

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
  // ACCIONES (100% funcionales)
  // ============================================================

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        backgroundColor: AppColorsDir.encabezado,
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
      fillColor: AppColorsDir.fondo,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColorsDir.doradoClaro),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColorsDir.dorado, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColorsDir.rojo),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColorsDir.rojo, width: 1.4),
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
      style: const TextStyle(fontSize: 13, color: AppColorsDir.encabezado),
      decoration: _dialogDecoration(label),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null : null,
    );
  }

  // ------------------------------------------------------------
  // Encabezado navy reutilizable para los diálogos de dirección
  // (Agregar / Editar / Eliminar), con ícono circular dorado,
  // título, subtítulo con el nombre del cliente y botón de cerrar.
  // ------------------------------------------------------------
  Widget _dialogHeader({
    required BuildContext dialogContext,
    required IconData icon,
    required String title,
    required String clientName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: const BoxDecoration(
        color: AppColorsDir.navyOscuro,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColorsDir.dorado, width: 1.5),
            ),
            child: Icon(icon, color: AppColorsDir.dorado, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cliente: $clientName',
                  style: const TextStyle(color: AppColorsDir.doradoClaro, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(dialogContext, false),
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

  // Botón "Cancelar" con borde dorado claro, usado en los diálogos
  // de dirección rediseñados.
  Widget _dialogCancelButton(VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsDir.grisTexto,
        side: const BorderSide(color: AppColorsDir.doradoClaro),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.close_rounded, size: 16),
      label: const Text('Cancelar'),
    );
  }

  // Botón dorado principal, usado en los diálogos de dirección
  // rediseñados (Guardar / Eliminar).
  Widget _dialogConfirmButton({required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDir.dorado,
        foregroundColor: AppColorsDir.encabezado,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      icon: const Icon(Icons.check_rounded, size: 16),
      label: Text(label),
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
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColorsDir.dorado, width: 1.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                        decoration: const BoxDecoration(
                          color: AppColorsDir.navyOscuro,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(17),
                            topRight: Radius.circular(17),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColorsDir.dorado, width: 1.5),
                              ),
                              child: const Icon(Icons.manage_accounts_rounded, color: AppColorsDir.dorado, size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Editar cliente',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(ctx, false),
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
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
                                    .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (v) => setDialogState(() => idType = v ?? idType),
                              ),
                              const SizedBox(height: 12),
                              _dialogField(label: 'Número de documento', controller: idNumberCtrl),
                              const SizedBox(height: 12),
                              _dialogField(label: 'Teléfono', controller: phoneCtrl, keyboardType: TextInputType.phone),
                              const SizedBox(height: 12),
                              _dialogField(label: 'Correo electrónico', controller: emailCtrl, keyboardType: TextInputType.emailAddress),
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
                ),
              ),
            );
          },
        );
      },
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
  // Diálogo rediseñado: encabezado navy con ícono circular dorado,
  // nombre del cliente y botón de cierre; cuerpo blanco; borde
  // exterior dorado igual al del botón "Guardar dirección".
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
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColorsDir.dorado, width: 1.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _dialogHeader(
                        dialogContext: ctx,
                        icon: isEditing ? Icons.edit_location_alt_rounded : Icons.add_location_alt_rounded,
                        title: isEditing ? 'Editar dirección' : 'Agregar dirección',
                        clientName: client.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
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
                                      label: 'Barrio',
                                      controller: neighborhoodCtrl,
                                      required: false,
                                    ),
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
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (v) => setDialogState(() => status = v ?? status),
                              ),
                              const SizedBox(height: 2),
                              CheckboxListTile(
                                value: isPrincipal,
                                onChanged: (v) => setDialogState(() => isPrincipal = v ?? false),
                                title: const Text(
                                  'Marcar como dirección principal',
                                  style: TextStyle(fontSize: 12.5, color: AppColorsDir.encabezado),
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
                                      label: isEditing ? 'Guardar cambios' : 'Guardar dirección',
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
            );
          },
        );
      },
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
  // Mismo estilo de encabezado navy + borde dorado que el diálogo
  // de agregar/editar dirección.
  Future<void> _confirmDeleteAddress(ClientModel client, AddressModel address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColorsDir.dorado, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogHeader(
                dialogContext: ctx,
                icon: Icons.delete_outline_rounded,
                title: 'Eliminar dirección',
                clientName: client.name,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Seguro que deseas eliminar la dirección "${address.street}"? Esta acción no se puede deshacer.',
                      style: const TextStyle(fontSize: 13, color: AppColorsDir.grisTexto, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: _dialogCancelButton(() => Navigator.pop(ctx, false))),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dialogConfirmButton(
                            label: 'Eliminar',
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
      ),
    );

    if (confirmed == true) {
      setState(() => client.addresses.remove(address));
      _showSnack('Dirección eliminada');
    }
  }

  // -------- Actualizar --------
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _buildTituloYAcciones(),
        const SizedBox(height: 16),
        _buildStatsRow(),
        const SizedBox(height: 16),
        _buildSearchBar(),
        const SizedBox(height: 16),
        Text(
          'Clientes (${_filteredClients.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColorsDir.encabezado,
          ),
        ),
        const SizedBox(height: 12),
        ..._filteredClients.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClientCard(
                client: c,
                onAddAddress: () => _showAddressDialog(c),
                onEditAddress: (a) => _showAddressDialog(c, existing: a),
                onDeleteAddress: (a) => _confirmDeleteAddress(c, a),
                onEditClient: () => _showEditClientDialog(c),
                onActualizar: () => _actualizarCliente(c),
              ),
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
      backgroundColor: AppColorsDir.fondo,
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  // ------------------------------------------------------------
  // ÚNICO ENCABEZADO (mismo estilo T4D que Movimientos). Solo se
  // dibuja cuando la pantalla NO está embebida, para que no se
  // repita junto con el header del shell principal.
  // ------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColorsDir.encabezado,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: () {},
      ),
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColorsDir.dorado, width: 1.5),
              color: AppColorsDir.encabezado,
            ),
            child: const Center(
              child: Text(
                'T4D',
                style: TextStyle(
                  color: AppColorsDir.dorado,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BIENVENIDO',
                style: TextStyle(
                  color: AppColorsDir.doradoClaro,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Direcciones Cliente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CUADRO "Direcciones del cliente" — recuadro navy con borde
  // dorado, título, subtítulo, estrellas y botones.
  // ------------------------------------------------------------
  Widget _buildTituloYAcciones() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorsDir.navyOscuro,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColorsDir.dorado, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Direcciones del cliente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColorsDir.doradoClaro,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gestión y administración de direcciones registradas por los clientes',
            style: TextStyle(fontSize: 12.5, color: AppColorsDir.subtitulo, height: 1.35),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.star_rounded, size: 16, color: AppColorsDir.dorado),
              Icon(Icons.star_rounded, size: 16, color: AppColorsDir.dorado),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _GoldButton(
                  icon: Icons.add_location_alt_rounded,
                  label: 'Agregar dirección',
                  onTap: () {
                    if (_clients.isNotEmpty) {
                      _showAddressDialog(_clients.first);
                    }
                  },
                  expand: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActualizarButtonOscuro(onTap: _actualizarTodos),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TARJETAS DE ESTADÍSTICAS (borde dorado)
  // ------------------------------------------------------------
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.groups_rounded,
            value: '$_totalClientes',
            label: 'Total clientes',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.location_on_rounded,
            value: '$_totalDirecciones',
            label: 'Total direcciones',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            value: '$_totalPrincipales',
            label: 'Direcciones\nprincipales',
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BUSCADOR (borde dorado, mismo estilo que Movimientos)
  // ------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColorsDir.dorado, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.manage_search_rounded, color: AppColorsDir.dorado, size: 18),
              SizedBox(width: 6),
              Text(
                'Buscar cliente',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColorsDir.encabezado),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o documento...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColorsDir.grisTexto),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColorsDir.grisTexto),
              filled: true,
              fillColor: AppColorsDir.fondo,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColorsDir.doradoClaro),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColorsDir.dorado),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColorsDir.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColorsDir.doradoOscuro.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColorsDir.encabezado, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColorsDir.encabezado),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: AppColorsDir.grisTexto, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColorsDir.doradoClaro),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: AppColorsDir.encabezado),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: AppColorsDir.encabezado, fontWeight: FontWeight.w600, fontSize: 11.5),
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

// Botón de borde blanco para usar SOLO dentro del recuadro navy nuevo,
// así el _OutlineButton original (usado en "Editar cliente") no cambia.
class _ActualizarButtonOscuro extends StatelessWidget {
  final VoidCallback onTap;

  const _ActualizarButtonOscuro({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Actualizar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool expand;

  const _GoldButton({required this.icon, required this.label, required this.onTap, this.expand = false});

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColorsDir.dorado,
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
              Icon(icon, size: 14, color: AppColorsDir.encabezado),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: AppColorsDir.encabezado, fontWeight: FontWeight.w700, fontSize: 11.5),
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

// ------------------------------------------------------------
// BADGE — el texto va dentro de un FittedBox (BoxFit.scaleDown)
// para que, si el espacio disponible es más angosto que el texto,
// se achique en vez de desbordarse (evita el error de Flutter de
// franjas amarillas/negras + texto rojo de overflow).
// ------------------------------------------------------------
class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(color: fg, fontSize: 10.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ==================== TARJETA DE CLIENTE (borde dorado) ====================
class ClientCard extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onAddAddress;
  final VoidCallback onEditClient;
  final VoidCallback onActualizar;
  final void Function(AddressModel address) onEditAddress;
  final void Function(AddressModel address) onDeleteAddress;

  const ClientCard({
    super.key,
    required this.client,
    required this.onAddAddress,
    required this.onEditClient,
    required this.onActualizar,
    required this.onEditAddress,
    required this.onDeleteAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColorsDir.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColorsDir.doradoOscuro.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: client.avatarColor,
                  child: Text(
                    client.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColorsDir.encabezado),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${client.idType} — ${client.idNumber}',
                        style: const TextStyle(fontSize: 11.5, color: AppColorsDir.grisTexto),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        _Badge(text: '• ${client.status}', bg: AppColorsDir.verdeFondo, fg: AppColorsDir.verde),
                        const SizedBox(width: 6),
                        _Badge(
                          text: '${client.dirCount} dir.',
                          bg: AppColorsDir.doradoClaro.withOpacity(0.4),
                          fg: AppColorsDir.doradoOscuro,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.event_rounded, size: 11, color: AppColorsDir.grisTexto),
                        const SizedBox(width: 3),
                        Text(client.date, style: const TextStyle(fontSize: 10.5, color: AppColorsDir.grisTexto)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.call_rounded, size: 13, color: AppColorsDir.grisTexto),
                    const SizedBox(width: 4),
                    Text(client.phone, style: const TextStyle(fontSize: 12, color: AppColorsDir.encabezado)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mail_outline_rounded, size: 13, color: AppColorsDir.grisTexto),
                    const SizedBox(width: 4),
                    Text(client.email, style: const TextStyle(fontSize: 12, color: AppColorsDir.encabezado)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (client.addresses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Center(
                child: Text(
                  'Sin direcciones registradas',
                  style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: AppColorsDir.grisTexto),
                ),
              ),
            )
          else
            _AddressTable(
              addresses: client.addresses,
              onEdit: onEditAddress,
              onDelete: onDeleteAddress,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: _GoldButton(
                    icon: Icons.add_location_alt_rounded,
                    label: 'Agregar dirección',
                    onTap: onAddAddress,
                    expand: true,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _OutlineButton(
                    icon: Icons.manage_accounts_rounded,
                    label: 'Editar cliente',
                    onTap: onEditClient,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _OutlineButton(
                    icon: Icons.refresh_rounded,
                    label: 'Actualizar',
                    onTap: onActualizar,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TABLA DE DIRECCIONES ====================
// Ancho total fijo de la tabla. En pantallas angostas, el usuario puede
// deslizar el dedo hacia los lados para ver todas las columnas, en vez
// de que el ID y la Dirección se corten y solo se vea Barrio/Est/Acc.
const double _tableWidth = 468;
const double _colId = 40;
const double _colDireccion = 190;
const double _colBarrio = 100;
const double _colEstado = 70;
const double _colAcciones = 48;

class _AddressTable extends StatelessWidget {
  final List<AddressModel> addresses;
  final void Function(AddressModel address) onEdit;
  final void Function(AddressModel address) onDelete;

  const _AddressTable({required this.addresses, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: _tableWidth,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColorsDir.encabezado,
                border: Border(
                  top: BorderSide(color: AppColorsDir.dorado, width: 1),
                  bottom: BorderSide(color: AppColorsDir.dorado, width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: const Row(
                children: [
                  SizedBox(width: _colId, child: Text('ID', style: _headerStyle)),
                  SizedBox(width: _colDireccion, child: Text('Dirección / Ciudad', style: _headerStyle)),
                  SizedBox(width: _colBarrio, child: Text('Barrio', style: _headerStyle)),
                  SizedBox(width: _colEstado, child: Text('Est.', style: _headerStyle)),
                  SizedBox(width: _colAcciones, child: Text('Acc.', style: _headerStyle)),
                ],
              ),
            ),
            ...addresses.map((a) => _AddressRow(
                  address: a,
                  onEdit: () => onEdit(a),
                  onDelete: () => onDelete(a),
                )),
          ],
        ),
      ),
    );
  }
}

const TextStyle _headerStyle = TextStyle(color: AppColorsDir.doradoClaro, fontSize: 10.5, fontWeight: FontWeight.bold);

class _AddressRow extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressRow({required this.address, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColorsDir.doradoClaro.withOpacity(0.5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _colId,
            child: Text(
              address.id,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColorsDir.encabezado),
            ),
          ),
          SizedBox(
            width: _colDireccion,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.street, style: const TextStyle(fontSize: 12, color: AppColorsDir.encabezado)),
                  Text(address.city, style: const TextStyle(fontSize: 11, color: AppColorsDir.grisTexto)),
                  Text(
                    address.note,
                    style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: AppColorsDir.grisTexto),
                  ),
                  if (address.isPrincipal)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.star_rounded, size: 11, color: AppColorsDir.dorado),
                          SizedBox(width: 2),
                          Text(
                            'Principal',
                            style: TextStyle(fontSize: 10.5, color: AppColorsDir.doradoOscuro, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: _colBarrio,
            child: Text(address.neighborhood, style: const TextStyle(fontSize: 12, color: AppColorsDir.encabezado)),
          ),
          SizedBox(
            width: _colEstado,
            child: _Badge(
              text: address.status,
              bg: AppColorsDir.doradoClaro.withOpacity(0.4),
              fg: AppColorsDir.doradoOscuro,
            ),
          ),
          SizedBox(
            width: _colAcciones,
            child: Row(
              children: [
                InkWell(
                  onTap: onEdit,
                  child: const Icon(Icons.edit_rounded, size: 15, color: AppColorsDir.grisTexto),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline_rounded, size: 15, color: AppColorsDir.rojo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}