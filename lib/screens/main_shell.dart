import 'package:flutter/material.dart';
import './admin/inventario_screen.dart';
import './admin/movimientos_screen.dart';
import './admin/categorias_screen.dart';
import './admin/historial_precios_screen.dart';
import './admin/notificaciones_screen.dart';
import './admin/reportes_screen.dart';
import './admin/gestion_usuarios_screen.dart';
import './admin/registro_usuarios_screen.dart';
import '../widgets/compartido/inventario_header.dart';
import '../widgets/admin/admin_panel_drawer.dart';
import '../widgets/admin/notificaciones_bottom_sheet.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const navy = Color(0xFF13202E);
  static const inactivo = Color(0xFF9AA5B1);
}

/// Contenedor principal con menú lateral (Drawer).
/// Equivalente al SidebarAdmin de la web.
class MainShell extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  /// Se recibe desde main.dart: limpia SharedPreferences y navega al login.
  final VoidCallback? onLogout;

  const MainShell({super.key, this.usuario, this.onLogout});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _indiceActual = 0;

  // ⚠️ El orden de _pantallas, _claves y _titulos debe coincidir
  // exactamente entre sí, e idealmente con el orden del Drawer
  // (PanelDrawer._items), aunque no es obligatorio que sea idéntico
  // siempre y cuando las 3 listas de aquí abajo estén sincronizadas.
  late final List<Widget> _pantallas = [
    InventarioScreen(usuario: widget.usuario),
    CategoriasScreen(usuario: widget.usuario),
    MovimientosScreen(usuario: widget.usuario),
    HistorialPreciosScreen(usuario: widget.usuario),
    NotificacionesScreen(usuario: widget.usuario),
    ReportesScreen(usuario: widget.usuario),
    UsuariosScreen(usuario: widget.usuario),
    RegistroScreen(usuario: widget.usuario),
  ];

  static const _claves = [
    'inventario',
    'categorias',
    'movimientos',
    'historial',
    'notificaciones',
    'reportes',
    'usuarios',
    'registro',
  ];

  static const _titulos = [
    'Inventario',
    'Categorías',
    'Movimientos',
    'Historial de Precios',
    'Notificaciones',
    'Reportes',
    'Usuarios',
    'Registro',
  ];

  void _irASeccion(String seccion) {
    final indice = _claves.indexOf(seccion);
    if (indice != -1) {
      setState(() => _indiceActual = indice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InventarioHeader(
        titulo: _titulos[_indiceActual],
        usuario: widget.usuario,
        // Ahora abre el bottom sheet de notificaciones. Si el usuario
        // toca "Ver todas" dentro del sheet, ahí sí navega a la
        // pantalla completa reutilizando _irASeccion(), igual que el Drawer.
        onNotificaciones: () => mostrarNotificacionesBottomSheet(
          context,
          onVerTodas: () => _irASeccion('notificaciones'),
        ),
        onLogout: widget.onLogout,
      ),
      drawer: PanelDrawer(
        usuario: widget.usuario,
        seccionActiva: _claves[_indiceActual],
        onSeleccionar: _irASeccion,
        onLogout: widget.onLogout,
      ),
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
    );
  }
}