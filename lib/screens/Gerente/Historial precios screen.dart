import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/historial_precio.dart';
import '../../models/producto.dart';
import '../../services/historial_precios_service.dart';

// ==================== COLORES ====================
class AppColors {
  static const background = Color(0xFFF7EFDD);
  static const navy = Color(0xFF101B33);
  static const gold = Color(0xFFC9A24A);
  static const goldDark = Color(0xFF8A6D1F);
  static const goldText = Color(0xFFD2A03C);
  static const lightBlue = Color(0xFF9FB4DE);
  static const inputBg = Color(0xFFEFE4CB);
  static const iconBg = Color(0xFFF0E3BE);
  static const cardBorder = Color(0xFFECE0BD);

  static const green = Color(0xFF2E9E4E);
  static const greenBg = Color(0xFFDCF2E3);
  static const olive = Color(0xFF8B7920);
  static const oliveBg = Color(0xFFF3ECD2);
  static const red = Color(0xFFC24555);
  static const redBg = Color(0xFFF8DCE0);
}

/// Historial de precios.
/// Muestra el historial real de cambios de precio de cada producto. La
/// única acción de edición disponible es "Actualizar precio" de un
/// producto (llama a editarProducto con precioNuevo + motivo), accesible
/// desde el detalle de cada registro. No permite eliminar registros ni
/// editar el nombre del producto.
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
  bool _filtrosExpandidos = true;
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
  int get _totalIniciales => _registros.where((r) => r.tipoVariacion == 'inicial').length;

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

  // Devuelve color, fondo, ícono y texto de la insignia de variación,
  // incluyendo el caso especial de precio inicial (precioAnterior == 0).
  ({Color color, Color fondo, IconData? icono, String texto}) _estiloVariacion(
    HistorialPrecio r,
  ) {
    switch (r.tipoVariacion) {
      case 'aumento':
        return (
          color: AppColors.red,
          fondo: AppColors.redBg,
          icono: Icons.arrow_upward,
          texto: '+${r.variacionPorcentaje!.toStringAsFixed(2)}%',
        );
      case 'reduccion':
        return (
          color: AppColors.green,
          fondo: AppColors.greenBg,
          icono: Icons.arrow_downward,
          texto: '${r.variacionPorcentaje!.toStringAsFixed(2)}%',
        );
      case 'inicial':
        return (
          color: AppColors.navy,
          fondo: AppColors.iconBg,
          icono: null,
          texto: 'Inicial',
        );
      default:
        return (
          color: AppColors.olive,
          fondo: AppColors.oliveBg,
          icono: Icons.remove,
          texto: 'Sin cambio',
        );
    }
  }

  // =======================================================================
  // ACTUALIZAR PRECIO — única acción de edición disponible.
  // Si se llama con un producto preseleccionado (desde una tarjeta del
  // historial), el selector queda fijo en ese producto. Si se llama sin
  // parámetros, se puede elegir cualquier producto de la lista.
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
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.navy,
                            Color.lerp(AppColors.navy, AppColors.lightBlue, 0.18)!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.sell_outlined, color: AppColors.gold, size: 22),
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
                                  style: const TextStyle(color: AppColors.lightBlue, fontSize: 12),
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
                                labelStyle: const TextStyle(fontSize: 13, color: AppColors.olive),
                                prefixIcon: const Icon(Icons.inventory_2_outlined,
                                    size: 19, color: AppColors.goldDark),
                                filled: true,
                                fillColor: AppColors.background,
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
                                  style: TextStyle(fontSize: 11, color: AppColors.red),
                                ),
                              ),
                            const SizedBox(height: 14),
                          ] else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.inventory_2_outlined,
                                      size: 19, color: AppColors.goldDark),
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
                              labelStyle: const TextStyle(fontSize: 13, color: AppColors.olive),
                              prefixIcon: const Icon(Icons.attach_money, size: 19, color: AppColors.goldDark),
                              filled: true,
                              fillColor: AppColors.background,
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
                              labelStyle: const TextStyle(fontSize: 13, color: AppColors.olive),
                              prefixIcon: const Icon(Icons.notes_outlined, size: 19, color: AppColors.goldDark),
                              filled: true,
                              fillColor: AppColors.background,
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
                                side: BorderSide(color: AppColors.cardBorder),
                              ),
                              child: const Text('Cancelar',
                                  style: TextStyle(color: AppColors.olive, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (idSeleccionado == null) {
                                  _mostrarSnack('Selecciona un producto', color: AppColors.red);
                                  return;
                                }
                                if (double.tryParse(precioCtrl.text.trim()) == null) {
                                  _mostrarSnack('El precio no es válido', color: AppColors.red);
                                  return;
                                }
                                if (motivoCtrl.text.trim().isEmpty) {
                                  _mostrarSnack('El motivo es obligatorio', color: AppColors.red);
                                  return;
                                }
                                Navigator.of(ctx).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.navy,
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
      _mostrarSnack('Precio actualizado', color: AppColors.green);
      _cargarRegistros();
      _cargarProductos();
    } catch (e) {
      _mostrarSnack('No se pudo actualizar el precio: $e', color: AppColors.red);
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navy,
            Color.lerp(AppColors.navy, AppColors.lightBlue, 0.18)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.gold, size: 22),
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
                Text(subtitulo, style: const TextStyle(color: AppColors.lightBlue, fontSize: 12)),
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
          Icon(icon, size: 16, color: AppColors.goldDark),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.olive)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cajaStat(String label, String valor, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
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
                  style: const TextStyle(fontSize: 10, color: AppColors.olive, fontWeight: FontWeight.w600),
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
    final estilo = _estiloVariacion(r);

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
              decoration: BoxDecoration(color: estilo.fondo, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (estilo.icono != null) Icon(estilo.icono, size: 11, color: estilo.color),
                  if (estilo.icono != null) const SizedBox(width: 3),
                  Text(estilo.texto,
                      style: TextStyle(color: estilo.color, fontSize: 11, fontWeight: FontWeight.bold)),
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
                Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _cajaStat('Precio Anterior', '\$${_formatoMiles(r.precioAnterior)}',
                          AppColors.gold, Icons.arrow_back),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _cajaStat('Precio Nuevo', '\$${_formatoMiles(r.precioNuevo)}', AppColors.green,
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
                      side: BorderSide(color: AppColors.cardBorder),
                    ),
                    child: const Text('Cerrar',
                        style: TextStyle(color: AppColors.olive, fontWeight: FontWeight.w600)),
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
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.navy,
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
    final rolCrudo = (widget.usuario?['rol'] ?? 'administrador').toString().toLowerCase();

    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        color: AppColors.gold,
        onRefresh: _cargarRegistros,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _encabezado(rolCrudo),
            const SizedBox(height: 14),

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.redBg, borderRadius: BorderRadius.circular(10)),
                child: Text(_error!, style: const TextStyle(color: AppColors.red, fontSize: 13)),
              ),
              const SizedBox(height: 14),
            ],

            Row(
              children: [
                Expanded(child: _tarjetaResumen('Total', '${_registros.length}', AppColors.gold)),
                const SizedBox(width: 8),
                Expanded(child: _tarjetaResumen('Aumentos', '$_totalAumentos', AppColors.red)),
                const SizedBox(width: 8),
                Expanded(child: _tarjetaResumen('Reduc.', '$_totalReducciones', AppColors.green)),
                const SizedBox(width: 8),
                Expanded(child: _tarjetaResumen('Iniciales', '$_totalIniciales', AppColors.navy)),
              ],
            ),
            const SizedBox(height: 14),

            _panelFiltros(),
            const SizedBox(height: 16),

            _separadorConteo(_filtrados.length),
            const SizedBox(height: 12),

            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
              )
            else if (_filtrados.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 40, color: AppColors.goldDark.withValues(alpha: 0.5)),
                      const SizedBox(height: 8),
                      const Text('No se encontraron registros', style: TextStyle(color: AppColors.olive)),
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

  Widget _encabezado(String rolCrudo) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navy,
            Color.lerp(AppColors.navy, AppColors.lightBlue, 0.18)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${rolCrudo.toUpperCase()} · PRECIOS',
            style: const TextStyle(
              color: AppColors.goldText,
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
            'Rastrea y analiza cada cambio de precio',
            style: TextStyle(color: AppColors.lightBlue, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _panelFiltros() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 0.6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _filtrosExpandidos = !_filtrosExpandidos;
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.gold),
                  const SizedBox(width: 6),
                  const Text(
                    'Filtros y Búsqueda',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
                  ),
                  const Spacer(),
                  Icon(
                    _filtrosExpandidos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.goldDark,
                  ),
                ],
              ),
            ),

            if (_filtrosExpandidos) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _busquedaCtrl,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: AppColors.navy, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar por producto, ID o motivo...',
                  hintStyle: TextStyle(color: AppColors.navy.withValues(alpha: 0.45), fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 20, color: AppColors.navy.withValues(alpha: 0.45)),
                  filled: true,
                  // CAMBIO: fondo del buscador más claro para que se note mejor el texto/ícono
                  fillColor: Color.lerp(AppColors.inputBg, Colors.white, 0.85),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.gold),
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
                        side: const BorderSide(color: AppColors.cardBorder),
                      ),
                      icon: const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.goldDark),
                      label: Text(
                        _fechaFiltro == null ? 'Filtrar por fecha' : _formatoFechaLarga(_fechaFiltro!),
                        style: const TextStyle(fontSize: 12, color: AppColors.goldDark),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _limpiarFiltros,
                    icon: const Icon(Icons.close, size: 14),
                    label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.olive),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tarjetaResumen(String titulo, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        children: [
          Text(valor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(
            titulo,
            style: const TextStyle(fontSize: 10, color: AppColors.olive),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _separadorConteo(int cantidad) {
    return Center(
      child: Text(
        '$cantidad ${cantidad == 1 ? 'REGISTRO' : 'REGISTROS'}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.olive,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _tarjetaRegistro(HistorialPrecio r) {
    final estilo = _estiloVariacion(r);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _verDetalle(r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: Border.all(color: AppColors.cardBorder, width: 0.6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: estilo.color),
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
                                  style: const TextStyle(fontSize: 14, color: AppColors.navy),
                                  children: [
                                    TextSpan(
                                      text: '#${r.id}  ',
                                      style: const TextStyle(
                                          color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: r.nombreProducto,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.navy),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _accionBoton(
                              Icons.remove_red_eye_outlined,
                              AppColors.navy,
                              Color.lerp(AppColors.lightBlue, Colors.white, 0.55)!,
                              () => _verDetalle(r),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID Prod: ${r.idProducto} · ${_formatoFechaLarga(r.fecha)}',
                          style: const TextStyle(fontSize: 11, color: AppColors.olive),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            // CAMBIO: fondo blanco (antes AppColors.background) + borde sutil
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.cardBorder, width: 0.6),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Anterior',
                                        style: TextStyle(fontSize: 9, color: AppColors.olive)),
                                    Text(
                                      '\$${_formatoMiles(r.precioAnterior)}',
                                      style: const TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.gold),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward, size: 14, color: AppColors.gold),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Nuevo',
                                        style: TextStyle(fontSize: 9, color: AppColors.olive)),
                                    Text(
                                      '\$${_formatoMiles(r.precioNuevo)}',
                                      style: const TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Variación',
                                        style: TextStyle(fontSize: 9, color: AppColors.olive)),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: estilo.fondo, borderRadius: BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (estilo.icono != null)
                                            Icon(estilo.icono, size: 10, color: estilo.color),
                                          if (estilo.icono != null) const SizedBox(width: 2),
                                          Text(
                                            estilo.texto,
                                            style: TextStyle(
                                                color: estilo.color, fontWeight: FontWeight.w600, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (r.motivo.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            r.motivo,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.olive, fontStyle: FontStyle.italic),
                          ),
                        ],
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
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}