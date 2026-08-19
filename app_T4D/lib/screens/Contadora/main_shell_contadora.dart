import 'package:flutter/material.dart';

import '../../widgets/t4d_sidebar.dart';

import 'Empleados screen.dart'; // -> class EmpleadosScreen
import 'Historial precios screen.dart'; // -> class HistorialPreciosScreen
import 'Proveedores screen.dart'; // -> class ProveedoresScreen
import 'Reportes screen.dart'; // -> class ReportesFinancierosScreen
import 'Sucursales screen.dart'; // -> class SucursalesScreen

// ⚠️ La pantalla de "Métodos de pago" todavía no está hecha,
// así que por ahora se muestra un marcador de posición.
import '../placeholder_screen.dart';

class MainShellContadora extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const MainShellContadora({
    super.key,
    this.usuario,
  });

  @override
  State<MainShellContadora> createState() => _MainShellContadoraState();
}

class _MainShellContadoraState extends State<MainShellContadora> {
  int _indiceActual = 0;

  // Por debajo de este ancho (en píxeles lógicos) el sidebar se
  // convierte en un drawer deslizable en vez de quedar fijo.
  static const double _breakpointEscritorio = 900;

  static const List<T4DMenuItem> _menu = [
    T4DMenuItem(icon: Icons.badge_outlined, label: 'Empleados'),
    T4DMenuItem(icon: Icons.payments_outlined, label: 'Métodos de pago'),
    T4DMenuItem(icon: Icons.local_shipping_outlined, label: 'Proveedores'),
    T4DMenuItem(icon: Icons.bar_chart_rounded, label: 'Reportes'),
    T4DMenuItem(icon: Icons.store_outlined, label: 'Sucursales'),
    T4DMenuItem(icon: Icons.history_rounded, label: 'Historial de precios'),
  ];

  // El orden debe coincidir 1 a 1 con _menu de arriba.
  late final List<Widget> _pantallas = [
    const EmpleadosScreen(),
    const PlaceholderScreen(
      titulo: 'Métodos de pago',
      icono: Icons.payments_outlined,
    ),
    const ProveedoresScreen(),
    const ReportesFinancierosScreen(),
    const SucursalesScreen(),
    const HistorialPreciosScreen(),
  ];

  void _cerrarSesion() {
    // ⚠️ Ajusta esto a tu flujo real de logout / login.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.usuario?['username'] ??
        widget.usuario?['nombre'] ??
        'Contadora';

    final email = widget.usuario?['email'] ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final esEscritorio = constraints.maxWidth >= _breakpointEscritorio;

        Widget sidebar({bool dentroDeDrawer = false}) {
          return T4DSidebar(
            userName: nombre,
            userEmail: email,
            menuItems: _menu,
            selectedIndex: _indiceActual,
            onItemSelected: (index) {
              setState(() => _indiceActual = index);
              if (dentroDeDrawer) {
                Navigator.of(context).pop();
              }
            },
            onLogout: _cerrarSesion,
          );
        }

        final contenido = IndexedStack(
          index: _indiceActual,
          children: _pantallas,
        );

        // -------- ESCRITORIO / TABLET: sidebar fijo al costado --------
        if (esEscritorio) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F0E1),
            body: Row(
              children: [
                sidebar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        color: const Color(0xFF13202E),
                        child: Text(
                          _menu[_indiceActual].label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: contenido),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // -------- MÓVIL: sidebar como drawer, contenido a todo el ancho --------
        return Scaffold(
          backgroundColor: const Color(0xFFF7F0E1),
          appBar: AppBar(
            backgroundColor: const Color(0xFF13202E),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              _menu[_indiceActual].label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.transparent,
            child: sidebar(dentroDeDrawer: true),
          ),
          body: contenido,
        );
      },
    );
  }
}