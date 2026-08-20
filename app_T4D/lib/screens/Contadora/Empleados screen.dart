import 'package:flutter/material.dart';

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

final List<EmpleadoModel> empleadosData = [
  const EmpleadoModel(
    initials: 'CG',
    avatarColor: Color(0xFF8B7FE8),
    nombre: 'Camilo García',
    cargo: 'Mecánico',
    correo: 'camilo@t4d.com',
    telefono: '310 111 2222',
    salario: '\$2.800.000',
    estado: 'Activo',
  ),
  const EmpleadoModel(
    initials: 'JP',
    avatarColor: Color(0xFFF2994A),
    nombre: 'Juan Pérez',
    cargo: 'Admin',
    correo: 'juan@t4d.com',
    telefono: '310 333 4444',
    salario: '\$3.500.000',
    estado: 'Activo',
  ),
  const EmpleadoModel(
    initials: 'CT',
    avatarColor: Color(0xFFE85D9E),
    nombre: 'Contadora T4D',
    cargo: 'Contadora',
    correo: 'contadora@t4d.com',
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
          _buildHeaderCard(),
          const SizedBox(height: 14),
          ...empleadosData.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _EmpleadoCard(empleado: e),
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
            'Empleados',
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
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmpleadoCard extends StatelessWidget {
  final EmpleadoModel empleado;

  const _EmpleadoCard({required this.empleado});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: empleado.avatarColor,
            child: Text(
              empleado.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empleado.nombre,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  empleado.cargo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  empleado.correo,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                ),
                Text(
                  empleado.telefono,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                empleado.salario,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              _EstadoBadge(estado: empleado.estado),
            ],
          ),
        ],
      ),
    );
  }
}