import 'package:flutter/material.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const background = Color(0xFFF1EEE6);
  static const navy = Color(0xFF13161F);
  static const gold = Color(0xFFE0A93B);
  static const goldDark = Color(0xFFC8901E);
  static const green = Color(0xFF33B76A);
  static const greenBg = Color(0xFFE3F7EA);
  static const red = Color(0xFFE85494);
  static const redBg = Color(0xFFFCE7F1);
  static const textDark = Color(0xFF1C1E2A);
  static const textGrey = Color(0xFF8C8FA0);
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
class SucursalModel {
  final String nombre;
  final String codigo;
  final String estado;
  final String ciudad;
  final String direccion;
  final String telefono;
  final String encargado;

  const SucursalModel({
    required this.nombre,
    required this.codigo,
    required this.estado,
    required this.ciudad,
    required this.direccion,
    required this.telefono,
    required this.encargado,
  });
}

final List<SucursalModel> sucursalesData = [
  const SucursalModel(
    nombre: 'Sucursal Norte',
    codigo: 'SUC-001',
    estado: 'Activa',
    ciudad: 'Bogotá',
    direccion: 'Calle 100 #15-20',
    telefono: '601 111 2222',
    encargado: 'Carlos R.',
  ),
  const SucursalModel(
    nombre: 'Sucursal Sur',
    codigo: 'SUC-002',
    estado: 'Activa',
    ciudad: 'Bogotá',
    direccion: 'Cra 50 #80-10',
    telefono: '601 333 4444',
    encargado: 'María P.',
  ),
  const SucursalModel(
    nombre: 'Sucursal Centro',
    codigo: 'SUC-003',
    estado: 'Activa',
    ciudad: 'Bogotá',
    direccion: 'Av 19 #30-45',
    telefono: '601 555 6666',
    encargado: 'Juan S.',
  ),
  const SucursalModel(
    nombre: 'Sucursal Principal',
    codigo: 'SUC-004',
    estado: 'Activa',
    ciudad: 'Bogotá',
    direccion: 'Av El Dorado #59-70',
    telefono: '601 777 8888',
    encargado: 'Director',
  ),
  const SucursalModel(
    nombre: 'Sucursal Medellín',
    codigo: 'SUC-005',
    estado: 'Activa',
    ciudad: 'Medellín',
    direccion: 'Cra 43A #1-50',
    telefono: '604 222 3333',
    encargado: 'Pedro A.',
  ),
  const SucursalModel(
    nombre: 'Sucursal Cali',
    codigo: 'SUC-006',
    estado: 'Activa',
    ciudad: 'Cali',
    direccion: 'Calle 5 #39-45',
    telefono: '602 444 5555',
    encargado: 'Laura M.',
  ),
  const SucursalModel(
    nombre: 'Sucursal Cúcuta',
    codigo: 'SUC-007',
    estado: 'Activa',
    ciudad: 'Cúcuta',
    direccion: 'Av 0 #10-85',
    telefono: '607 666 7777',
    encargado: 'Miguel T.',
  ),
  const SucursalModel(
    nombre: 'Sucursal Pasto',
    codigo: 'SUC-008',
    estado: 'Inactiva',
    ciudad: 'Pasto',
    direccion: 'Calle 20 #30-50',
    telefono: '602 888 9999',
    encargado: 'Sofía L.',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class SucursalesScreen extends StatelessWidget {
  const SucursalesScreen({super.key});

  int get _total => sucursalesData.length;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 14),
          ...sucursalesData.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SucursalCard(sucursal: s),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sucursales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(width: 22, height: 2.4, color: AppColors.gold),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 9, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Container(width: 22, height: 2.4, color: AppColors.gold),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
              Text(
                '$_total',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
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
    final bool activa = estado.toLowerCase() == 'activa';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activa ? AppColors.greenBg : AppColors.redBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: activa ? AppColors.green : AppColors.red,
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

class _SucursalCard extends StatelessWidget {
  final SucursalModel sucursal;

  const _SucursalCard({required this.sucursal});

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
                      sucursal.nombre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sucursal.codigo,
                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              _EstadoBadge(estado: sucursal.estado),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'Ciudad', value: sucursal.ciudad),
          _InfoRow(label: 'Dirección', value: sucursal.direccion),
          _InfoRow(label: 'Teléfono', value: sucursal.telefono),
          _InfoRow(label: 'Encargado', value: sucursal.encargado),
        ],
      ),
    );
  }
}