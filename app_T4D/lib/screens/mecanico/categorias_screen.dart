import 'package:flutter/material.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navy = Color(0xFF13202E);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const textoMuted = Color(0xFF6B7280);
}

class CategoriaBlindaje {
  final int id;
  final String nombre;
  final bool activa;

  CategoriaBlindaje({required this.id, required this.nombre, required this.activa});
}

class CategoriasScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const CategoriasScreen({super.key, this.usuario});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  bool _cargando = false;
  List<CategoriaBlindaje> _categorias = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  /// Por ahora carga datos de ejemplo (mock).
  /// Cuando conectes el backend, reemplaza por tu servicio real.
  Future<void> _cargarCategorias() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _categorias = [
        CategoriaBlindaje(id: 1, nombre: 'Blindaje Nivel 1', activa: true),
        CategoriaBlindaje(id: 2, nombre: 'Blindaje Nivel 2', activa: true),
        CategoriaBlindaje(id: 3, nombre: 'Blindaje Nivel 3', activa: true),
        CategoriaBlindaje(id: 4, nombre: 'Blindaje Nivel 4', activa: true),
        CategoriaBlindaje(id: 5, nombre: 'Blindaje Nivel 5', activa: true),
      ];
      _cargando = false;
    });
  }

  int get _totalInactivas => _categorias.where((c) => !c.activa).length;

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }

  void _confirmarEliminar(CategoriaBlindaje c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text('¿Seguro que deseas eliminar "${c.nombre}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _categorias.removeWhere((x) => x.id == c.id));
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarCategorias,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Encabezado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.doradoClaro),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Categorías de Blindaje',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Administra las categorías del inventario',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _mostrarProximamente('Nueva categoría'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dorado,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Nueva Categoría'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjetas resumen
            Row(
              children: [
                Expanded(
                  child: _tarjetaEstadistica('Total Categorías', '${_categorias.length}', AppColors.dorado),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaEstadistica('Inactivas', '$_totalInactivas', AppColors.rojo,
                      subtitulo: 'deshabilitadas'),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Text('Categorías registradas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Spacer(),
                Text('${_categorias.length} categorías',
                    style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
              ],
            ),
            const SizedBox(height: 10),

            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_categorias.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.shield_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No hay categorías registradas', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._categorias.map((c) => _tarjetaCategoria(c)),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaEstadistica(String titulo, String valor, Color color, {String? subtitulo}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          if (subtitulo != null) ...[
            const SizedBox(height: 2),
            Text(subtitulo, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ],
      ),
    );
  }

  Widget _tarjetaCategoria(CategoriaBlindaje c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(c.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: c.activa ? AppColors.verdeFondo : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              c.activa ? 'Activa' : 'Inactiva',
              style: TextStyle(
                color: c.activa ? AppColors.verde : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _mostrarProximamente('Editar "${c.nombre}"'),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.doradoOscuro.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.doradoOscuro),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _confirmarEliminar(c),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.rojo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, size: 16, color: AppColors.rojo),
            ),
          ),
        ],
      ),
    );
  }
}