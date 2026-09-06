import 'package:flutter/material.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
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

  // Púrpura: no viene en la paleta enviada, se conserva para
  // diferenciar "Reparación" y "Sucursales", igual que en tus capturas.
  static const purpura = Color(0xFF8B7FE8);

  // Alias usados en esta pantalla
  static const background = fondo;
  static const navy = navyOscuro;
  static const gold = dorado;
  static const goldDark = doradoOscuro;
  static const textDark = Color(0xFF111827);
  static const textGrey = textoMuted;
  static const white = Colors.white;
  static const cardBorder = Color(0xFFEFEFF2);
  static const cardShadow = Color(0x14000000);
  static const barTrack = Color(0xFFF1F1F5);
}

// ==================== MODELO ====================
class MovimientoTipoModel {
  final String nombre;
  final int cantidad;
  final double proporcion; // 0.0 - 1.0, relativo al máximo
  final Color colorInicio;
  final Color colorFin;

  const MovimientoTipoModel({
    required this.nombre,
    required this.cantidad,
    required this.proporcion,
    required this.colorInicio,
    required this.colorFin,
  });
}

const int totalMovimientos = 15;
const String totalEgresos = '\$12.683.998';
const int totalProveedores = 3;
const int totalSucursales = 8;

final List<MovimientoTipoModel> movimientosPorTipoData = [
  const MovimientoTipoModel(
    nombre: 'Mantenimiento',
    cantidad: 10,
    proporcion: 1.0,
    colorInicio: AppColors.enlace,
    colorFin: AppColors.enlace,
  ),
  const MovimientoTipoModel(
    nombre: 'Reparación',
    cantidad: 4,
    proporcion: 0.4,
    colorInicio: AppColors.purpura,
    colorFin: AppColors.purpura,
  ),
  const MovimientoTipoModel(
    nombre: 'Blindamiento',
    cantidad: 1,
    proporcion: 0.1,
    colorInicio: AppColors.dorado,
    colorFin: AppColors.doradoOscuro,
  ),
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
          const _PageHeaderCard(
            eyebrow: 'CONTADORA - REPORTES',
            title: 'Reportes Financieros',
            subtitle: 'Resumen contable del período',
          ),
          const SizedBox(height: 14),
          _buildStatsGrid(),
          const SizedBox(height: 14),
          _buildMovimientosCard(),
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
                label: 'TOTAL MOVIMIENTOS',
                value: '$totalMovimientos',
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'TOTAL EGRESOS',
                value: totalEgresos,
                color: AppColors.rojo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'PROVEEDORES',
                value: '$totalProveedores',
                color: AppColors.enlace,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'SUCURSALES',
                value: '$totalSucursales',
                color: AppColors.purpura,
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Movimientos por Tipo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...movimientosPorTipoData.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _MovimientoBar(movimiento: m),
              )),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// Fondo azul marino oscuro, borde dorado (igual que el botón
// "Agregar dirección" de Direcciones Cliente), etiqueta dorada,
// título blanco y subtítulo azul claro.
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
        border: Border.all(color: AppColors.gold, width: 1.2),
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
              height: 1.2,
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
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ESTADÍSTICA (fondo navy) ====================
// Franja de acento a la izquierda + borde dorado en todo el cuadro.
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== BARRA DE MOVIMIENTO POR TIPO ====================
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: movimiento.colorInicio,
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [movimiento.colorInicio, movimiento.colorFin],
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