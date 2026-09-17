import 'package:flutter/material.dart';

/// Paleta usada solo por esta AppBar compartida (dorado/marfil, igual
/// a la que ya usan las pantallas de Gerente: Tareas, Movimientos,
/// Historial de precios, Clientes, Direcciones).
class GerenteAppBarColors {
  static const navy = Color(0xFF13202E);
  static const gold = Color(0xFFD4A743);
  static const goldLight = Color(0xFFE7C98A);
  static const goldSoft = Color(0x33D4A743); // dorado al 20% para el pill
}

/// AppBar compartida para TODO el panel de Gerente.
///
/// Se pinta una sola vez, desde [MainShellGerente], y todas las
/// pantallas (Inventario, Movimientos, Historial de precios, Tareas,
/// Clientes, Direcciones) solo entregan su contenido (con

class GerenteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String nombreUsuario;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;

  const GerenteAppBar({
    super.key,
    required this.titulo,
    this.nombreUsuario = 'Gerente',
    this.onMenuTap,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: GerenteAppBarColors.navy),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 22),
                onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              ),
              const _T4DBadge(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'BIENVENIDO',
                      style: TextStyle(
                        color: GerenteAppBarColors.goldLight,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      titulo,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                onPressed: onNotificationsTap ?? () {},
              ),
              const SizedBox(width: 2),
              _ProfilePill(nombreUsuario: nombreUsuario, onTap: onProfileTap),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Badge dorado tipo escudo con las siglas "T4D", igual al de la
// imagen de referencia (fondo navy, borde y texto dorados).
// ------------------------------------------------------------
class _T4DBadge extends StatelessWidget {
  const _T4DBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 34,
      child: CustomPaint(
        painter: _ShieldPainter(),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Text(
              'T4D',
              style: TextStyle(
                color: GerenteAppBarColors.gold,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.22)
      ..lineTo(w, h * 0.55)
      ..cubicTo(w, h * 0.85, w * 0.75, h * 0.97, w * 0.5, h)
      ..cubicTo(w * 0.25, h * 0.97, 0, h * 0.85, 0, h * 0.55)
      ..lineTo(0, h * 0.22)
      ..close();

    final fillPaint = Paint()
      ..color = GerenteAppBarColors.navy
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = GerenteAppBarColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ------------------------------------------------------------
// Pill "Gerente" con avatar dorado, igual al de la imagen.
// ------------------------------------------------------------
class _ProfilePill extends StatelessWidget {
  final String nombreUsuario;
  final VoidCallback? onTap;

  const _ProfilePill({required this.nombreUsuario, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
          decoration: BoxDecoration(
            color: GerenteAppBarColors.goldSoft,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GerenteAppBarColors.gold.withValues(alpha: 0.55), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 11,
                backgroundColor: GerenteAppBarColors.gold,
                child: Icon(Icons.person, size: 13, color: GerenteAppBarColors.navy),
              ),
              const SizedBox(width: 7),
              Text(
                nombreUsuario,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}