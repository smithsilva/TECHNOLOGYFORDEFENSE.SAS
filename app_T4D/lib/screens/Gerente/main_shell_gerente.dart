import 'package:flutter/material.dart';


import '../inventario_screen.dart' hide AppColors;
import '../../widgets/t4d_sidebar.dart';

import 'Asignacion tareas screen.dart'; 

import 'Direcciones cliente.dart' hide AppColors; 
import 'Gestion clientes screen.dart'; 
import 'Movimientos screen.dart';
import 'Historial precios screen.dart'; 
class MainShellGerente extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const MainShellGerente({
    super.key,
    this.usuario,
  });

  @override
  State<MainShellGerente> createState() => _MainShellGerenteState();
}

class _SeccionGerente {
  final T4DMenuItem item;
  final Widget pantalla;
  final bool visibleEnPanelPrincipal;

  const _SeccionGerente({
    required this.item,
    required this.pantalla,
    this.visibleEnPanelPrincipal = true,
  });
}

class _MainShellGerenteState extends State<MainShellGerente> {
  int _indiceActual = 0;

  // Por debajo de este ancho (en píxeles lógicos) el sidebar se
  // convierte en un drawer deslizable en vez de quedar fijo.
  static const double _breakpointEscritorio = 900;

  late final List<_SeccionGerente> _todasLasSecciones = [
    _SeccionGerente(
      item: const T4DMenuItem(icon: Icons.inventory_2_outlined, label: 'Inventario'),
      pantalla: InventarioScreen(usuario: widget.usuario),
      visibleEnPanelPrincipal: false,
    ),
    _SeccionGerente(
      item: const T4DMenuItem(icon: Icons.swap_horiz_rounded, label: 'Movimientos'),
      pantalla: const MovimientosScreen(embedded: true),
      visibleEnPanelPrincipal: true,
    ),
    _SeccionGerente(
      item: const T4DMenuItem(icon: Icons.history_rounded, label: 'Historial de Precios'),
      pantalla: const HistorialPreciosScreen(embedded: true),
      visibleEnPanelPrincipal: true,
    ),
    _SeccionGerente(
      item: const T4DMenuItem(icon: Icons.fact_check_outlined, label: 'Tareas'),
      pantalla: const AsignacionTareasScreen(embedded: true),
      visibleEnPanelPrincipal: true,
    ),
    _SeccionGerente(
      item: const T4DMenuItem(icon: Icons.person_outline_rounded, label: 'Cliente'),
      pantalla: const GestionClientesScreen(embedded: true),
      visibleEnPanelPrincipal: true,
    ),
    _SeccionGerente(
      item: const T4DMenuItem(icon: Icons.place_outlined, label: 'Direcciones'),
      pantalla: const DireccionesClienteScreen(),
      visibleEnPanelPrincipal: true,
    ),
  ];

  // Solo las secciones visibles llegan al sidebar y al IndexedStack.
  late final List<_SeccionGerente> _seccionesVisibles =
      _todasLasSecciones.where((s) => s.visibleEnPanelPrincipal).toList();

  late final List<T4DMenuItem> _menu = _seccionesVisibles.map((s) => s.item).toList();
  late final List<Widget> _pantallas = _seccionesVisibles.map((s) => s.pantalla).toList();

  void _cerrarSesion() {
    
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.usuario?['username'] ?? widget.usuario?['nombre'] ?? 'Gerente';
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
              // En móvil, al elegir una sección se cierra el drawer.
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
            backgroundColor: AppColors.background,
            body: Row(
              children: [
                sidebar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: const Color(0xFF13202E),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              _menu[_indiceActual].label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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