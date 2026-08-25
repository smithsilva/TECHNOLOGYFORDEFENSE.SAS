import 'package:flutter/material.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const background = Color(0xFFF1EEE6);
  static const navy = Color(0xFF13161F);
  static const gold = Color(0xFFE0A93B);
  static const goldDark = Color(0xFFC8901E);
  static const red = Color(0xFFE85454);
  static const blue = Color(0xFF2F80ED);
  static const purple = Color(0xFF8B7FE8);
  static const textDark = Color(0xFF1C1E2A);
  static const textGrey = Color(0xFF8C8FA0);
  static const barTrack = Color(0xFFF1F1F5);
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
class MovimientoTipoModel {
  final String nombre;
  final int cantidad;
  final double proporcion; // 0.0 - 1.0, relativo al máximo

  const MovimientoTipoModel({
    required this.nombre,
    required this.cantidad,
    required this.proporcion,
  });
}

const int totalMovimientos = 15;
const String totalEgresos = '\$12.683.998';
const int totalProveedores = 3;
const int totalSucursales = 8;

final List<MovimientoTipoModel> movimientosPorTipoData = [
  const MovimientoTipoModel(nombre: 'Mantenimiento', cantidad: 10, proporcion: 1.0),
  const MovimientoTipoModel(nombre: 'Reparación', cantidad: 4, proporcion: 0.4),
  const MovimientoTipoModel(nombre: 'Blindamiento', cantidad: 1, proporcion: 0.1),
];

// ==================== PANTALLA PRINCIPAL ====================
class ReportesFinancierosScreen extends StatelessWidget {
  const ReportesFinancierosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 14),
          _buildStatsGrid(),
          const SizedBox(height: 14),
          _buildMovimientosCard(),
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
            'Reportes Financieros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 26, height: 2.4, color: AppColors.textGrey),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 10, color: AppColors.gold),
              const SizedBox(width: 4),
              Container(width: 26, height: 2.4, color: AppColors.textGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Movimientos',
                value: '$totalMovimientos',
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Total Egresos',
                value: totalEgresos,
                color: AppColors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Proveedores',
                value: '$totalProveedores',
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Sucursales',
                value: '$totalSucursales',
                color: AppColors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMovimientosCard() {
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
            'Movimientos por tipo',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          ...movimientosPorTipoData.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _MovimientoBar(movimiento: m),
              )),
        ],
      ),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class _MovimientoBar extends StatelessWidget {
  final MovimientoTipoModel movimiento;

  const _MovimientoBar({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              movimiento.nombre,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.goldDark,
              ),
            ),
            Text(
              '${movimiento.cantidad}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    width: constraints.maxWidth,
                    color: AppColors.barTrack,
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * movimiento.proporcion,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.gold, AppColors.goldDark],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}