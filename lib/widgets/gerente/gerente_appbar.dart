import 'package:flutter/material.dart';

/// Paleta unificada con el header del panel Admin (InventarioHeader).
class GerenteAppBarColors {
  static const navy = Color(0xFF13202E);
  static const gold = Color(0xFFD4A743);
  static const goldLight = Color(0xFFE7C98A);
}

/// AppBar compartida para TODO el panel de Gerente.
///
/// Mismo diseño que el header del panel Admin: escudo + "BIENVENIDO" /
/// título de la sección, campana y badge del usuario. Se pinta una sola
/// vez, desde [MainShellGerente], y todas las pantallas (Inventario,
/// Movimientos, Historial de precios, Tareas, Clientes, Direcciones)
/// solo entregan su contenido.
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
    final inicial = nombreUsuario.trim().isNotEmpty
        ? nombreUsuario.trim()[0].toUpperCase()
        : 'G';

    return Material(
      color: GerenteAppBarColors.navy,
      elevation: 4,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                // Botón de menú (3 rayitas) que abre el Drawer
                Builder(
                  builder: (context) => IconButton(
                    onPressed:
                        onMenuTap ?? () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(width: 8),

                // Escudo / logo
                Image.asset(
                  'assets/escudo1.png',
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield,
                    color: GerenteAppBarColors.gold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),

                // BIENVENIDO + título de la sección actual
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'BIENVENIDO',
                        style: TextStyle(
                          color: GerenteAppBarColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Campana de notificaciones
                IconButton(
                  onPressed: onNotificationsTap,
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.white70),
                ),

                // Badge del usuario
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: onProfileTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            GerenteAppBarColors.goldLight.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: GerenteAppBarColors.gold,
                          child: Text(
                            inicial,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: GerenteAppBarColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          nombreUsuario,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}