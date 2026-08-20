import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF13202E);
  static const dorado = Color(0xFFD4A743);
  static const doradoClaro = Color(0xFFE7C98A);
}

class ContadoraDrawer extends StatelessWidget {
  final Map<String, dynamic>? usuario;
  final String seccionActiva;
  final void Function(String seccion) onSeleccionar;
  final VoidCallback? onLogout;

  const ContadoraDrawer({
    super.key,
    required this.seccionActiva,
    required this.onSeleccionar,
    this.usuario,
    this.onLogout,
  });

  static const _items = [
    {'key': 'inventario', 'label': 'Inventario', 'icon': Icons.inventory_2_outlined},
    {'key': 'empleados', 'label': 'Empleados', 'icon': Icons.badge_outlined},
    {'key': 'historial', 'label': 'Historial de Precios', 'icon': Icons.history},
    {'key': 'metodos_pago', 'label': 'Métodos de Pago', 'icon': Icons.payments_outlined},
    {'key': 'proveedores', 'label': 'Proveedores', 'icon': Icons.local_shipping_outlined},
    {'key': 'reportes', 'label': 'Reportes', 'icon': Icons.bar_chart},
    {'key': 'sucursales', 'label': 'Sucursales', 'icon': Icons.store_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final nombre = (usuario?['nombre'] ?? 'Contadora').toString();
    final correo = (usuario?['correo'] ?? usuario?['email'] ?? '').toString();

    return Drawer(
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Image.asset('assets/escudo1.png', width: 34, height: 34),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('T4D',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('TECHNOLOGY FOR DEFENSE SAS',
                            style: TextStyle(color: AppColors.doradoClaro, fontSize: 9, letterSpacing: 0.6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dorado.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dorado.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.dorado,
                      child: Icon(Icons.person, color: AppColors.navy, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$nombre / Contadora',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          if (correo.isNotEmpty)
                            Text(correo, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('MENÚ PRINCIPAL',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.6)),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: _items.map((item) {
                  final activo = seccionActiva == item['key'];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: activo ? AppColors.dorado : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(item['icon'] as IconData,
                          size: 20, color: activo ? AppColors.navy : Colors.white70),
                      title: Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: activo ? AppColors.navy : Colors.white,
                          fontWeight: activo ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onSeleccionar(item['key'] as String);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                title: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                onTap: () {
                  Navigator.of(context).pop();
                  onLogout?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}