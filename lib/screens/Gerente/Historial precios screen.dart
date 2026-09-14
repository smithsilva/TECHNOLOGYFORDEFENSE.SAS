import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/historial_precio.dart';
import '../../models/producto.dart';
import '../../services/historial_precios_service.dart';

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
  static const gris = Color(0xFF6B7280);
  static const grisFondo = Color(0xFFF0F0F0);
  static const textoMuted = Color(0xFF6B7280);
}

/// Historial de precios para el GERENTE.
/// Ve el mismo historial real que el admin, pero su única acción posible es
/// "Actualizar precio" de un producto (llama a editarProducto con
/// precioNuevo + motivo). No puede eliminar registros ni editar el nombre
/// del producto.
class HistorialPreciosScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const HistorialPreciosScreen({super.key, this.usuario});

  @override
  State<HistorialPreciosScreen> createState() => _HistorialPreciosScreenState();
}

class _HistorialPreciosScreenState extends State<HistorialPreciosScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  final HistorialPreciosService _service = HistorialPreciosService();

  DateTime? _fechaFiltro;
  bool _cargando = false;
  String? _error;

  List<HistorialPrecio> _registros = [];
  List<Producto> _productosDisponibles = [];

  Future<String?> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _cargarRegistros();
    _cargarProductos(); // no bloqueante, para el selector del formulario
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarRegistros() async {
    final token = await _obtenerToken();

    if (token == null || token.isEmpty) {
      setState(() {
        _error = 'No se encontró el token de sesión. Vuelve a iniciar sesión.';
        _cargando = false;
      });
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final data = await _service.obtenerHistorial(token);
      if (!mounted) return;
      setState(() {
        _registros = data;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar el historial: $e';
        _cargando = false;
      });
    }
  }

  Future<void> _cargarProductos() async {
    final token = await _obtenerToken();
    if (token == null) return;
    try {
      final data = await _service.obtenerProductos(token);
      if (!mounted) return;
      setState(() => _productosDisponibles = data);
    } catch (e) {
      debugPrint('No se pudieron cargar productos: $e');
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

  List<HistorialPrecio> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    return _registros.where((r) {
      final matchTexto = texto.isEmpty ||
          _normalizar(r.nombreProducto).contains(texto) ||
          _normalizar(r.idProducto.toString()).contains(texto) ||
          _normalizar(r.motivo).contains(texto);
      final matchFecha = _fechaFiltro == null ||
          (r.fecha.year == _fechaFiltro!.year &&
              r.fecha.month == _fechaFiltro!.month &&
              r.fecha.day == _fechaFiltro!.day);
      return matchTexto && matchFecha;
    }).toList();
  }

  int get _totalAumentos => _registros.where((r) => r.tipoVariacion == 'aumento').length;
  int get _totalReducciones => _registros.where((r) => r.tipoVariacion == 'reduccion').length;
  int get _totalSinCambio => _registros.where((r) => r.tipoVariacion == 'sin_cambio').length;

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _fechaFiltro = null;
    });
  }

  Future<void> _elegirFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaFiltro ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (seleccionada != null) {
      setState(() => _fechaFiltro = seleccionada);
    }
  }

  String _formatoMiles(num numero) {
    final texto = numero.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final posDesdeFinal = texto.length - i;
      buffer.write(texto[i]);
      if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  String _formatoFechaLarga(DateTime f) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${f.day} de ${meses[f.month - 1]} de ${f.year}';
  }

  void _mostrarSnack(String texto, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =======================================================================
  // ACTUALIZAR PRECIO — única acción disponible para el gerente.
  // Si se llama con un producto preseleccionado (desde una tarjeta del
  // historial), el selector queda fijo en ese producto. Si se llama desde
  // el botón del encabezado, el gerente elige cualquier producto de la
  // lista.
  // =======================================================================
  Future<void> _abrirCambioPrecio({
    int? idPreseleccionado,
    String? nombrePreseleccionado,
    double? precioActualPreseleccionado,
  }) async {
    int? idSeleccionado = idPreseleccionado;
    String? nombreSeleccionado = nombrePreseleccionado;
    final precioCtrl = TextEditingController(
      text: precioActualPreseleccionado != null ? precioActualPreseleccionado.toStringAsFixed(0) : '',
    );
    final motivoCtrl = TextEditingController();
    final esFijo = idPreseleccionado != null;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
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
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.dorado.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.sell_outlined, color: AppColors.dorado, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Actualizar precio',
                                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  esFijo
                                      ? nombreSeleccionado ?? ''
                                      : 'Elige un producto y su nuevo precio',
                                  style: const TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!esFijo) ...[
                            DropdownButtonFormField<int>(
                              initialValue: idSeleccionado,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Producto',
                                labelStyle: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
                                prefixIcon: const Icon(Icons.inventory_2_outlined,
                                    size: 19, color: AppColors.doradoOscuro),
                                filled: true,
                                fillColor: AppColors.fondo,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text('Selecciona un producto', style: TextStyle(fontSize: 13)),
                              items: _productosDisponibles
                                  .map((p) => DropdownMenuItem<int>(
                                        value: p.idProducto,
                                        child: Text(
                                          p.nombreProducto,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (valor) {
                                final prod = _productosDisponibles.firstWhere((p) => p.idProducto == valor);
                                setDialogState(() {
                                  idSeleccionado = valor;
                                  nombreSeleccionado = prod.nombreProducto;
                                  if (prod.precioActual != null) {
                                    precioCtrl.text = prod.precioActual!.toStringAsFixed(0);
                                  }
                                });
                              },
                            ),
                            if (_productosDisponibles.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 6, left: 4),
                                child: Text(
                                  'No hay productos disponibles.',
                                  style: TextStyle(fontSize: 11, color: AppColors.rojo),
                                ),
                              ),
                            const SizedBox(height: 14),
                          ] else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: AppColors.fondo,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.inventory_2_outlined,
                                      size: 19, color: AppColors.doradoOscuro),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      nombreSeleccionado ?? '',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          TextField(
                            controller: precioCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: 'Precio nuevo',
                              labelStyle: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
                              prefixIcon: const Icon(Icons.attach_money, size: 19, color: AppColors.doradoOscuro),
                              filled: true,
                              fillColor: AppColors.fondo,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: motivoCtrl,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: 'Motivo del cambio',
                              labelStyle: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
                              prefixIcon: const Icon(Icons.notes_outlined, size: 19, color: AppColors.doradoOscuro),
                              filled: true,
                              fillColor: AppColors.fondo,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: const Text('Cancelar',
                                  style: TextStyle(color: AppColors.textoMuted, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (idSeleccionado == null) {
                                  _mostrarSnack('Selecciona un producto', color: AppColors.rojo);
                                  return;
                                }
                                if (double.tryParse(precioCtrl.text.trim()) == null) {
                                  _mostrarSnack('El precio no es válido', color: AppColors.rojo);
                                  return;
                                }
                                if (motivoCtrl.text.trim().isEmpty) {
                                  _mostrarSnack('El motivo es obligatorio', color: AppColors.rojo);
                                  return;
                                }
                                Navigator.of(ctx).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.dorado,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
    );

    if (confirmar != true || idSeleccionado == null) return;

    final token = await _obtenerToken();
    if (token == null) return;

    try {
      await _service.editarProducto(
        token,
        idSeleccionado!,
        precioNuevo: double.parse(precioCtrl.text.trim()),
        motivo: motivoCtrl.text.trim(),
      );
      _mostrarSnack('Precio actualizado', color: AppColors.verde);
      _cargarRegistros();
      _cargarProductos();
    } catch (e) {
      _mostrarSnack('No se pudo actualizar el precio: $e', color: AppColors.rojo);
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // ─── HELPERS DE DISEÑO PARA EL MODAL DE DETALLE ────────────────────────
  // ══════════════════════════════════════════════════════════════════════

  Future<T?> _mostrarDialogoBase<T>({required Widget child}) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }

  Widget _headerDialogo({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.dorado.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.dorado, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 3),
                Text(subtitulo, style: const TextStyle(color: Color(0xFF8FA3C4), fontSize: 12)),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _filaDetalleIcono(IconData icon, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.doradoOscuro),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
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

  Widget _cajaStat(String label, String valor, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(color: AppColors.fondo, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
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
          Text(
            valor,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // DIÁLOGO: VER DETALLE — solo "Cerrar" y "Editar precio".
  // =======================================================================
  void _verDetalle(HistorialPrecio r) {
    final tipo = r.tipoVariacion;
    Color colorVariacion;
    Color fondoVariacion;
    String textoVariacion;
    IconData iconoVariacion;

    if (tipo == 'aumento') {
      colorVariacion = AppColors.rojo;
      fondoVariacion = AppColors.rojoFondo;
      iconoVariacion = Icons.arrow_upward;
      textoVariacion = '+${r.variacionPorcentaje!.toStringAsFixed(2)}%';
    } else if (tipo == 'reduccion') {
      colorVariacion = AppColors.verde;
      fondoVariacion = AppColors.verdeFondo;
      iconoVariacion = Icons.arrow_downward;
      textoVariacion = '${r.variacionPorcentaje!.toStringAsFixed(2)}%';
    } else {
      colorVariacion = AppColors.gris;
      fondoVariacion = AppColors.grisFondo;
      iconoVariacion = Icons.remove;
      textoVariacion = 'Sin cambio';
    }

    _mostrarDialogoBase(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerDialogo(
            icon: Icons.history,
            titulo: r.nombreProducto,
            subtitulo: '#${r.id} · ID Producto ${r.idProducto}',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: fondoVariacion, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconoVariacion, size: 11, color: colorVariacion),
                  const SizedBox(width: 3),
                  Text(textoVariacion,
                      style: TextStyle(color: colorVariacion, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Column(
              children: [
                _filaDetalleIcono(Icons.calendar_today_outlined, 'Fecha', _formatoFechaLarga(r.fecha)),
                _filaDetalleIcono(Icons.check_circle_outline, 'Estado', r.activo ? 'Activo' : 'Inactivo'),
                _filaDetalleIcono(
                  Icons.notes_outlined,
                  'Motivo',
                  r.motivo.isEmpty ? 'Sin motivo registrado' : r.motivo,
                ),
                const SizedBox(height: 6),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _cajaStat('Precio Anterior', '\$${_formatoMiles(r.precioAnterior)}',
                          AppColors.dorado, Icons.arrow_back),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _cajaStat('Precio Nuevo', '\$${_formatoMiles(r.precioNuevo)}', AppColors.verde,
                          Icons.arrow_forward),
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
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cerrar',
                        style: TextStyle(color: AppColors.textoMuted, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _abrirCambioPrecio(
                        idPreseleccionado: r.idProducto,
                        nombrePreseleccionado: r.nombreProducto,
                        precioActualPreseleccionado: r.precioActual,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dorado,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Editar precio', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
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
        onRefresh: _cargarRegistros,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _encabezado(),
            const SizedBox(height: 14),

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.rojoFondo, borderRadius: BorderRadius.circular(10)),
                child: Text(_error!, style: const TextStyle(color: AppColors.rojo, fontSize: 13)),
              ),
              const SizedBox(height: 14),
            ],

            Row(
              children: [
                Expanded(child: _tarjetaResumen('Total', '${_registros.length}', AppColors.dorado)),
                const SizedBox(width: 10),
                Expanded(child: _tarjetaResumen('Aumentos', '$_totalAumentos', AppColors.rojo)),
                const SizedBox(width: 10),
                Expanded(child: _tarjetaResumen('Reduc.', '$_totalReducciones', AppColors.verde)),
                const SizedBox(width: 10),
                Expanded(child: _tarjetaResumen('Sin cambio', '$_totalSinCambio', AppColors.gris)),
              ],
            ),
            const SizedBox(height: 14),

            _buscador(),
            const SizedBox(height: 18),

            _separadorConteo(_filtrados.length),
            const SizedBox(height: 12),

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
                      Icon(Icons.history, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No se encontraron registros', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._filtrados.map((r) => _tarjetaRegistro(r)),
          ],
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1B2E), Color(0xFF16233A)],
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
                  'GERENTE · HISTORIAL DE PRECIOS',
                  style: TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Historial de Precios',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Actualiza el precio de tus productos',
                  style: TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () => _abrirCambioPrecio(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dorado,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            icon: const Icon(Icons.sell_outlined, size: 16),
            label: const Text('Actualizar precio', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buscador() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _busquedaCtrl,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Buscar por producto, ID o motivo...',
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
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _elegirFecha,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(color: AppColors.doradoClaro),
                ),
                icon: const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.doradoOscuro),
                label: Text(
                  _fechaFiltro == null ? 'Filtrar por fecha' : _formatoFechaLarga(_fechaFiltro!),
                  style: const TextStyle(fontSize: 12, color: AppColors.doradoOscuro),
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _limpiarFiltros,
              icon: const Icon(Icons.close, size: 14),
              label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(foregroundColor: AppColors.textoMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tarjetaResumen(String titulo, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(titulo, style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
        ],
      ),
    );
  }

  Widget _separadorConteo(int cantidad) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.verde.withValues(alpha: 0.4), thickness: 1.2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$cantidad ${cantidad == 1 ? 'REGISTRO' : 'REGISTROS'}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textoMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.verde.withValues(alpha: 0.4), thickness: 1.2)),
      ],
    );
  }

  Widget _tarjetaRegistro(HistorialPrecio r) {
    final tipo = r.tipoVariacion;
    Color colorVariacion;
    Color fondoVariacion;
    String textoVariacion;
    IconData? iconoVariacion;

    if (tipo == 'aumento') {
      colorVariacion = AppColors.rojo;
      fondoVariacion = AppColors.rojoFondo;
      iconoVariacion = Icons.arrow_upward;
      textoVariacion = '+${r.variacionPorcentaje!.toStringAsFixed(2)}%';
    } else if (tipo == 'reduccion') {
      colorVariacion = AppColors.verde;
      fondoVariacion = AppColors.verdeFondo;
      iconoVariacion = Icons.arrow_downward;
      textoVariacion = '${r.variacionPorcentaje!.toStringAsFixed(2)}%';
    } else {
      colorVariacion = AppColors.gris;
      fondoVariacion = AppColors.grisFondo;
      iconoVariacion = null;
      textoVariacion = 'Sin cambio';
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _verDetalle(r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: colorVariacion),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
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
                                      text: '#${r.id}  ',
                                      style: const TextStyle(
                                          color: AppColors.doradoOscuro, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: r.nombreProducto,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _accionBoton(
                              Icons.remove_red_eye_outlined,
                              AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD),
                              () => _verDetalle(r),
                            ),
                            const SizedBox(width: 8),
                            // Única acción de edición del gerente: cambiar precio.
                            _accionBoton(
                              Icons.sell_outlined,
                              AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD),
                              () => _abrirCambioPrecio(
                                idPreseleccionado: r.idProducto,
                                nombrePreseleccionado: r.nombreProducto,
                                precioActualPreseleccionado: r.precioActual,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'ID: ${r.idProducto} · Actual: \$${_formatoMiles(r.precioActual)}  ',
                              style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                            ),
                            if (r.activo)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration:
                                    BoxDecoration(color: AppColors.verdeFondo, borderRadius: BorderRadius.circular(20)),
                                child: const Text(
                                  'Activo',
                                  style: TextStyle(color: AppColors.verde, fontWeight: FontWeight.w600, fontSize: 10),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Precio Anterior', style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                                  Text(
                                    '\$${_formatoMiles(r.precioAnterior)}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.dorado),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward, size: 16, color: AppColors.textoMuted),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Precio Nuevo', style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                                  Text(
                                    '\$${_formatoMiles(r.precioNuevo)}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.verde),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Variación', style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration:
                                      BoxDecoration(color: fondoVariacion, borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (iconoVariacion != null) Icon(iconoVariacion, size: 11, color: colorVariacion),
                                      if (iconoVariacion != null) const SizedBox(width: 2),
                                      Text(
                                        textoVariacion,
                                        style:
                                            TextStyle(color: colorVariacion, fontWeight: FontWeight.w600, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                if (tipo != 'sin_cambio')
                                  Text(
                                    '${r.variacionAbsoluta > 0 ? '+' : ''}\$${_formatoMiles(r.variacionAbsoluta)}',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textoMuted),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(_formatoFechaLarga(r.fecha), style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                r.motivo,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 11, color: AppColors.textoMuted, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accionBoton(IconData icon, Color color, Color fondo, VoidCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}