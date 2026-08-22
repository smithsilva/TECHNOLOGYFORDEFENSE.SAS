import 'package:flutter/material.dart';
import '../admin/inventario_screen.dart';
import 'categorias_screen.dart';
import 'mantenimientos_screen.dart';
import '../../widgets/mecanico/mecanico_drawer.dart';
import '../../widgets/compartido/inventario_header.dart';

class MecanicoShell extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  /// Se recibe desde main.dart: limpia SharedPreferences y navega al login.
  final VoidCallback? onLogout;

  const MecanicoShell({super.key, this.usuario, this.onLogout});

  @override
  State<MecanicoShell> createState() => _MecanicoShellState();
}

class _MecanicoShellState extends State<MecanicoShell> {
  int _indiceActual = 0; // arranca en "Inventario"

  late final List<Widget> _pantallas = [
    InventarioScreen(usuario: widget.usuario),
    CategoriasScreen(usuario: widget.usuario),
    MantenimientosScreen(usuario: widget.usuario),
  ];

  static const _claves = ['inventario', 'categorias', 'mantenimientos'];
  static const _titulos = ['Inventario', 'Categorías', 'Mantenimientos'];

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
        onLogout: widget.onLogout,
        // onPerfil: se conecta cuando exista la pantalla de Perfil.
      ),
      drawer: MecanicoDrawer(
        usuario: widget.usuario,
        seccionActiva: _claves[_indiceActual],
        onSeleccionar: _irASeccion,
        onLogout: widget.onLogout, // 👈 esta línea era la que faltaba
      ),
      body: IndexedStack(
        index: _indiceActual,
        children: _pantallas,
      ),
    );
  }
}