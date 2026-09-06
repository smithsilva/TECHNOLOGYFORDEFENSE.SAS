import 'package:flutter/material.dart';

import '../../screens/admin/inventario_screen.dart' hide AppColors;
import '../../screens/admin/notificaciones_screen.dart' hide AppColors;
import '../../widgets/t4d_sidebar.dart';
import '../../widgets/gerente/gerente_appbar.dart';
import '../../widgets/admin/notificaciones_bottom_sheet.dart';

import 'Asignacion tareas screen.dart';
import 'Direcciones cliente.dart';
import 'Gestion clientes screen.dart';
import 'Movimientos screen.dart';
import 'Historial precios screen.dart';


const Color _fondoGerente = Color(0xFFF7F1E3);

class MainShellGerente extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  /// Se recibe desde main.dart: limpia SharedPreferences y navega al login.
  final VoidCallback? onLogout;

  const MainShellGerente({
    super.key,
    this.usuario,
    this.onLogout,
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
      visibleEnPanelPrincipal: true, // ← Gerente ya puede ver, crear y editar inventario
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
      item: const T4DMenuItem(icon: Icons.fact_check_outlined, label: 'Asignacion de Tareas'),
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
      // embedded: true → ya no dibuja su propio Scaffold/AppBar (antes
      // quedaba duplicado dentro del shell).
      pantalla: const DireccionesClienteScreen(embedded: true),
      visibleEnPanelPrincipal: true,
    ),
  ];

  // Solo las secciones visibles llegan al sidebar y al IndexedStack.
  late final List<_SeccionGerente> _seccionesVisibles =
      _todasLasSecciones.where((s) => s.visibleEnPanelPrincipal).toList();

  late final List<T4DMenuItem> _menu = _seccionesVisibles.map((s) => s.item).toList();
  late final List<Widget> _pantallas = _seccionesVisibles.map((s) => s.pantalla).toList();

  void _cerrarSesion() {
    widget.onLogout?.call();
  }

  // Gerente no tiene pestaña propia de "Notificaciones", así que "Ver
  // todas" abre la pantalla completa encima (misma NotificacionesScreen
  // de Admin).
  void _abrirNotificacionesCompleto() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF13202E),
            foregroundColor: Colors.white,
            title: const Text('Notificaciones'),
          ),
          body: NotificacionesScreen(usuario: widget.usuario),
        ),
      ),
    );
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
              if (dentroDeDrawer) {
                Navigator.of(context).pop();
              }
            },
            onLogout: _cerrarSesion,
          );
        }

        final contenido = Container(
          color: _fondoGerente,
          child: IndexedStack(
            index: _indiceActual,
            children: _pantallas,
          ),
        );

        // -------- ESCRITORIO / TABLET: sidebar fijo al costado --------
        if (esEscritorio) {
          return Scaffold(
            backgroundColor: _fondoGerente,
            body: Row(
              children: [
                sidebar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        color: const Color(0xFF13202E),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'BIENVENIDO',
                                    style: TextStyle(
                                      color: Color(0xFFE7C98A),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  Text(
                                    _menu[_indiceActual].label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_none, color: Colors.white),
                              onPressed: () => mostrarNotificacionesBottomSheet(
                                context,
                                onVerTodas: _abrirNotificacionesCompleto,
                              ),
                            ),
                          ],
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
          backgroundColor: _fondoGerente,
          appBar: GerenteAppBar(
            titulo: _menu[_indiceActual].label,
            nombreUsuario: nombre.toString(),
            onNotificationsTap: () => mostrarNotificacionesBottomSheet(
              context,
              onVerTodas: _abrirNotificacionesCompleto,
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