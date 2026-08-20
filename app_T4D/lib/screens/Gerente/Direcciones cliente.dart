import 'package:flutter/material.dart';

// ==================================================================
// DIRECCIONES CLIENTE - Pantalla completa lista para copiar y pegar
// ==================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direcciones Cliente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const DireccionesClienteScreen(),
    );
  }
}

// ==================== PALETA DE COLORES ====================
// Paleta dorado/marfil de la vista de Gerente.
class AppColors {
  static const Color background = Color(0xFFF7F1E3); // FONDO
  static const Color navy = Color(0xFF13202E); // ENCABEZADO (unificado con el resto de pantallas)
  static const Color navyDark = Color(0xFF0B141C);

  static const Color gold = Color(0xFFD4A743); // DORADO
  static const Color goldDark = Color(0xFF8C6B3F); // DORADO_OSCURO
  static const Color goldLight = Color(0xFFE7C98A); // DORADO_CLARO / TEXTO_ENC

  static const Color green = Color(0xFF34C471);
  static const Color greenBg = Color(0xFFE3F9EC);
  static const Color amber = Color(0xFFF2B33D);
  static const Color amberBg = Color(0xFFFCF0D6);

  static const Color red = Color(0xFFE85454);

  static const Color textDark = Color(0xFF20213B);
  static const Color textGrey = Color(0xFF8A8CA5);
  static const Color cardShadow = Color(0x14000000);
}

// ==================== MODELOS ====================
class AddressModel {
  final String id;
  final String street;
  final String city;
  final String neighborhood;
  final String status;
  final String note;
  final bool isPrincipal;

