import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_t4d/models/producto.dart';
import 'package:app_t4d/widgets/compartido/producto_card.dart';
import '../../services/inventario_service.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF4F1EA);
  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);
  static const verde = Color(0xFF1F9D55);
  static const naranja = Color(0xFFC98A1B);
  static const rojo = Color(0xFFD64545);
  static const textoMuted = Color(0xFF8A93A3);
}

class InventarioScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const InventarioScreen({super.key, this.usuario});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  final InventarioService _service = InventarioService();

  String _filtroEstado = 'todos'; // todos | alto | medio | bajo
  bool _cargando = false;
  bool _cargandoInicial = true;
  String? _error;

  List<Producto> _productos = [];

  String? _token;
  int? get _idRol => widget.usuario?['id_rol'] as int?;

  bool get _esAdmin => _idRol == 1;
  bool get _esMecanico => _idRol == 4;
  bool get _puedeEditarStock => _esAdmin || _esMecanico;

  String get _rolLabel {
    if (_esAdmin) return 'ADMINISTRADOR';
    if (_esMecanico) return 'MECÁNICO';
    return 'INVENTARIO';
  }

  int get _total => _productos.length;
  int get _totalAlto => _productos.where((p) => p.estado == 'alto').length;
  int get _totalMedio => _productos.where((p) => p.estado == 'medio').length;
  int get _totalBajo => _productos.where((p) => p.estado == 'bajo').length;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    setState(() => _cargandoInicial = false);
    await _cargarProductos();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    if (_token == null) {
      setState(() => _error = 'No hay sesión activa (token no encontrado).');
      return;
    }
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final data = await _service.obtenerProductos(_token!);
      setState(() {
        _productos = data.map((json) => Producto.fromJson(json)).toList();
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
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

  List<Producto> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    return _productos.where((p) {
      final matchTexto = texto.isEmpty ||
          _normalizar(p.nombreProducto).contains(texto) ||
          _normalizar(p.idProducto.toString()).contains(texto) ||
          _normalizar(p.codigoBarras ?? '').contains(texto);
      final matchEstado = _filtroEstado == 'todos' || p.estado == _filtroEstado;
      return matchTexto && matchEstado;
    }).toList();
  }

  void _mostrarSnack(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade600 : null,
      ),
    );
  }

  Future<void> _abrirCrear() async {
    final resultado = await _mostrarFormularioProducto();
    if (resultado == null || _token == null) return;
    try {
      await _service.crearProducto(_token!, resultado);
      _mostrarSnack('Producto creado');
      _cargarProductos();
    } catch (e) {
      _mostrarSnack(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  Future<void> _abrirEdicion(Producto p) async {
    final resultado = await _mostrarFormularioProducto(producto: p);
    if (resultado == null || _token == null) return;
    try {
      await _service.editarProducto(_token!, p.idProducto, resultado);
      _mostrarSnack('Producto actualizado');
      _cargarProductos();
    } catch (e) {
      _mostrarSnack(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  Future<void> _abrirEdicionStock(Producto p) async {
    final ctrl = TextEditingController(text: p.stockActual.toString());
    final nuevoStock = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Actualizar stock — ${p.nombreProducto}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Stock actual'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text)),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevoStock == null || _token == null) return;
    try {
      await _service.actualizarStock(_token!, p.idProducto, nuevoStock);
      _mostrarSnack('Stock actualizado');
      _cargarProductos();
    } catch (e) {
      _mostrarSnack(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  Future<Map<String, dynamic>?> _mostrarFormularioProducto({Producto? producto}) {
    final nombreCtrl = TextEditingController(text: producto?.nombreProducto ?? '');
    final descCtrl = TextEditingController(text: producto?.descripcion ?? '');
    final codigoCtrl = TextEditingController(text: producto?.codigoBarras ?? '');
    final precioCtrl = TextEditingController(text: producto?.precioActual?.toString() ?? '');
    final stockCtrl = TextEditingController(text: producto?.stockActual.toString() ?? '');
    final unidadCtrl = TextEditingController(text: producto?.unidadMedida ?? '');

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(producto == null ? 'Agregar producto' : 'Editar producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
              TextField(controller: codigoCtrl, decoration: const InputDecoration(labelText: 'Código de barras')),
              TextField(controller: precioCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio')),
              TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock')),
              TextField(controller: unidadCtrl, decoration: const InputDecoration(labelText: 'Unidad de medida')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, {
                'nombre_producto': nombreCtrl.text.trim(),
                'descripcion': descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                'codigo_barras': codigoCtrl.text.trim().isEmpty ? null : codigoCtrl.text.trim(),
                'precio_actual': double.tryParse(precioCtrl.text),
                'stock_actual': int.tryParse(stockCtrl.text) ?? 0,
                'unidad_medida': unidadCtrl.text.trim().isEmpty ? null : unidadCtrl.text.trim(),
              });
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(Producto p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que deseas eliminar "${p.nombreProducto}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (_token == null) return;
              try {
                await _service.eliminarProducto(_token!, p.idProducto);
                setState(() => _productos.removeWhere((x) => x.idProducto == p.idProducto));
                _mostrarSnack('Producto eliminado');
              } catch (e) {
                _mostrarSnack(e.toString().replaceFirst('Exception: ', ''), esError: true);
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoInicial) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarProductos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildStats(),
            const SizedBox(height: 14),
            _buildBuscador(),
            const SizedBox(height: 10),
            _buildFiltros(),
            const SizedBox(height: 10),
            Text(
              '$_total ${_total == 1 ? "PRODUCTO" : "PRODUCTOS"}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
                    const SizedBox(height: 8),
                    Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade700)),
                    const SizedBox(height: 8),
                    TextButton(onPressed: _cargarProductos, child: const Text('Reintentar')),
                  ],
                ),
              )
            else if (_cargando)
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
              ..._filtrados.map(
                (p) => ProductoCard(
                  producto: p,
                  onVer: () => _mostrarDetalle(p),
                  onEditar: _esAdmin
                      ? () => _abrirEdicion(p)
                      : (_puedeEditarStock ? () => _abrirEdicionStock(p) : null),
                  onEliminar: _esAdmin ? () => _confirmarEliminar(p) : null,
                ),
              ),
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
                Text(
                  '$_rolLabel · INVENTARIO',
                  style: const TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Gestión de Inventario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Productos de vehículos blindados',
                  style: TextStyle(color: AppColors.subtitulo, fontSize: 12),
                ),
              ],
            ),
          ),
          if (_esAdmin) ...[
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _abrirCrear,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dorado,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _statCard('$_total', 'Total', AppColors.dorado)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('$_totalAlto', 'Alto', AppColors.verde)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('$_totalMedio', 'Medio', AppColors.naranja)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('$_totalBajo', 'Bajo', AppColors.rojo)),
      ],
    );
  }

  Widget _statCard(String valor, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
        children: [
          Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
        ],
      ),
    );
  }

  Widget _buildBuscador() {
    return TextField(
      controller: _busquedaCtrl,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Buscar producto o código de barras...',
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

  Widget _buildFiltros() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chipFiltro('Todos', 'todos', AppColors.dorado),
          _chipFiltro('Alto', 'alto', AppColors.verde),
          _chipFiltro('Medio', 'medio', AppColors.naranja),
          _chipFiltro('Bajo', 'bajo', AppColors.rojo),
        ],
      ),
    );
  }

  Widget _chipFiltro(String label, String valor, Color color) {
    final activo = _filtroEstado == valor;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: activo,
        onSelected: (_) => setState(() => _filtroEstado = valor),
        selectedColor: Colors.white,
        backgroundColor: Colors.white,
        showCheckmark: false,
        labelStyle: TextStyle(
          color: activo ? color : Colors.grey.shade500,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        shape: StadiumBorder(
          side: BorderSide(color: activo ? color : Colors.grey.shade200, width: activo ? 1.4 : 1),
        ),
      ),
    );
  }

  void _mostrarDetalle(Producto p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(p.nombreProducto),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: #${p.idProducto}'),
              Text('Descripción: ${p.descripcion ?? "—"}'),
              Text('Categoría: ${p.nombreCategoria ?? "Sin categoría"}'),
              Text('Proveedor: ${p.nombreProveedor ?? "Sin proveedor"}'),
              Text('Unidad: ${p.unidadMedida ?? "—"}'),
              Text('Precio: ${p.precioActual != null ? "\$${p.precioActual}" : "—"}'),
              Text('Stock actual: ${p.stockActual}'),
              Text('Estado: ${p.estado}'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}