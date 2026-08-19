import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF13202E);
  static const dorado = Color(0xFFD4A743);
  static const doradoClaro = Color(0xFFE7C98A);
}

/// Encabezado superior compartido por todas las pestañas del panel:
/// escudo + "BIENVENIDO" / título de la sección, campana y badge del rol.
class InventarioHeader extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Map<String, dynamic>? usuario;
  final VoidCallback? onNotificaciones;
  final VoidCallback? onLogout;

  const InventarioHeader({
    super.key,
    required this.titulo,
    this.usuario,
    this.onNotificaciones,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final rolCrudo = (usuario?['rol'] ?? usuario?['nombre'] ?? 'Usuario').toString();
    final rol = rolCrudo.isEmpty
        ? 'Usuario'
        : rolCrudo[0].toUpperCase() + rolCrudo.substring(1);

    return Material(
      color: AppColors.navy,
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
                    onPressed: () => Scaffold.of(context).openDrawer(),
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
                          color: AppColors.dorado,
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
                  onPressed: onNotificaciones,
                  icon: const Icon(Icons.notifications_none, color: Colors.white70),
                ),

                // Badge del rol / usuario
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.doradoClaro.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.dorado,
                        child: Text(
                          rol.isNotEmpty ? rol[0] : '?',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        rol,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
      ),
    );
  }
}