  const AddressModel({
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
  final String initials;
  final Color avatarColor;
  final String name;
  final String idType;
  final String idNumber;
  final String status;
  final String date;
  final String phone;
  final String email;
  final List<AddressModel> addresses;

  const ClientModel({
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
    addresses: const [
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
    addresses: const [
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
    addresses: const [
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
    initials: 'CF',
    avatarColor: const Color(0xFF27AE60),
    name: 'Carlos Fernández',
    idType: 'Pasaporte',
    idNumber: '445566778',
    status: 'Activo',
    date: '19/05/2026',
    phone: '3012345678',
    email: 'carlosfernandez@hotmail.com',
    addresses: const [
      AddressModel(
        id: '#13',
        street: 'Avenida 45 #80-12',
        city: 'Cali',
        neighborhood: 'Granada',
        status: 'Activa',
        note: 'Torre 3 apartamento 801',
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
    status: 'Active',
    date: '26/05/2026',
    phone: '3226895675',
    email: 'cristianm@gmail.com',
    addresses: const [
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
    status: 'Active',
    date: '26/05/2026',
    phone: '3104567890',
    email: 'juan.gomez@email.com',
    addresses: const [
      AddressModel(
        id: '#33',
        street: 'Calle 40 #20-55',
        city: 'Cúcuta',
        neighborhood: 'Caobos',
        status: 'Activa',
        note: 'Frente al supermercado',
      ),
      AddressModel(
        id: '#34',
        street: 'Carrera 8 #15-99',
        city: 'Cúcuta',
        neighborhood: 'La Playa',
        status: 'Activa',
        note: 'Timbre rojo',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'MÁ',
    avatarColor: const Color(0xFF17A398),
    name: 'Miguel Ángel Rojas',
    idType: 'NIT',
    idNumber: '205667788',
    status: 'Active',
    date: '26/05/2026',
    phone: '3126789012',
    email: 'miguel.rojas@email.com',
    addresses: const [
      AddressModel(
        id: '#35',
        street: 'Calle 18 #7-40',
        city: 'Pereira',
        neighborhood: 'Cuba',
        status: 'Activa',
        note: 'Casa de dos pisos',
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
    phone: '3137930123',
    email: 'natalia.ramirez@email.com',
    addresses: const [
      AddressModel(
        id: '#37',
        street: 'Calle 48 #19-22',
        city: 'Manizales',
        neighborhood: 'Palermo',
        status: 'Activa',
        note: 'Torre 5 apto 503',
      ),
      AddressModel(
        id: '#38',
        street: 'Carrera 30 #12-18',
        city: 'Manizales',
        neighborhood: 'La Francia',
        status: 'Activa',
        note: 'Casa blanco',
        isPrincipal: true,
      ),
    ],
  ),
  ClientModel(
    initials: 'FT',
    avatarColor: const Color(0xFF8B7FE8),
    name: 'Felipe Torres',
    idType: 'CC',
    idNumber: '1022334455',
    status: 'Active',
    date: '25/06/2026',
    phone: '3148901234',
    email: 'felipe.torres@email.com',
    addresses: const [
      AddressModel(
        id: '#40',
        street: 'Carrera 5 #38-42',
        city: 'Ibagué',
        neighborhood: 'Piedra Pintada',
        status: 'Activa',
        note: 'Patio café',
      ),
      AddressModel(
        id: '#39',
        street: 'Calle 16 #14-50',
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
    avatarColor: const Color(0xFF27AE60),
    name: 'María Fernanda López',
    idType: 'CC',
    idNumber: '1002345678',
    status: 'Active',
    date: '25/06/2026',
    phone: '3159012345',
    email: 'maria.lopez@email.com',
    addresses: const [
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
    avatarColor: const Color(0xFF8B7FE8),
    name: 'Sara Jiménez',
    idType: 'CE',
    idNumber: '105566778',
    status: 'Active',
    date: '25/06/2026',
    phone: '3173234567',
    email: 'sara.jimenez@email.com',
    addresses: const [
      AddressModel(
        id: '#43',
        street: 'Calle 140 #19-60',
        city: 'Bogotá',
        neighborhood: 'Cedritos',
        status: 'Activa',
        note: 'Casa de fachada amarilla',
      ),
      AddressModel(
        id: '#44',
        street: 'Carrera 7 #170-22',
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
    avatarColor: const Color(0xFF2F80ED),
    name: 'Andrés Cárdenas',
    idType: 'Pasaporte',
    idNumber: 'P93887766',
    status: 'Active',
    date: '25/06/2026',
    phone: '3248001235',
    email: 'andres.cardenas@email.com',
    addresses: const [
      AddressModel(
        id: '#45',
        street: 'Calle 5 #66-40',
        city: 'Cali',
        neighborhood: 'San Fernando',
        status: 'Activa',
        note: 'Casa de rejas blancas',
      ),
      AddressModel(
        id: '#46',
        street: 'Carrera 80 #14-56',
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
    avatarColor: const Color(0xFFE85D9E),
    name: 'Daniela Herrera',
    idType: 'CC',
    idNumber: '1009876543',
    status: 'Active',
    date: '25/06/2026',
    phone: '3215678902',
    email: 'daniela.herrera@email.com',
    addresses: const [
      AddressModel(
        id: '#47',
        street: 'Carrera 27 #61-15',
        city: 'Barranquilla',
        neighborhood: 'Alto Prado',
        status: 'Activa',
        note: 'Torre 2, apto 604',
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
    status: 'Active',
    date: '25/06/2026',
    phone: '3226780103',
    email: 'alejandro.martinez@email.com',
    addresses: const [
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
    initials: 'PS',
    avatarColor: const Color(0xFF8B7FE8),
    name: 'Paula Sánchez',
    idType: 'CC',
    idNumber: '1033445566',
    status: 'Active',
    date: '25/06/2026',
    phone: '3259012346',
    email: 'paula.sanchez@email.com',
    addresses: const [],
  ),
  ClientModel(
    initials: 'NC',
    avatarColor: const Color(0xFF27AE60),
    name: 'Nicolás Castro',
    idType: 'CE',
    idNumber: '201234567',
    status: 'Active',
    date: '25/06/2026',
    phone: '3260123457',
    email: 'nicolas.castro@email.com',
    addresses: const [],
  ),
  ClientModel(
    initials: 'JM',
    avatarColor: const Color(0xFF2F80ED),
    name: 'Juliana Moreno',
    idType: 'Pasaporte',
    idNumber: 'P66778899',
    status: 'Activa',
    date: '25/06/2026',
    phone: '3282345678',
    email: 'juliana.moreno@email.com',
    addresses: const [],
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class DireccionesClienteScreen extends StatefulWidget {
  // Si embedded = true, no dibuja su propio Scaffold/AppBar (se usa
  // así dentro de main_shell_gerente.dart, que ya los provee), igual
  // que las demás pantallas de Gerente (Tareas, Clientes, etc.).
  final bool embedded;

  const DireccionesClienteScreen({super.key, this.embedded = false});

  @override
  State<DireccionesClienteScreen> createState() => _DireccionesClienteScreenState();
}

class _DireccionesClienteScreenState extends State<DireccionesClienteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<ClientModel> get _filteredClients {
    if (_query.trim().isEmpty) return clientsData;
    final q = _query.toLowerCase();
    return clientsData.where((c) {
      return c.name.toLowerCase().contains(q) || c.idNumber.toLowerCase().contains(q);
    }).toList();
  }

  int get _totalClientes => clientsData.length;
  int get _totalDirecciones => clientsData.fold(0, (sum, c) => sum + c.dirCount);
  int get _totalPrincipales =>
      clientsData.fold(0, (sum, c) => sum + c.addresses.where((a) => a.isPrincipal).length);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 14),
        _buildSearchBar(),
        const SizedBox(height: 14),
        _buildStatsRow(),
        const SizedBox(height: 14),
        ..._filteredClients.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ClientCard(client: c),
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
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(color: AppColors.navy),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.badge, color: AppColors.navy, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BIENVENIDO',
                        style: TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Text(
                        'Direcciones Cliente',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () {},
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.gold,
                        child: Icon(Icons.person, size: 12, color: AppColors.navy),
                      ),
                      SizedBox(width: 6),
                      Text('Gerente', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Direcciones del cliente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ),
              _GoldButton(icon: Icons.add, label: 'Agregar dirección', onTap: () {}),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Gestión y administración de direcciones registradas por los clientes',
            style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: const InputDecoration(
          hintText: 'Buscar por nombre o documento...',
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13.5),
          prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(icon: Icons.people_alt_rounded, value: '$_totalClientes', label: 'Total clientes'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(icon: Icons.location_on, value: '$_totalDirecciones', label: 'Total direcciones'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
              icon: Icons.star, value: '$_totalPrincipales', label: 'Direcciones\nprincipales'),
        ),
      ],
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
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.navy, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey, height: 1.2),
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
  final bool expand;

  const _GoldButton({required this.icon, required this.label, required this.onTap, this.expand = false});

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColors.gold,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: AppColors.navy),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0EA)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: AppColors.textDark),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      child: Text(text, style: TextStyle(color: fg, fontSize: 10.5, fontWeight: FontWeight.w700)),
    );
  }
}

// ==================== TARJETA DE CLIENTE ====================
class ClientCard extends StatelessWidget {
  final ClientModel client;

  const ClientCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
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
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${client.idType} — ${client.idNumber}',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        _Badge(text: '• ${client.status}', bg: AppColors.greenBg, fg: AppColors.green),
                        const SizedBox(width: 6),
                        _Badge(text: '${client.dirCount} dir.', bg: AppColors.amberBg, fg: AppColors.amber),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 11, color: AppColors.textGrey),
                        const SizedBox(width: 3),
                        Text(client.date, style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey)),
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
                    const Icon(Icons.phone, size: 13, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(client.phone, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email_outlined, size: 13, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(client.email, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
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
                  style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: AppColors.textGrey),
                ),
              ),
            )
          else
            _AddressTable(addresses: client.addresses),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: _GoldButton(icon: Icons.add, label: 'Agregar dirección', onTap: () {}, expand: true),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OutlineButton(icon: Icons.arrow_back, label: 'Editar cliente', onTap: () {}),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OutlineButton(icon: Icons.sync, label: 'Actualizar', onTap: () {}),
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
class _AddressTable extends StatelessWidget {
  final List<AddressModel> addresses;

  const _AddressTable({required this.addresses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.navy,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: const Row(
            children: [
              SizedBox(width: 30, child: Text('ID', style: _headerStyle)),
              Expanded(flex: 3, child: Text('Dirección / Ciudad', style: _headerStyle)),
              Expanded(flex: 2, child: Text('Barrio', style: _headerStyle)),
              SizedBox(width: 46, child: Text('Est.', style: _headerStyle)),
              SizedBox(width: 44, child: Text('Acc.', style: _headerStyle)),
            ],
          ),
        ),
        ...addresses.map((a) => _AddressRow(address: a)),
      ],
    );
  }
}

const TextStyle _headerStyle = TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold);

class _AddressRow extends StatelessWidget {
  final AddressModel address;

  const _AddressRow({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEFEFF5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              address.id,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.street, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                Text(address.city, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                Text(
                  address.note,
                  style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: AppColors.textGrey),
                ),
                if (address.isPrincipal)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, size: 11, color: AppColors.gold),
                        SizedBox(width: 2),
                        Text(
                          'Principal',
                          style: TextStyle(fontSize: 10.5, color: AppColors.goldDark, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(address.neighborhood, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
          ),
          SizedBox(
            width: 46,
            child: _Badge(text: address.status, bg: AppColors.amberBg, fg: AppColors.amber),
          ),
          SizedBox(
            width: 44,
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(Icons.edit, size: 15, color: AppColors.textGrey),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {},
                  child: const Icon(Icons.delete, size: 15, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}