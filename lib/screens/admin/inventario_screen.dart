import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_t4d/models/producto.dart';
import 'package:app_t4d/widgets/compartido/producto_card.dart';
import '../../services/inventario_service.dart';
import '../../models/categoria.dart';
import '../../services/categorias_service.dart';
import '../../models/proveedores_service.dart';
import '../../services/proveedores_service.dart';
import '../../models/sucursal.dart';
import '../../services/sucursales_service.dart';

/// Paleta ajustada para calzar con el panel web (Gestión de Inventario T4D).
class AppColors {
  // Dorado / ámbar — logo, botón "Agregar Producto", acentos e ítem activo
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);

  // Fondo general (crema/beige claro de la página)
  static const fondo = Color(0xFFFAF3E4);

  // Azul marino oscuro — sidebar, headers, textos de títulos
  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);

  // Estado: Stock Alto (verde)
  static const verde = Color(0xFF2E9E5B);
  static const verdeFondo = Color(0xFFDDF2E1);

  // Estado: Stock Medio (dorado/marrón, como el badge tan del panel)
  static const naranja = Color(0xFFA17A2E);
  static const naranjaFondo = Color(0xFFF5E3C3);

  // Estado: Stock Bajo (rojo/rosado)
  static const rojo = Color(0xFFC0293B);
  static const rojoFondo = Color(0xFFFADCE0);

  // Texto secundario / labels
  static const textoMuted = Color(0xFF6B7280);

  // Enlaces (p. ej. categorías clicables, como en la tabla web)
  static const enlace = Color(0xFF2563EB);
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
  final CategoriasService _categoriasService = CategoriasService();
  final ProveedoresService _proveedoresService = ProveedoresService();
  final SucursalesService _sucursalesService = SucursalesService();

  String _filtroEstado = 'todos'; // todos | alto | medio | bajo
  bool _cargando = false;
  bool _cargandoInicial = true;
  String? _error;

  List<Producto> _productos = [];
  List<CategoriaBlindaje> _categoriasActivas = [];
  List<Proveedor> _proveedores = [];
  List<Sucursal> _sucursales = [];

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

  /// Busca el nombre de la categoría de un producto a partir de su id_categoria,
  /// usando la lista de categorías cargada desde la API. Si aún no ha cargado
  /// o no la encuentra, cae en lo que ya traiga el producto (p.nombreCategoria).
  String? _nombreCategoriaDe(Producto p) {
    if (p.idCategoria == null) return p.nombreCategoria;
    for (final c in _categoriasActivas) {
      if (c.id == p.idCategoria) return c.nombre;
    }
    return p.nombreCategoria;
  }

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
    _cargarCategoriasBlindaje(); // no bloqueante
    _cargarProveedores(); // no bloqueante
    _cargarSucursales(); // no bloqueante
  }

  Future<void> _cargarCategoriasBlindaje() async {
    if (_token == null) return;
    try {
      final data = await _categoriasService.obtenerCategorias(_token!);
      setState(() => _categoriasActivas = data.where((c) => c.activa).toList());
    } catch (e) {
      debugPrint('No se pudieron cargar categorías: $e');
    }
  }

  Future<void> _cargarProveedores() async {
    if (_token == null) return;
    try {
      final data = await _proveedoresService.obtenerProveedores(_token!);
      setState(() => _proveedores = data);
    } catch (e) {
      debugPrint('No se pudieron cargar proveedores: $e');
    }
  }

  Future<void> _cargarSucursales() async {
    if (_token == null) return;
    try {
      final data = await _sucursalesService.obtenerSucursales(_token!);
      setState(() => _sucursales = data.where((s) => s.activo).toList());
    } catch (e) {
      debugPrint('No se pudieron cargar sucursales: $e');
    }
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

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'alto':
        return AppColors.verde;
      case 'medio':
        return AppColors.naranja;
      case 'bajo':
        return AppColors.rojo;
      default:
        return AppColors.textoMuted;
    }
  }

  Color _fondoEstado(String estado) {
    switch (estado) {
      case 'alto':
        return AppColors.verdeFondo;
      case 'medio':
        return AppColors.naranjaFondo;
      case 'bajo':
        return AppColors.rojoFondo;
      default:
        return Colors.grey.shade100;
    }
  }

  void _mostrarSnack(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? AppColors.rojo : AppColors.verde,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  // =======================================================================
  // ACTUALIZAR STOCK — diálogo compacto con stepper +/-
  // =======================================================================
  Future<void> _abrirEdicionStock(Producto p) async {
    int valor = p.stockActual;

    final nuevoStock = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.doradoClaro.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, color: AppColors.doradoOscuro, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p.nombreProducto,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  const Text('Actualizar stock', style: TextStyle(fontSize: 12, color: AppColors.textoMuted)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _botonStepper(
                        icono: Icons.remove,
                        onTap: () => setDialogState(() => valor = (valor - 1).clamp(0, 999999)),
                      ),
                      Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.fondo,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.doradoClaro),
                        ),
                        child: Text(
                          '$valor',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.doradoOscuro),
                        ),
                      ),
                      _botonStepper(
                        icono: Icons.add,
                        onTap: () => setDialogState(() => valor = valor + 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dorado,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(ctx, valor),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
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

  Widget _botonStepper({required IconData icono, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.navyOscuro,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icono, color: Colors.white, size: 20),
      ),
    );
  }

  // =======================================================================
  // FORMULARIO CREAR / EDITAR — diseño con secciones y campos redondeados
  // =======================================================================
  Future<Map<String, dynamic>?> _mostrarFormularioProducto({Producto? producto}) {
    final esEdicion = producto != null;
    final nombreCtrl = TextEditingController(text: producto?.nombreProducto ?? '');
    final descCtrl = TextEditingController(text: producto?.descripcion ?? '');
    final codigoCtrl = TextEditingController(text: producto?.codigoBarras ?? '');
    final precioCtrl = TextEditingController(text: producto?.precioActual?.toString() ?? '');
    final stockCtrl = TextEditingController(text: producto?.stockActual.toString() ?? '');
    final unidadCtrl = TextEditingController(text: producto?.unidadMedida ?? '');
    int? categoriaSeleccionada = producto?.idCategoria;
    int? proveedorSeleccionado = producto?.idProveedor;
    int? sucursalSeleccionada = producto?.idSucursal;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header oscuro con icono, igual estilo que el resto de la app
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.navyOscuro, AppColors.navyClaro],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            esEdicion ? Icons.edit_outlined : Icons.add_box_outlined,
                            color: AppColors.dorado,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                esEdicion ? 'Editar producto' : 'Nuevo producto',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                esEdicion
                                    ? 'Actualiza los datos del producto'
                                    : 'Agrega un producto al inventario',
                                style: const TextStyle(color: AppColors.subtitulo, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _campoFormulario(
                          controller: nombreCtrl,
                          label: 'Nombre del producto',
                          icono: Icons.inventory_2_outlined,
                        ),
                        const SizedBox(height: 14),
                        _campoFormulario(
                          controller: descCtrl,
                          label: 'Descripción',
                          icono: Icons.notes_outlined,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 14),

                        // ─── Selector de Tipo de Blindaje (categoría) ───
                        DropdownButtonFormField<int>(
                          initialValue: categoriaSeleccionada,
                          isExpanded: true,
                          decoration: _decoracionDropdown(
                            label: 'Tipo de blindaje',
                            icono: Icons.shield_outlined,
                          ),
                          hint: const Text('Selecciona un tipo de blindaje', style: TextStyle(fontSize: 13)),
                          items: _categoriasActivas
                              .map((c) => DropdownMenuItem<int>(
                                    value: c.id,
                                    child: Text(
                                      c.nombre,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (valor) => setDialogState(() => categoriaSeleccionada = valor),
                        ),
                        if (_categoriasActivas.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'No hay categorías activas disponibles.',
                              style: TextStyle(fontSize: 11, color: AppColors.rojo),
                            ),
                          ),

                        const SizedBox(height: 14),

                        // ─── Selector de Proveedor ───
                        DropdownButtonFormField<int>(
                          initialValue: proveedorSeleccionado,
                          isExpanded: true,
                          decoration: _decoracionDropdown(
                            label: 'Proveedor',
                            icono: Icons.local_shipping_outlined,
                          ),
                          hint: const Text('Selecciona un proveedor', style: TextStyle(fontSize: 13)),
                          items: _proveedores
                              .map((pv) => DropdownMenuItem<int>(
                                    value: pv.id,
                                    child: Text(
                                      pv.nombre,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (valor) => setDialogState(() => proveedorSeleccionado = valor),
                        ),
                        if (_proveedores.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'No hay proveedores disponibles.',
                              style: TextStyle(fontSize: 11, color: AppColors.rojo),
                            ),
                          ),

                        const SizedBox(height: 14),

                        // ─── Selector de Sucursal ───
                        DropdownButtonFormField<int>(
                          initialValue: sucursalSeleccionada,
                          isExpanded: true,
                          decoration: _decoracionDropdown(
                            label: 'Sucursal',
                            icono: Icons.store_outlined,
                          ),
                          hint: const Text('Selecciona una sucursal', style: TextStyle(fontSize: 13)),
                          items: _sucursales
                              .map((s) => DropdownMenuItem<int>(
                                    value: s.id,
                                    child: Text(
                                      s.nombre,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (valor) => setDialogState(() => sucursalSeleccionada = valor),
                        ),
                        if (_sucursales.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'No hay sucursales disponibles.',
                              style: TextStyle(fontSize: 11, color: AppColors.rojo),
                            ),
                          ),

                        const SizedBox(height: 14),
                        _campoFormulario(
                          controller: codigoCtrl,
                          label: 'Código de barras',
                          icono: Icons.qr_code_2_outlined,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _campoFormulario(
                                controller: precioCtrl,
                                label: 'Precio',
                                icono: Icons.attach_money,
                                teclado: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _campoFormulario(
                                controller: stockCtrl,
                                label: 'Stock',
                                icono: Icons.numbers,
                                teclado: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _campoFormulario(
                          controller: unidadCtrl,
                          label: 'Unidad de medida',
                          icono: Icons.straighten_outlined,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancelar', style: TextStyle(color: AppColors.textoMuted)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.dorado,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (nombreCtrl.text.trim().isEmpty) {
                                _mostrarSnack('El nombre es obligatorio', esError: true);
                                return;
                              }
                              Navigator.pop(ctx, {
                                'nombre_producto': nombreCtrl.text.trim(),
                                'descripcion': descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                                'id_categoria': categoriaSeleccionada,
                                'id_proveedor': proveedorSeleccionado,
                                'id_sucursal': sucursalSeleccionada,
                                'codigo_barras':
                                    codigoCtrl.text.trim().isEmpty ? null : codigoCtrl.text.trim(),
                                'precio_actual': double.tryParse(precioCtrl.text),
                                'stock_actual': int.tryParse(stockCtrl.text) ?? 0,
                                'unidad_medida':
                                    unidadCtrl.text.trim().isEmpty ? null : unidadCtrl.text.trim(),
                              });
                            },
                            child: Text(esEdicion ? 'Guardar cambios' : 'Crear producto',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracionDropdown({required String label, required IconData icono}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
      prefixIcon: Icon(icono, size: 19, color: AppColors.doradoOscuro),
      filled: true,
      fillColor: AppColors.fondo.withValues(alpha: 0.6),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
      ),
    );
  }

  Widget _campoFormulario({
    required TextEditingController controller,
    required String label,
    required IconData icono,
    TextInputType? teclado,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
        prefixIcon: Icon(icono, size: 19, color: AppColors.doradoOscuro),
        filled: true,
        fillColor: AppColors.fondo.withValues(alpha: 0.6),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
        ),
      ),
    );
  }

  // =======================================================================
  // CONFIRMAR ELIMINAR — tarjeta de advertencia en rojo
  // =======================================================================
  void _confirmarEliminar(Producto p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.rojoFondo,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline, color: AppColors.rojo, size: 28),
            ),
            const SizedBox(height: 14),
            const Text(
              '¿Eliminar producto?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
                children: [
                  const TextSpan(text: 'Vas a eliminar '),
                  TextSpan(
                    text: '"${p.nombreProducto}"',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const TextSpan(text: '. Esta acción no se puede deshacer.'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        actions: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textoMuted)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rojo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
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
              child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
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

  // =======================================================================
  // VER DETALLE — tarjeta con header oscuro + filas de datos con icono
  // =======================================================================
  void _mostrarDetalle(Producto p) {
    final colorEstado = _colorEstado(p.estado);
    final fondoEstado = _fondoEstado(p.estado);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header oscuro
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.navyOscuro, AppColors.navyClaro],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: AppColors.dorado, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.nombreProducto,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('ID #${p.idProducto}',
                                style: const TextStyle(color: AppColors.subtitulo, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: fondoEstado,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          p.estado.toUpperCase(),
                          style: TextStyle(
                              color: colorEstado, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _filaDetalle(Icons.notes_outlined, 'Descripción', p.descripcion ?? '—'),
                      _filaDetalle(
                          Icons.category_outlined, 'Categoría', _nombreCategoriaDe(p) ?? 'Sin categoría'),
                      _filaDetalle(
                          Icons.local_shipping_outlined, 'Proveedor', p.nombreProveedor ?? 'Sin proveedor'),
                      _filaDetalle(
                          Icons.store_outlined, 'Sucursal', p.nombreSucursal ?? 'Sin sucursal'),
                      _filaDetalle(Icons.qr_code_2_outlined, 'Código de barras', p.codigoBarras ?? '—'),
                      _filaDetalle(Icons.straighten_outlined, 'Unidad de medida', p.unidadMedida ?? '—'),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _cajaDato(
                              titulo: 'Precio',
                              valor: p.precioActual != null ? '\$${p.precioActual}' : '—',
                              color: AppColors.doradoOscuro,
                              icono: Icons.attach_money,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _cajaDato(
                              titulo: 'Stock actual',
                              valor: '${p.stockActual}',
                              color: colorEstado,
                              icono: Icons.inventory_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cerrar', style: TextStyle(color: AppColors.textoMuted)),
                        ),
                      ),
                      if (_esAdmin || _puedeEditarStock) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.dorado,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              if (_esAdmin) {
                                _abrirEdicion(p);
                              } else {
                                _abrirEdicionStock(p);
                              }
                            },
                            child: const Text('Editar', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filaDetalle(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 17, color: AppColors.doradoOscuro),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(titulo, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cajaDato({
    required String titulo,
    required String valor,
    required Color color,
    required IconData icono,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.fondo.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 14, color: color),
              const SizedBox(width: 4),
              Text(titulo, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
            ],
          ),
          const SizedBox(height: 4),
          Text(valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}