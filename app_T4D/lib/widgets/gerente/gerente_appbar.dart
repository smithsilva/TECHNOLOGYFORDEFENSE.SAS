import 'package:flutter/material.dart';

/// Paleta usada solo por esta AppBar compartida (dorado/marfil, igual
/// a la que ya usan las pantallas de Gerente: Tareas, Movimientos,
/// Historial de precios, Clientes, Direcciones).
class GerenteAppBarColors {
  static const navy = Color(0xFF13202E);
  static const gold = Color(0xFFD4A743);
  static const goldLight = Color(0xFFE7C98A);
}

/// AppBar compartida para TODO el panel de Gerente.
///
/// Se pinta una sola vez, desde [MainShellGerente], y todas las
/// pantallas (Inventario, Movimientos, Historial de precios, Tareas,
/// Clientes, Direcciones) solo entregan su contenido (con
/// `embedded: true`), sin volver a declarar su propio Scaffold/AppBar.
/// Así se ve igual de completa que el panel de Admin y de Contadora.
class GerenteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String nombreUsuario;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;

  const GerenteAppBar({
    super.key,
    required this.titulo,
    this.nombreUsuario = 'Gerente',
    this.onMenuTap,
    this.onNotificationsTap,
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: GerenteAppBarColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/escudo1.png',
                  width: 22,
                  height: 22,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield,
                    color: GerenteAppBarColors.navy,
                    size: 18,
                  ),
                ),
              ),
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
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: onNotificationsTap ?? () {},
              ),
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: GerenteAppBarColors.gold,
                      child: Icon(Icons.person, size: 12, color: GerenteAppBarColors.navy),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      nombreUsuario,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
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