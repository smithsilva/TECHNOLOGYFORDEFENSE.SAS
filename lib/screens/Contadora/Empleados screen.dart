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
class EmpleadoModel {
  final String initials;
  final Color avatarColor;
  final String nombre;
  final String cargo;
  final String correo;
  final String telefono;
  final String salario;
  final String estado;

  const EmpleadoModel({
    required this.initials,
    required this.avatarColor,
    required this.nombre,
    required this.cargo,
    required this.correo,
    required this.telefono,
    required this.salario,
    required this.estado,
  });
}

// Colores de avatar tomados de tu paleta (antes eran morado/naranja/
// rosado genéricos, ahora usan dorado oscuro, azul "enlace" y rojo).
final List<EmpleadoModel> empleadosData = [
  const EmpleadoModel(
    initials: 'CG',
    avatarColor: AppColors.enlace,
    nombre: 'Camilo García',
    cargo: 'Mecánico',
    correo: 'camilo@t4d.com',
    telefono: '310 111 2222',
    salario: '\$2.800.000',
    estado: 'Activo',
  ),
  const EmpleadoModel(
    initials: 'JP',
    avatarColor: AppColors.doradoOscuro,
    nombre: 'Juan Pérez',
    cargo: 'Admin',
    correo: 'juan@t4d.com',
    telefono: '310 333 4444',
    salario: '\$3.500.000',
    estado: 'Activo',
  ),
  const EmpleadoModel(
    initials: 'CT',
    avatarColor: AppColors.rojo,
    nombre: 'Contadora T4D',
    cargo: 'Contadora',
    correo: 'contadora@gmail.com',
    telefono: '310 555 6666',
    salario: '\$4.200.000',
    estado: 'Activo',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class EmpleadosScreen extends StatelessWidget {
  const EmpleadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - EMPLEADOS',
            title: 'Empleados',
            subtitle: '${empleadosData.length} empleados registrados',
          ),
          const SizedBox(height: 14),
          ...empleadosData.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _EmpleadoCard(empleado: e),
              )),
        ],
      ),
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// Fondo azul marino oscuro, etiqueta dorada, título blanco
// y subtítulo azul claro.
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

// Tarjeta de empleado con franja de acento a la izquierda (color del
// avatar), sin íconos decorativos, igual al estilo de tus capturas.
class _EmpleadoCard extends StatelessWidget {
  final EmpleadoModel empleado;

  const _EmpleadoCard({required this.empleado});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
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
            Container(width: 4, color: empleado.avatarColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: empleado.avatarColor,
                      child: Text(
                        empleado.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  empleado.nombre,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              _EstadoBadge(estado: empleado.estado),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            empleado.cargo,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            empleado.correo,
                            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                empleado.telefono,
                                style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                              ),
                              Text(
                                empleado.salario,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
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
          ],
        ),
      ),
    );
  }
}