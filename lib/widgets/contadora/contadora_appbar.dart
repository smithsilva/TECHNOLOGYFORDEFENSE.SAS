import 'package:flutter/material.dart';

/// Paleta usada solo por esta AppBar compartida.
class ContadoraAppBarColors {
  static const navy = Color(0xFF13161F);
  static const gold = Color(0xFFE0A93B);
}

/// AppBar compartida para TODO el panel de Contadora.
///
/// Se pinta una sola vez, desde [MainShellContadora], y todas las
/// pantallas (Inventario, Empleados, Historial de precios, Métodos de
/// pago, Proveedores, Reportes, Sucursales) solo entregan su contenido,
/// sin volver a declarar su propio Scaffold/AppBar. Así se ve igual de
/// completa que el panel de Admin (BIENVENIDO + título + campana + chip
/// de usuario).
class ContadoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String nombreUsuario;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;

  const ContadoraAppBar({
    super.key,
    required this.titulo,
    this.nombreUsuario = 'Contadora',
    this.onMenuTap,
    this.onNotificationsTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final inicial = nombreUsuario.trim().isNotEmpty
        ? nombreUsuario.trim()[0].toUpperCase()
        : 'C';

    return Container(
      decoration: const BoxDecoration(color: ContadoraAppBarColors.navy),
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
                  color: ContadoraAppBarColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/escudo1.png',
                  width: 22,
                  height: 22,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield,
                    color: ContadoraAppBarColors.navy,
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
                        color: ContadoraAppBarColors.gold,
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
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: ContadoraAppBarColors.gold,
                      child: Text(
                        inicial,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ContadoraAppBarColors.navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Contadora',
                      style: TextStyle(
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