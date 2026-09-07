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

  // Tono rosa-mauve para las etiquetas (Ciudad / Dirección / Encargado)
  static const rosaMuted = Color(0xFFB98CA0);
  // Azul oscuro para los valores (Bogotá, direcciones, encargados)
  static const azulValor = Color(0xFF1B4F91);

  // Alias usados en las pantallas
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
class SucursalModel {
  final String numero;
  final String codigo;
  final String nombre;
  final String ciudad;
  final String direccion;
  final String encargado;
  final String estado;

  const SucursalModel({
    required this.numero,
    required this.codigo,
    required this.nombre,
    required this.ciudad,
    required this.direccion,
    required this.encargado,
    required this.estado,
  });
}

final List<SucursalModel> sucursalesData = [
  const SucursalModel(
    numero: '#1',
    codigo: 'SUC-001',
    nombre: 'Sucursal Norte',
    ciudad: 'Bogotá',
    direccion: 'Calle 100 # 15-20',
    encargado: 'Carlos R.',
    estado: 'Activa',
  ),
  const SucursalModel(
    numero: '#2',
    codigo: 'SUC-002',
    nombre: 'Sucursal Sur',
    ciudad: 'Bogotá',
    direccion: 'Cra 50 # 80-10',
    encargado: 'María P.',
    estado: 'Activa',
  ),
  const SucursalModel(
    numero: '#3',
    codigo: 'SUC-003',
    nombre: 'Sucursal Centro',
    ciudad: 'Bogotá',
    direccion: 'Av 19 # 30-45',
    encargado: 'Juan S.',
    estado: 'Activa',
  ),
  const SucursalModel(
    numero: '#4',
    codigo: 'SUC-004',
    nombre: 'Sucursal Principal',
    ciudad: 'Bogotá',
    direccion: 'Av El Dorado # 59-70',
    encargado: 'Director',
    estado: 'Activa',
  ),
  const SucursalModel(
    numero: '#5',
    codigo: 'SUC-005',
    nombre: 'Sucursal Medellín',
    ciudad: 'Medellín',
    direccion: 'Cra 43A # 1-50',
    encargado: 'Pedro A.',
    estado: 'Activa',
  ),
  const SucursalModel(
    numero: '#6',
    codigo: 'SUC-006',
    nombre: 'Sucursal Cali',
    ciudad: 'Cali',
    direccion: 'Calle 5 # 39-45',
    encargado: 'Laura M.',
    estado: 'Activa',
  ),
  const SucursalModel(
    numero: '#7',
    codigo: 'SUC-007',
    nombre: 'Sucursal Cúcuta',
    ciudad: 'Cúcuta',
    direccion: 'Av 0 # 10-85',
    encargado: 'Miguel T.',
    estado: 'Activa',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class SucursalesScreen extends StatelessWidget {
  const SucursalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = sucursalesData.length;
    final activas =
        sucursalesData.where((s) => s.estado.toLowerCase() == 'activa').length;

    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - SUCURSALES',
            title: 'Sucursales',
            subtitle: '$total sucursales registradas',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  valor: '$total',
                  label: 'Total',
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  valor: '$activas',
                  label: 'Activas',
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...sucursalesData.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SucursalCard(sucursal: s),
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

// ==================== TARJETA DE ESTADÍSTICA (Total / Activas) ====================
// Borde dorado en todo el cuadro (antes usaba el color del acento
// con opacidad; ahora siempre es dorado, igual al resto de la app).
class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
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
    final bool activa = estado.toLowerCase() == 'activa';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activa ? AppColors.greenBg : const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: activa ? AppColors.green : AppColors.textGrey,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Fila etiqueta / valor (Ciudad, Dirección, Encargado)
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.rosaMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.azulValor,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta de sucursal con franja de acento a la izquierda (verde si
// está activa) y borde dorado en todo el cuadro.
class _SucursalCard extends StatelessWidget {
  final SucursalModel sucursal;

  const _SucursalCard({required this.sucursal});

  @override
  Widget build(BuildContext context) {
    final bool activa = sucursal.estado.toLowerCase() == 'activa';

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
            Container(
              width: 4,
              color: activa ? AppColors.green : AppColors.textGrey,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${sucursal.numero} ',
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: sucursal.nombre,
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _EstadoBadge(estado: sucursal.estado),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sucursal.codigo,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Ciudad', value: sucursal.ciudad),
                    _InfoRow(label: 'Dirección', value: sucursal.direccion),
                    _InfoRow(label: 'Encargado', value: sucursal.encargado),
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