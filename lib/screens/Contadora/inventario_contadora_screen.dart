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
  static const verdeFondo = Color(0xFFE3F7E9);
  static const naranja = Color(0xFFC98A1B);
  static const naranjaFondo = Color(0xFFFDF3DA);
  static const rojo = Color(0xFFD64545);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const textoMuted = Color(0xFF8A93A3);
}

class InventarioContadoraScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const InventarioContadoraScreen({super.key, this.usuario});

  @override
  State<InventarioContadoraScreen> createState() =>
      _InventarioContadoraScreenState();
}

class _InventarioContadoraScreenState extends State<InventarioContadoraScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  final InventarioService _service = InventarioService();

  // Filtro rápido (chips) + filtros avanzados (panel colapsable),
  // igual que en la pantalla del Admin.
  String _filtroEstado = 'todos'; // todos | alto | medio | bajo
  String _filtroCategoria = 'todas';
  String _filtroProveedor = 'todos';
  String _filtroUnidad = 'todas';
  bool _filtrosAbiertos = false;

  bool _cargando = false;
  bool _cargandoInicial = true;
  String? _error;

  List<Producto> _productos = [];

  String? _token;

  int get _total => _productos.length;
  int get _totalAlto => _productos.where((p) => p.estado == 'alto').length;
  int get _totalMedio => _productos.where((p) => p.estado == 'medio').length;
  int get _totalBajo => _productos.where((p) => p.estado == 'bajo').length;

  List<String> get _categoriasDisponibles => _productos
      .map((p) => p.nombreCategoria)
      .whereType<String>()
      .toSet()
      .toList()
    ..sort();

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
      final matchCategoria =
          _filtroCategoria == 'todas' || p.nombreCategoria == _filtroCategoria;
      final matchProveedor =
          _filtroProveedor == 'todos' || p.nombreProveedor == _filtroProveedor;
      final matchUnidad = _filtroUnidad == 'todas' || p.unidadMedida == _filtroUnidad;

      return matchTexto && matchEstado && matchCategoria && matchProveedor && matchUnidad;
    }).toList();
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _filtroEstado = 'todos';
      _filtroCategoria = 'todas';
      _filtroProveedor = 'todos';
      _filtroUnidad = 'todas';
    });
  }

  Map<String, Color> _coloresEstado(String estado) {
    switch (estado) {
      case 'alto':
        return {'texto': AppColors.verde, 'fondo': AppColors.verdeFondo};
      case 'medio':
        return {'texto': AppColors.naranja, 'fondo': AppColors.naranjaFondo};
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

  // Detalle en bottom sheet, igual estilo que Admin pero de solo lectura:
  // sin botones de editar/eliminar/stock, solo "Cerrar".
  void _mostrarDetalle(Producto p) {
    final colores = _coloresEstado(p.estado);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                    onPressed: () => Navigator.of(ctx).pop(),
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
                child: const Icon(Icons.inventory_2_outlined, size: 36, color: AppColors.doradoOscuro),
              ),
              _filaDetalle('ID', '#${p.idProducto}'),
              _filaDetalle('Cód. Barras', p.codigoBarras ?? '—'),
              _filaDetalle('Nombre', p.nombreProducto),
              _filaDetalle('Descripción', p.descripcion ?? '—'),
              _filaDetalle('Categoría', p.nombreCategoria ?? 'Sin categoría'),
              _filaDetalle('Proveedor', p.nombreProveedor ?? 'Sin proveedor'),
              _filaDetalle('Unidad', p.unidadMedida ?? '—'),
              _filaDetalle('Precio', _formatoMiles(p.precioActual)),
              _filaDetalle('Stock actual', '${p.stockActual}'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration:
                          BoxDecoration(color: colores['fondo'], borderRadius: BorderRadius.circular(20)),
                      child: Text(_textoEstado(p.estado),
                          style: TextStyle(color: colores['texto'], fontWeight: FontWeight.w600, fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
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
      ),
    );
  }

  Widget _filaDetalle(String label, String valor) {
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
            _buildPanelFiltros(),
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
              // Contadora: solo puede ver el detalle. onEditar y onEliminar
              // van en null para que ProductoCard no muestre esos botones.
              ..._filtrados.map(
                (p) => ProductoCard(
                  producto: p,
                  onVer: () => _mostrarDetalle(p),
                  onEditar: null,
                  onEliminar: null,
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
                const Text(
                  'CONTADORA · INVENTARIO',
                  style: TextStyle(
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
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Solo consulta',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.doradoClaro),
                  ),
                ),
              ],
            ),
          ),
          // Nota: a propósito NO hay botón "Agregar" aquí — Contadora
          // solo puede consultar el inventario, nunca crear ni editar.
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

  // Panel de filtros colapsable, igual que en Admin.
  Widget _buildPanelFiltros() {
    return Container(
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
                hintText: 'Buscar producto o código de barras...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade400),
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.dorado),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
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
                  _dropdownFiltro('Unidad', _filtroUnidad, ['todas', ..._unidadesDisponibles],
                      (v) => setState(() => _filtroUnidad = v!)),
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
    );
  }

  Widget _dropdownFiltro(
    String label,
    String valor,
    List<String> opciones,
    ValueChanged<String?> onChanged,
  ) {
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
              .map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
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
}