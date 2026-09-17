import 'package:flutter/material.dart';

/// Paleta unificada con el header del panel Admin (InventarioHeader).
class ContadoraAppBarColors {
  static const navy = Color(0xFF13202E);
  static const dorado = Color(0xFFD4A743);
  static const doradoClaro = Color(0xFFE7C98A);
}

/// AppBar compartida para TODO el panel de Contadora.
///
/// Mismo diseño que el header del panel Admin: escudo + "BIENVENIDO" /
/// título de la sección, campana y badge del rol/usuario. Se pinta una
/// sola vez, desde [MainShellContadora], y todas las pantallas
/// (Inventario, Empleados, Historial de precios, Métodos de pago,
/// Proveedores, Reportes, Sucursales) solo entregan su contenido, sin
/// volver a declarar su propio Scaffold/AppBar.
class ContadoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final String nombreUsuario;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;

  /// AJUSTE: callback que se dispara al tocar el badge con el nombre
  /// del usuario (ej. "Nicol"). MainShellContadora debe pasar aquí la
  /// navegación hacia PerfilScreen (push o cambio de tab, según cómo
  /// esté armado el shell).
  final VoidCallback? onPerfilTap;

  const ContadoraAppBar({
    super.key,
    required this.titulo,
    this.nombreUsuario = 'Contadora',
    this.onMenuTap,
    this.onNotificationsTap,
    this.onPerfilTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final inicial = nombreUsuario.trim().isNotEmpty
        ? nombreUsuario.trim()[0].toUpperCase()
        : 'C';

    return Material(
      color: ContadoraAppBarColors.navy,
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
                    color: ContadoraAppBarColors.dorado,
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
                          color: ContadoraAppBarColors.dorado,
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

                // Badge del rol / usuario
                //
                // AJUSTE: envuelto en InkWell + Material transparente para
                // que sea tappable y lleve al perfil vía onPerfilTap, sin
                // perder la forma de "pill" redondeada (borderRadius 30).
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onPerfilTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: ContadoraAppBarColors.doradoClaro
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: ContadoraAppBarColors.dorado,
                            child: Text(
                              inicial,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ContadoraAppBarColors.navy,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}