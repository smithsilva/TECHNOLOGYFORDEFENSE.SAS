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
  // dorado, título, subtítulo, estrellas y botones. (ÚNICO CAMBIO
  // solicitado: se agregó este recuadro tal como en la imagen)
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
                  onTap: () {},
                  expand: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActualizarButtonOscuro(onTap: () {}),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColorsDir.doradoClaro),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: AppColorsDir.encabezado),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: AppColorsDir.encabezado, fontWeight: FontWeight.w600, fontSize: 12),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: AppColorsDir.encabezado),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(color: AppColorsDir.encabezado, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
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

// ==================== TARJETA DE CLIENTE (borde dorado) ====================
class ClientCard extends StatelessWidget {
  final ClientModel client;

  const ClientCard({super.key, required this.client});

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
            _AddressTable(addresses: client.addresses),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: _GoldButton(icon: Icons.add_location_alt_rounded, label: 'Agregar dirección', onTap: () {}, expand: true),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OutlineButton(icon: Icons.manage_accounts_rounded, label: 'Editar cliente', onTap: () {}),
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
const double _tableWidth = 460;
const double _colId = 40;
const double _colDireccion = 190;
const double _colBarrio = 110;
const double _colEstado = 56;
const double _colAcciones = 48;

class _AddressTable extends StatelessWidget {
  final List<AddressModel> addresses;

  const _AddressTable({required this.addresses});

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
            ...addresses.map((a) => _AddressRow(address: a)),
          ],
        ),
      ),
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
                  onTap: () {},
                  child: const Icon(Icons.edit_rounded, size: 15, color: AppColorsDir.grisTexto),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {},
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