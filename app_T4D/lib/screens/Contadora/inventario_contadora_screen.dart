import 'package:flutter/material.dart';
import '../../models/producto_contadora.dart';
// import '../../services/inventario_service.dart'; // ← lo conectas cuando pases de mock a Supabase/API real

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const encabezado = Color(0xFF13202E);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const amarillo = Color(0xFFB8860B);
  static const amarilloFondo = Color(0xFFFDF3DA);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const textoMuted = Color(0xFF6B7280);
}

class InventarioContadoraScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const InventarioContadoraScreen({super.key, this.usuario});

  @override
  State<InventarioContadoraScreen> createState() => _InventarioContadoraScreenState();
}

class _InventarioContadoraScreenState extends State<InventarioContadoraScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();

  String _filtroCategoria = 'todas';
  String _filtroProveedor = 'todos';
  String _filtroEstado = 'todos';
  String _filtroUnidad = 'todas';
  String _filtroRol = 'todos';
  bool _filtrosAbiertos = false;
  bool _cargando = false;

  List<ProductoContadora> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Mock. Cuando conectes Supabase, reemplaza por la consulta real
  /// (equivalente a `recargar()` en el componente React de referencia).
  Future<void> _cargarProductos() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _productos = [
        ProductoContadora(
          id: 13,
          codigoBarras: '7501234560013',
          nombre: 'Llantaa',
          descripcion: 'Llanta reforzada 4x4',
          categoria: 'Blindaje Nivel 1',
          nombreProveedor: 'Ferretería Industrial SAS',
          nitProveedor: '900.123.456-7',
          usuario: 'Camilo',
          rolUsuario: 'mecanico',
          unidadMedida: 'Unidad',
          precio: 45000,
          stockActual: 3,
          stockMinimo: 10,
        ),
        ProductoContadora(
          id: 12,
          codigoBarras: '7501234560012',
          nombre: 'Espejo blindado',
          descripcion: 'Espejo lateral con vidrio blindado nivel 2',
          categoria: 'Blindaje Nivel 2',
          nombreProveedor: 'Distribuidora La Costa EU',
          nitProveedor: '901.222.333-1',
          usuario: 'Juan',
          rolUsuario: 'admin',
          unidadMedida: 'Par',
          precio: 70000,
          stockActual: 15,
          stockMinimo: 10,
        ),
        ProductoContadora(
          id: 11,
          codigoBarras: '7501234560011',
          nombre: 'Correa de Distribución',
          categoria: 'Blindaje Nivel 2',
          nombreProveedor: 'Distribuidora La Costa EU',
          nitProveedor: '901.222.333-1',
          usuario: 'Camilo',
          rolUsuario: 'mecanico',
          unidadMedida: 'Unidad',
          precio: 210000,
          stockActual: 15,
          stockMinimo: 10,
        ),
        ProductoContadora(
          id: 10,
          codigoBarras: '7501234560010',
          nombre: 'Kit de Embrague Toyota',
          categoria: 'Blindaje Nivel 1',
          nombreProveedor: 'Comercializadora Andina CA',
          nitProveedor: '890.555.222-9',
          usuario: 'Gisel',
          rolUsuario: 'gerente',
          unidadMedida: 'Kit',
          precio: 780000,
          stockActual: 40,
          stockMinimo: 10,
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

  List<String> get _categoriasDisponibles =>
      _productos.map((p) => p.categoria).toSet().toList()..sort();

  List<String> get _proveedoresDisponibles => _productos
      .map((p) => p.nombreProveedor)
      .whereType<String>()
      .toSet()
      .toList()
    ..sort();

  List<String> get _unidadesDisponibles => _productos
      .map((p) => p.unidadMedida)
      .whereType<String>()
      .toSet()
      .toList()
    ..sort();

  List<ProductoContadora> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    return _productos.where((p) {
      final matchTexto = texto.isEmpty ||
          _normalizar(p.nombre).contains(texto) ||
          _normalizar(p.id.toString()).contains(texto) ||
          _normalizar(p.descripcion ?? '').contains(texto) ||
          _normalizar(p.codigoBarras ?? '').contains(texto);

      final matchCategoria = _filtroCategoria == 'todas' || p.categoria == _filtroCategoria;
      final matchProveedor = _filtroProveedor == 'todos' || p.nombreProveedor == _filtroProveedor;
      final matchEstado = _filtroEstado == 'todos' || p.estado == _filtroEstado;
      final matchUnidad = _filtroUnidad == 'todas' || p.unidadMedida == _filtroUnidad;
      final matchRol = _filtroRol == 'todos' || (p.rolUsuario ?? '') == _filtroRol;

      return matchTexto && matchCategoria && matchProveedor && matchEstado && matchUnidad && matchRol;
    }).toList();
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _filtroCategoria = 'todas';
      _filtroProveedor = 'todos';
      _filtroEstado = 'todos';
      _filtroUnidad = 'todas';
      _filtroRol = 'todos';
    });
  }

  Map<String, Color> _coloresEstado(String estado) {
    switch (estado) {
      case 'alto':
        return {'texto': AppColors.verde, 'fondo': AppColors.verdeFondo};
      case 'medio':
        return {'texto': AppColors.amarillo, 'fondo': AppColors.amarilloFondo};
      default:
        return {'texto': AppColors.rojo, 'fondo': AppColors.rojoFondo};
    }
  }

  String _textoEstado(String estado) {
    switch (estado) {
      case 'alto':
        return 'Stock Alto';
      case 'medio':
        return 'Stock Medio';
      default:
        return 'Stock Bajo';
    }
  }

  String _formatoMiles(num? numero) {
    if (numero == null) return '—';
    final texto = numero.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final posDesdeFinal = texto.length - i;
      buffer.write(texto[i]);
      if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
    }
    return '\$${buffer.toString()}';
  }

  void _verDetalle(ProductoContadora p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _DetalleProductoSheet(
        producto: p,
        colores: _coloresEstado(p.estado),
        textoEstado: _textoEstado(p.estado),
        formatoMiles: _formatoMiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarProductos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Encabezado (sin botón "Agregar": la contadora solo consulta)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.doradoClaro),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gestión de Inventario',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Administra productos de vehículos blindados',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.doradoClaro.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CONTADORA · Solo consulta',
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.doradoOscuro),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Filtros y búsqueda (colapsable)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.doradoClaro),
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => _filtrosAbiertos = !_filtrosAbiertos),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.doradoOscuro),
                          const SizedBox(width: 8),
                          const Text('Filtros y Búsqueda',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const Spacer(),
                          Icon(
                            _filtrosAbiertos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: TextField(
                      controller: _busquedaCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Buscar por producto, código o descripción...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: AppColors.fondo,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  if (_filtrosAbiertos)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _dropdownFiltro('Categoría', _filtroCategoria, ['todas', ..._categoriasDisponibles],
                              (v) => setState(() => _filtroCategoria = v!)),
                          const SizedBox(height: 10),
                          _dropdownFiltro('Proveedor', _filtroProveedor, ['todos', ..._proveedoresDisponibles],
                              (v) => setState(() => _filtroProveedor = v!)),
                          const SizedBox(height: 10),
                          _dropdownFiltro(
                              'Estado', _filtroEstado, ['todos', 'alto', 'medio', 'bajo'],
                              (v) => setState(() => _filtroEstado = v!),
                              etiquetas: {
                                'todos': 'Todos',
                                'alto': 'Stock Alto',
                                'medio': 'Stock Medio',
                                'bajo': 'Stock Bajo',
                              }),
                          const SizedBox(height: 10),
                          _dropdownFiltro('Unidad', _filtroUnidad, ['todas', ..._unidadesDisponibles],
                              (v) => setState(() => _filtroUnidad = v!)),
                          const SizedBox(height: 10),
                          _dropdownFiltro(
                              'Usuario (rol)', _filtroRol,
                              ['todos', 'mecanico', 'admin', 'gerente', 'contadora'],
                              (v) => setState(() => _filtroRol = v!),
                              etiquetas: {
                                'todos': 'Todos',
                                'mecanico': 'Mecánico',
                                'admin': 'Admin',
                                'gerente': 'Gerente',
                                'contadora': 'Contadora',
                              }),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _limpiarFiltros,
                              icon: const Icon(Icons.close, size: 14),
                              label: const Text('Limpiar filtros', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(foregroundColor: AppColors.doradoOscuro),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Text('${_filtrados.length} productos',
                style: const TextStyle(fontSize: 12, color: AppColors.doradoOscuro, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filtrados.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No se encontraron productos', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._filtrados.map((p) => _tarjetaProducto(p)),
          ],
        ),
      ),
    );
  }

  Widget _dropdownFiltro(
    String label,
    String valor,
    List<String> opciones,
    ValueChanged<String?> onChanged, {
    Map<String, String>? etiquetas,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.doradoOscuro)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: valor,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.fondo,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: opciones
              .map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(etiquetas?[o] ?? o, style: const TextStyle(fontSize: 13)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _tarjetaProducto(ProductoContadora p) {
    final colores = _coloresEstado(p.estado);

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
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _verDetalle(p),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '#${p.id}  ',
                          style: const TextStyle(
                              color: AppColors.doradoOscuro, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextSpan(
                          text: p.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: colores['fondo'], borderRadius: BorderRadius.circular(20)),
                  child: Text(_textoEstado(p.estado),
                      style: TextStyle(color: colores['texto'], fontWeight: FontWeight.w600, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${p.categoria} · ${p.nombreProveedor ?? "Sin proveedor"}',
              style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Stock', style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                    Text('${p.stockActual}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colores['texto'])),
                  ],
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Precio', style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                    Text(_formatoMiles(p.precio),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.remove_red_eye_outlined, size: 19, color: Colors.grey.shade700),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Hoja inferior con el detalle completo del producto (equivalente al
/// modal "Detalle del Producto" del componente React).
class _DetalleProductoSheet extends StatelessWidget {
  final ProductoContadora producto;
  final Map<String, Color> colores;
  final String textoEstado;
  final String Function(num?) formatoMiles;

  const _DetalleProductoSheet({
    required this.producto,
    required this.colores,
    required this.textoEstado,
    required this.formatoMiles,
  });

  Widget _fila(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = producto;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Detalle del Producto',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0ECE4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 36, color: Color(0xFF8C6B3F)),
            ),
            _fila('ID', '#${p.id}'),
            _fila('Cód. Barras', p.codigoBarras ?? '—'),
            _fila('Nombre', p.nombre),
            _fila('Descripción', p.descripcion ?? '—'),
            _fila('Categoría', p.categoria),
            _fila('Proveedor', p.nombreProveedor ?? 'Sin proveedor'),
            _fila('NIT', p.nitProveedor ?? '—'),
            _fila('Usuario', p.usuario ?? '—'),
            _fila('Rol', p.rolUsuario ?? '—'),
            _fila('Unidad', p.unidadMedida ?? '—'),
            _fila('Precio', formatoMiles(p.precio)),
            _fila('Stock actual', '${p.stockActual}'),
            _fila('Activo', p.activo ? 'Sí' : 'No'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: colores['fondo'], borderRadius: BorderRadius.circular(20)),
                    child: Text(textoEstado,
                        style: TextStyle(color: colores['texto'], fontWeight: FontWeight.w600, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}