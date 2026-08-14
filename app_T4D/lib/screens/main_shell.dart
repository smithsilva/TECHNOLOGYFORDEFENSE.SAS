import 'package:flutter/material.dart';
import 'inventario_screen.dart';
import 'placeholder_screen.dart';
import '../widgets/inventario_header.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const navy = Color(0xFF13202E);
  static const inactivo = Color(0xFF9AA5B1);
}

/// Contenedor principal con la barra de navegación inferior.
/// Equivalente al SidebarAdmin de la web, pero como bottom nav para móvil.
class MainShell extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const MainShell({super.key, this.usuario});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _indiceActual = 0;

  late final List<Widget> _pantallas = [
    InventarioScreen(usuario: widget.usuario),
    const PlaceholderScreen(titulo: 'Movimientos', icono: Icons.swap_horiz),
    const PlaceholderScreen(titulo: 'Historial de Precios', icono: Icons.history),
    const PlaceholderScreen(titulo: 'Notificaciones', icono: Icons.notifications_none),
    const PlaceholderScreen(titulo: 'Reportes', icono: Icons.bar_chart),
    const PlaceholderScreen(titulo: 'Usuarios', icono: Icons.people_outline),
    const PlaceholderScreen(titulo: 'Registro', icono: Icons.person_add_outlined),
  ];

  static const _items = [
    _ItemNav('Inventario', Icons.inventory_2_outlined),
    _ItemNav('Movim.', Icons.swap_horiz),
    _ItemNav('Historial', Icons.history),
    _ItemNav('Notif.', Icons.notifications_none),
    _ItemNav('Reportes', Icons.bar_chart),
    _ItemNav('Usuarios', Icons.people_outline),
    _ItemNav('Registro', Icons.person_add_outlined),
  ];

  static const _titulos = [
    'Inventario',
    'Movimientos',
    'Historial de Precios',
    'Notificaciones',
    'Reportes',
    'Usuarios',
    'Registro',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventarioHeader(
        titulo: _titulos[_indiceActual],
        usuario: widget.usuario,
        onNotificaciones: () => setState(() => _indiceActual = 3), // salta a la pestaña Notificaciones
      ),
      // IndexedStack conserva el estado de cada pestaña al cambiar entre ellas.
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.navy,
        selectedItemColor: AppColors.dorado,
        unselectedItemColor: AppColors.inactivo,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: _indiceActual,
        onTap: (i) => setState(() => _indiceActual = i),
        items: _items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icono, size: 20),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ItemNav {
  final String label;
  final IconData icono;
  const _ItemNav(this.label, this.icono);
}