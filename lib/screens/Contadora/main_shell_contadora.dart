
import 'package:flutter/material.dart';

import '../../widgets/t4d_sidebar.dart';
import '../../widgets/contadora/contadora_appbar.dart';
import '../../widgets/admin/notificaciones_bottom_sheet.dart';

import '../admin/notificaciones_screen.dart' hide AppColors;
import 'inventario_contadora_screen.dart' hide AppColors;
import 'Movimientos_Contables_screen.dart' hide AppColors;
import 'Metodos pago screen.dart' hide AppColors;
import 'Historial precios screen.dart' hide AppColors;
import 'Proveedores screen.dart' hide AppColors;
import 'Empleados screen.dart' hide AppColors;
import 'Sucursales screen.dart' hide AppColors;
import 'Reportes screen.dart' hide AppColors;

class MainShellContadora extends StatefulWidget {
  final Map<String, dynamic>? usuario;
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

  static const double _breakpointEscritorio = 900;

  static const List<T4DMenuItem> _menu = [
    T4DMenuItem(
      icon: Icons.inventory_2_outlined,
      label: 'Inventario',
    ),
    T4DMenuItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Movimientos contables',
    ),
    T4DMenuItem(
      icon: Icons.payments_outlined,
      label: 'Métodos de pago',
    ),
    T4DMenuItem(
      icon: Icons.history_rounded,
      label: 'Historial de precios',
    ),
    T4DMenuItem(
      icon: Icons.local_shipping_outlined,
      label: 'Proveedores',
    ),
    T4DMenuItem(
      icon: Icons.badge_outlined,
      label: 'Empleados',
    ),
    T4DMenuItem(
      icon: Icons.store_outlined,
      label: 'Sucursales',
    ),
    T4DMenuItem(
      icon: Icons.bar_chart_rounded,
      label: 'Reportes',
    ),
  ];

  List<Widget> _crearPantallas() {
    return [
      InventarioContadoraScreen(
        usuario: widget.usuario,
      ),

      const MovimientosContablesScreen(),

      const MetodosPagoScreen(),

      HistorialPreciosScreen(
        usuario: widget.usuario,
      ),

      const ProveedoresScreen(),

      const EmpleadosScreen(),

      const SucursalesScreen(),

      ReportesContadoraScreen(
        usuario: widget.usuario,
      ),
    ];
  }

  void _cerrarSesion() {
    if (widget.onLogout != null) {
      widget.onLogout!();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }

  void _abrirNotificacionesCompleto() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF13161F),
              foregroundColor: Colors.white,
              title: const Text(
                'Notificaciones',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: NotificacionesScreen(
              usuario: widget.usuario,
            ),
          );
        },
      ),
    );
  }

  void _seleccionarMenu(
    int index, {
    bool cerrarDrawer = false,
  }) {
    if (index < 0 || index >= _menu.length) {
      return;
    }

    setState(() {
      _indiceActual = index;
    });

    if (cerrarDrawer && mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _construirSidebar({
    bool dentroDeDrawer = false,
  }) {
    final nombre = widget.usuario?['username'] ??
        widget.usuario?['nombre'] ??
        'Contadora';

    final email = widget.usuario?['email'] ?? '';

    return T4DSidebar(
      userName: nombre.toString(),
      userEmail: email.toString(),
      menuItems: _menu,
      selectedIndex: _indiceActual,
      onItemSelected: (index) {
        _seleccionarMenu(
          index,
          cerrarDrawer: dentroDeDrawer,
        );
      },
      onLogout: _cerrarSesion,
    );
  }

  Widget _construirContenido() {
    return IndexedStack(
      index: _indiceActual,
      children: _crearPantallas(),
    );
  }

  Widget _construirEncabezadoEscritorio() {
    return Container(
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
                const SizedBox(height: 3),
                Text(
                  _menu[_indiceActual].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            tooltip: 'Notificaciones',
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {
              mostrarNotificacionesBottomSheet(
                context,
                onVerTodas: _abrirNotificacionesCompleto,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.usuario?['username'] ??
        widget.usuario?['nombre'] ??
        'Contadora';

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool esEscritorio =
            constraints.maxWidth >= _breakpointEscritorio;

        final contenido = _construirContenido();

        // ============================================================
        // ESCRITORIO / TABLET GRANDE
        // ============================================================

        if (esEscritorio) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F0E1),
            body: Row(
              children: [
                _construirSidebar(),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _construirEncabezadoEscritorio(),
                      Expanded(
                        child: contenido,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // ============================================================
        // MÓVIL / TABLET
        // ============================================================

        return Scaffold(
          backgroundColor: const Color(0xFFF7F0E1),

          appBar: ContadoraAppBar(
            titulo: _menu[_indiceActual].label,
            nombreUsuario: nombre.toString(),
            onNotificationsTap: () {
              mostrarNotificacionesBottomSheet(
                context,
                onVerTodas: _abrirNotificacionesCompleto,
              );
            },
          ),

          drawer: Drawer(
            backgroundColor: Colors.transparent,
            child: _construirSidebar(
              dentroDeDrawer: true,
            ),
          ),

          body: contenido,
        );
      },
    );
  }
}

