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

  // Alias usados en esta pantalla, ahora apuntando a la paleta nueva.
  static const background = fondo;
  static const navy = navyOscuro;
  static const gold = dorado;
  static const goldDark = doradoOscuro;
  static const green = verde;
  static const greenBg = verdeFondo;
  static const textDark = Color(0xFF111827);
  static const textGrey = textoMuted;
  static const white = Colors.white;
  static const cardBorder = Color(0xFFEFEFF2);
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
class MetodoPagoModel {
  final String nombre;
  final String descripcion;
  final String comision;
  final String estado;

  const MetodoPagoModel({
    required this.nombre,
    required this.descripcion,
    required this.comision,
    required this.estado,
  });
}

final List<MetodoPagoModel> metodosPagoData = [
  const MetodoPagoModel(
    nombre: 'Efectivo',
    descripcion: 'Pago en efectivo en punto físico',
    comision: '0%',
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Transferencia Bancaria',
    descripcion: 'Transferencia entre cuentas bancarias',
    comision: '0%',
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Nequi',
    descripcion: 'Pago digital a través de la aplicación Nequi',
    comision: '0%',
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Tarjeta Crédito/Débito',
    descripcion: 'Pago con tarjeta mediante datáfono o pasarela',
    comision: '2.5%',
    estado: 'Activo',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class MetodosPagoScreen extends StatelessWidget {
  const MetodosPagoScreen({super.key});

  int get _totalMetodos => metodosPagoData.length;
  int get _activos =>
      metodosPagoData.where((m) => m.estado == 'Activo').length;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          const _PageHeaderCard(
            eyebrow: 'CONTADORA - PAGOS',
            title: 'Métodos de Pago',
            subtitle: 'Canales de pago aceptados',
          ),
          const SizedBox(height: 14),
          _buildStatsRow(),
          const SizedBox(height: 14),
          ...metodosPagoData.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MetodoCard(metodo: m),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total',
            value: '$_totalMetodos',
            accentColor: AppColors.gold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Activos',
            value: '$_activos',
            accentColor: AppColors.green,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// Fondo azul marino oscuro, etiqueta dorada, título blanco,
// subtítulo azul claro y dos estrellitas doradas.
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

// ==================== TARJETA DE ESTADÍSTICA ====================
// Sin ícono decorativo: solo un filo de color arriba, valor grande
// y etiqueta debajo, para que no se vea como un dashboard genérico.
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(height: 4, color: accentColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE MÉTODO DE PAGO ====================
// Reemplaza la tabla anterior por tarjetas individuales con una
// franja de acento a la izquierda, igual al estilo de las imágenes.
class _MetodoCard extends StatelessWidget {
  final MetodoPagoModel metodo;

  const _MetodoCard({required this.metodo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: AppColors.enlace),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            metodo.nombre,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        _EstadoBadge(estado: metodo.estado),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      metodo.descripcion,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comisión',
                          style: TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                        ),
                        Text(
                          metodo.comision,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldDark,
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
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}