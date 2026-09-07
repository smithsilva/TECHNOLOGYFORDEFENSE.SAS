import 'package:flutter/material.dart';

import '../../widgets/t4d_sidebar.dart';
import '../../widgets/contadora/contadora_appbar.dart';
import '../../widgets/admin/notificaciones_bottom_sheet.dart';
import '../admin/notificaciones_screen.dart' hide AppColors;
import 'inventario_contadora_screen.dart' hide AppColors; // -> class InventarioContadoraScreen
import 'Movimientos_Contables_screen.dart' hide AppColors; // ->  class movimientos_contables
import 'Metodos pago screen.dart' hide AppColors; // -> class MetodosPagoScreen
import 'Historial precios screen.dart' hide AppColors; // -> class HistorialPreciosScreen
import 'Proveedores screen.dart' hide AppColors; // -> class ProveedoresScreen
import 'Empleados screen.dart' hide AppColors; // -> class EmpleadosScreen
import 'Sucursales screen.dart' hide AppColors; // -> class SucursalesScreen
import 'Reportes screen.dart' hide AppColors; // -> class ReportesFinancierosScreen



class MainShellContadora extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  /// Se recibe desde main.dart: limpia SharedPreferences y navega al login.
  final VoidCallback? onLogout;

  const MainShellContadora({
    super.key,
    this.usuario,
    this.onLogout,
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
    T4DMenuItem(icon: Icons.inventory_2_outlined, label: 'Inventario'),
    T4DMenuItem(icon: Icons.account_balance_wallet_outlined, label: 'Movimientos contables'),
    T4DMenuItem(icon: Icons.payments_outlined, label: 'Métodos de pago'),
    T4DMenuItem(icon: Icons.history_rounded, label: 'Historial de precios'),
    T4DMenuItem(icon: Icons.local_shipping_outlined, label: 'Proveedores'),
    T4DMenuItem(icon: Icons.badge_outlined, label: 'Empleados'),
    T4DMenuItem(icon: Icons.store_outlined, label: 'Sucursales'),
    T4DMenuItem(icon: Icons.bar_chart_rounded, label: 'Reportes'),
    
    
  ];

  // El orden debe coincidir 1 a 1 con _menu de arriba.
  late final List<Widget> _pantallas = [
    InventarioContadoraScreen(usuario: widget.usuario),
    const MovimientosContablesScreen(),
    const MetodosPagoScreen(),
    const HistorialPreciosScreen(),
    const ProveedoresScreen(),
    const EmpleadosScreen(),
    const SucursalesScreen(),
    const ReportesFinancierosScreen(),
  ];

  void _cerrarSesion() {
    // Usa el callback centralizado en main.dart (limpia SharedPreferences
    // y vuelve a la vista 'login'), igual que MainShell y MainShellGerente.
    widget.onLogout?.call();
  }

  // Contadora no tiene pestaña propia de "Notificaciones" en el sidebar,
  // así que "Ver todas" dentro del bottom sheet abre la pantalla completa
  // encima (reutilizando la misma NotificacionesScreen de Admin).
  void _abrirNotificacionesCompleto() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF13161F),
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
                          vertical: 16,
                        ),
                        color: const Color(0xFF13161F),
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
                                      color: Color(0xFFE0A93B),
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
                              icon: const Icon(Icons.notifications_none,
                                  color: Colors.white),
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
          backgroundColor: const Color(0xFFF7F0E1),
          appBar: ContadoraAppBar(
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