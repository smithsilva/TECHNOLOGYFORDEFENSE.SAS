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
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - PROVEEDORES',
            title: 'Proveedores',
            subtitle: '$_total proveedores registrados',
          ),
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total',
            value: '$_total',
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

// ==================== TARJETA DE ESTADÍSTICA ====================
// Filo de color arriba + borde dorado en todo el cuadro.
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
        border: Border.all(color: AppColors.gold, width: 1.2),
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

// ==================== WIDGETS AUXILIARES ====================
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

// Fila de información con label a la izquierda y valor a la derecha.
// "Ciudad" usa el color de enlace para diferenciarse visualmente del
// resto de los datos.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta de proveedor con franja de acento azul a la izquierda y
// borde dorado en todo el cuadro.
class _ProveedorCard extends StatelessWidget {
  final ProveedorModel proveedor;

  const _ProveedorCard({required this.proveedor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                proveedor.nombre,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'NIT: ${proveedor.nit}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.goldDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _EstadoBadge(estado: proveedor.estado),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Contacto', value: proveedor.contacto),
                    _InfoRow(label: 'Teléfono', value: proveedor.telefono),
                    _InfoRow(
                      label: 'Ciudad',
                      value: proveedor.ciudad,
                      valueColor: AppColors.enlace,
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