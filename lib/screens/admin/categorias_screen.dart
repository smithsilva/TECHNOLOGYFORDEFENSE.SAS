import 'package:flutter/material.dart';

// ─── Paleta (igual a Inventario / Movimientos) ────────────────────────────
class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const textoMuted = Color(0xFF6B7280);
}

class CategoriaBlindaje {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final bool activa;

  CategoriaBlindaje({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.activa,
  });
}

class CategoriasScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const CategoriasScreen({super.key, this.usuario});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();

  bool _cargando = false;
  List<CategoriaBlindaje> _categorias = [];

  int? get _idRol => widget.usuario?['id_rol'] as int?;
  bool get _esAdmin => _idRol == 1;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Por ahora carga datos de ejemplo (mock) para validar el diseño.
  /// Cuando conectemos el backend, esto se reemplaza por una llamada
  /// a CategoriasService, ej:
  ///
  /// final data = await CategoriasService().obtenerCategorias(token);
  /// setState(() => _categorias = data.map(CategoriaBlindaje.fromJson).toList());
  Future<void> _cargarCategorias() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _categorias = [
        CategoriaBlindaje(
          id: 1,
          codigo: 'CAT-001',
          nombre: 'Blindaje Nivel 1',
          descripcion: 'Protección balística ligera para vehículos blindados',
          activa: true,
        ),
        CategoriaBlindaje(
          id: 2,
          codigo: 'CAT-002',
          nombre: 'Blindaje Nivel 2',
          descripcion: 'Protección balística media, uso estándar',
          activa: true,
        ),
        CategoriaBlindaje(
          id: 3,
          codigo: 'CAT-003',
          nombre: 'Blindaje Nivel 3',
          descripcion: 'Protección balística alta para escoltas',
          activa: true,
        ),
        CategoriaBlindaje(
          id: 4,
          codigo: 'CAT-004',
          nombre: 'Blindaje Nivel 4',
          descripcion: 'Protección balística reforzada',
          activa: false,
        ),
        CategoriaBlindaje(
          id: 5,
          codigo: 'CAT-005',
          nombre: 'Blindaje Nivel 5',
          descripcion: 'Máxima protección balística disponible',
          activa: true,
        ),
      ];
      _cargando = false;
    });
  }

  String _normalizar(String texto) {
    const conTilde = 'áàäâéèëêíìïîóòöôúùüû';
    const sinTilde = 'aaaaeeeeiiiioooouuuu';
    var resultado = texto.toLowerCase();
    for (var i = 0; i < conTilde.length; i++) {
      resultado = resultado.replaceAll(conTilde[i], sinTilde[i]);
    }
    return resultado;
  }

  List<CategoriaBlindaje> get _filtradas {
    final texto = _normalizar(_busquedaCtrl.text);
    if (texto.isEmpty) return _categorias;
    return _categorias.where((c) {
      return _normalizar(c.nombre).contains(texto) ||
          _normalizar(c.descripcion).contains(texto) ||
          _normalizar(c.codigo).contains(texto);
    }).toList();
  }

  int get _totalActivas => _categorias.where((c) => c.activa).length;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Seguro que deseas eliminar "${c.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _categorias.removeWhere((x) => x.id == c.id));
              _mostrarProximamente('Eliminar "${c.nombre}"');
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
            _buildHeader(),
            const SizedBox(height: 14),
            _buildStats(),
            const SizedBox(height: 14),
            _buildBuscador(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Categorías Registradas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${_filtradas.length} categoría${_filtradas.length != 1 ? "s" : ""}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filtradas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.shield_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'No se encontraron categorías',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._filtradas.map((c) => _tarjetaCategoria(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navyOscuro, AppColors.navyClaro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CATEGORÍAS · BLINDAJE',
                  style: TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Categorías de Blindaje',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestión de niveles de protección balística',
                  style: TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                ),
              ],
            ),
          ),
          if (_esAdmin) ...[
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => _mostrarProximamente('Nueva categoría'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dorado,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Nueva', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            '${_categorias.length}',
            'Total Categorías',
            'niveles registrados',
            AppColors.dorado,
            Icons.shield_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            '$_totalActivas',
            'Activas',
            'en uso',
            AppColors.verde,
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            '$_totalInactivas',
            'Inactivas',
            'deshabilitadas',
            AppColors.rojo,
            Icons.cancel_outlined,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String valor, String label, String sublabel, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textoMuted, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(sublabel, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
        ],
      ),
    );
  }

  Widget _buildBuscador() {
    return TextField(
      controller: _busquedaCtrl,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Buscar categoría...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.dorado),
        ),
      ),
    );
  }

  Widget _tarjetaCategoria(CategoriaBlindaje c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                c.codigo,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.doradoOscuro,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c.activa ? AppColors.verdeFondo : AppColors.rojoFondo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      c.activa ? Icons.check_circle : Icons.cancel,
                      size: 11,
                      color: c.activa ? AppColors.verde : AppColors.rojo,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      c.activa ? 'Activa' : 'Inactiva',
                      style: TextStyle(
                        color: c.activa ? AppColors.verde : AppColors.rojo,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: AppColors.fondo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.shield, size: 17, color: AppColors.doradoOscuro),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c.descripcion,
                      style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_esAdmin) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _mostrarProximamente('Editar "${c.nombre}"'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.doradoOscuro.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 14, color: AppColors.doradoOscuro),
                        SizedBox(width: 4),
                        Text('Editar',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.doradoOscuro,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _confirmarEliminar(c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.rojo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, size: 14, color: AppColors.rojo),
                        SizedBox(width: 4),
                        Text('Eliminar',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.rojo,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}