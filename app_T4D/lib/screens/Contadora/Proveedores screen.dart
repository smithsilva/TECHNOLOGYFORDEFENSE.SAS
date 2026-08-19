import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proveedores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const ProveedoresScreen(),
    );
  }
}

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const background = Color(0xFFF1EEE6);
  static const navy = Color(0xFF13161F);
  static const gold = Color(0xFFE0A93B);
  static const goldDark = Color(0xFFC8901E);
  static const green = Color(0xFF33B76A);
  static const greenBg = Color(0xFFE3F7EA);
  static const textDark = Color(0xFF1C1E2A);
  static const textGrey = Color(0xFF8C8FA0);
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
class ProveedorModel {
  final String nombre;
  final String nit;
  final String estado;
  final String contacto;
  final String telefono;
  final String correo;
  final String ciudad;

  const ProveedorModel({
    required this.nombre,
    required this.nit,
    required this.estado,
    required this.contacto,
    required this.telefono,
    required this.correo,
    required this.ciudad,
  });
}

final List<ProveedorModel> proveedoresData = [
  const ProveedorModel(
    nombre: 'Ferretería Industrial SAS',
    nit: '900100016',
    estado: 'Activo',
    contacto: 'Luis Mora',
    telefono: '601 234 5678',
    correo: 'ferreteria@industrialsas.com',
    ciudad: 'Bogotá',
  ),
  const ProveedorModel(
    nombre: 'Distribuidora La Costa EU',
    nit: '900854987-0',
    estado: 'Activo',
    contacto: 'Ana Pacheco',
    telefono: '575 456 7890',
    correo: 'distribuidora@lacosta.eu',
    ciudad: 'Barranquilla',
  ),
  const ProveedorModel(
    nombre: 'Comercializadora Andina CA',
    nit: '100247500-2',
    estado: 'Activo',
    contacto: 'Pedro Rojas',
    telefono: '604 678 9012',
    correo: 'comercializadora@andina.co',
    ciudad: 'Medellín',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class ProveedoresScreen extends StatelessWidget {
  const ProveedoresScreen({super.key});

  int get _total => proveedoresData.length;
  int get _activos => proveedoresData.where((p) => p.estado == 'Activo').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _PanelContadoraAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 14),
          _buildStatsRow(),
          const SizedBox(height: 14),
          ...proveedoresData.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProveedorCard(proveedor: p),
              )),
        ],
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
          const Text(
            'Proveedores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 26, height: 2.4, color: AppColors.gold),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 10, color: AppColors.gold),
              const SizedBox(width: 4),
              Container(width: 26, height: 2.4, color: AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _StatCard(label: 'Total Proveedores', value: '$_total')),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(label: 'Activos', value: '$_activos', valueColor: AppColors.green)),
      ],
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
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
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.goldDark, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProveedorCard extends StatelessWidget {
  final ProveedorModel proveedor;

  const _ProveedorCard({required this.proveedor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
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
                    Text(
                      proveedor.nombre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIT: ${proveedor.nit}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              _EstadoBadge(estado: proveedor.estado),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'Contacto', value: proveedor.contacto),
          _InfoRow(label: 'Teléfono', value: proveedor.telefono),
          _InfoRow(label: 'Correo', value: proveedor.correo),
          _InfoRow(label: 'Ciudad', value: proveedor.ciudad),
        ],
      ),
    );
  }
}

// ==================== APPBAR COMPARTIDA ====================
class _PanelContadoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PanelContadoraAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
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
                        color: AppColors.gold,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      'Panel de Contadora',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Usuario', style: TextStyle(color: Colors.white, fontSize: 11, height: 1)),
                        Text('Contadora', style: TextStyle(color: AppColors.gold, fontSize: 9, height: 1)),
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
  }
}