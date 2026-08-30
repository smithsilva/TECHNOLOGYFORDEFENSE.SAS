import 'package:flutter/material.dart';
import '../../models/historial_precio.dart';
import '../../services//historial_precios_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const gris = Color(0xFF6B7280);
  static const grisFondo = Color(0xFFF0F0F0);
  static const textoMuted = Color(0xFF6B7280);
}

class HistorialPreciosScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const HistorialPreciosScreen({super.key, this.usuario});

  @override
  State<HistorialPreciosScreen> createState() => _HistorialPreciosScreenState();
}

class _HistorialPreciosScreenState extends State<HistorialPreciosScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();

  DateTime? _fechaFiltro;
  bool _cargando = false;
  bool _filtrosAbiertos = true;

  List<HistorialPrecio> _registros = [];

  @override
  void initState() {
    super.initState();
    _cargarRegistros();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Por ahora carga datos de ejemplo (mock) para la parte visual.
  /// Cuando conectes el backend, reemplaza el contenido de este método
  /// por una llamada a tu HistorialPreciosService, por ejemplo:
  ///
  /// final data = await HistorialPreciosService().obtenerHistorial();
  /// setState(() => _registros = data);
  Future<void> _cargarRegistros() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _registros = [
        HistorialPrecio(
          id: 13,
          idProducto: 13,
          nombreProducto: 'Llantaa',
          precioActual: 45000,
          activo: true,
          precioAnterior: 350000,
          precioNuevo: 45000,
          fecha: DateTime(2026, 7, 2),
          motivo: 'se cambio el precio',
        ),
        HistorialPrecio(
          id: 12,
          idProducto: 13,
          nombreProducto: 'Llantaa',
          precioActual: 45000,
          activo: true,
          precioAnterior: 0,
          precioNuevo: 350000,
          fecha: DateTime(2026, 7, 2),
          motivo: 'Precio inicial al crear producto',
        ),
        HistorialPrecio(
          id: 11,
          idProducto: 11,
          nombreProducto: 'Correa de Distribución',
          precioActual: 210000,
          activo: true,
          precioAnterior: 0,
          precioNuevo: 210000,
          fecha: DateTime(2026, 6, 25),
          motivo: 'Precio inicial al crear producto',
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

  int get _totalAumentos =>
      _registros.where((r) => r.tipoVariacion == 'aumento').length;
  int get _totalReducciones =>
      _registros.where((r) => r.tipoVariacion == 'reduccion').length;
  int get _totalSinCambio =>
      _registros.where((r) => r.tipoVariacion == 'sin_cambio').length;

  /// Catálogo derivado de los registros: último precio conocido por producto.
  /// Se usa para autocompletar "precio anterior" al crear un registro nuevo.
  List<Map<String, dynamic>> get _catalogoProductos {
    final mapa = <int, Map<String, dynamic>>{};
    for (final r in _registros) {
      final actual = mapa[r.idProducto];
      if (actual == null || r.fecha.isAfter(actual['fecha'] as DateTime)) {
        mapa[r.idProducto] = {
          'id': r.idProducto,
          'nombre': r.nombreProducto,
          'precioActual': r.precioNuevo,
          'fecha': r.fecha,
        };
      }
    }
    final lista = mapa.values.toList()
      ..sort((a, b) => (a['nombre'] as String).compareTo(b['nombre'] as String));
    return lista;
  }

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
  // CRUD (mock, solo en memoria — reemplazar por llamadas reales al backend)
  // =======================================================================

  void _crear(HistorialPrecio nuevo) {
    setState(() => _registros.insert(0, nuevo));
    _mostrarSnack('Registro creado (mock)', color: AppColors.verde);
  }

  void _actualizar(HistorialPrecio editado) {
    setState(() {
      final idx = _registros.indexWhere((r) => r.id == editado.id);
      if (idx != -1) _registros[idx] = editado;
    });
    _mostrarSnack('Registro actualizado (mock)', color: AppColors.dorado);
  }

  void _eliminar(HistorialPrecio r) {
    setState(() => _registros.removeWhere((x) => x.id == r.id));
    _mostrarSnack('Registro eliminado (mock)', color: AppColors.rojo);
  }

  // =======================================================================
  // DIÁLOGO: VER DETALLE
  // =======================================================================
  void _verDetalle(HistorialPrecio r, bool esSoloLectura) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  r.nombreProducto,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.fondo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('#${r.id}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.doradoOscuro, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filaDetalle('ID Producto', '${r.idProducto}'),
              _filaDetalle('Precio anterior', '\$${_formatoMiles(r.precioAnterior)}'),
              _filaDetalle('Precio nuevo', '\$${_formatoMiles(r.precioNuevo)}'),
              _filaDetalle('Variación',
                  r.variacionPorcentaje == null ? 'Sin cambio' : '${r.variacionPorcentaje!.toStringAsFixed(1)}%'),
              _filaDetalle('Fecha', _formatoFechaLarga(r.fecha)),
              _filaDetalle('Estado', r.activo ? 'Activo' : 'Inactivo'),
              const SizedBox(height: 6),
              const Text('Motivo', style: TextStyle(fontSize: 11, color: AppColors.textoMuted)),
              const SizedBox(height: 2),
              Text(r.motivo, style: const TextStyle(fontSize: 13)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
            if (!esSoloLectura)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.dorado),
                onPressed: () {
                  Navigator.pop(ctx);
                  _mostrarFormulario(editar: r);
                },
                child: const Text('Editar'),
              ),
          ],
        );
      },
    );
  }

  Widget _filaDetalle(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(titulo, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
          ),
          Expanded(
            flex: 5,
            child: Text(valor,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // DIÁLOGO: ELIMINAR (confirmación)
  // =======================================================================
  void _confirmarEliminar(HistorialPrecio r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar registro?'),
        content: Text(
          'Se eliminará el registro #${r.id} de "${r.nombreProducto}". Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.rojo),
            onPressed: () {
              Navigator.pop(ctx);
              _eliminar(r);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // DIÁLOGO: CREAR / EDITAR
  // =======================================================================
  void _mostrarFormulario({HistorialPrecio? editar}) {
    final esEdicion = editar != null;

    // Estado local del formulario
    int? idProductoSeleccionado = editar?.idProducto;
    String nombreProductoSeleccionado = editar?.nombreProducto ?? '';
    double precioAnterior = (editar?.precioAnterior ?? 0).toDouble();
    bool productoNuevo = false;

    final nombreNuevoCtrl = TextEditingController();
    final precioNuevoCtrl =
        TextEditingController(text: editar != null ? editar.precioNuevo.toStringAsFixed(0) : '');
    final motivoCtrl = TextEditingController(text: editar?.motivo ?? '');
    DateTime fecha = editar?.fecha ?? DateTime.now();
    bool activo = editar?.activo ?? true;

    final catalogo = _catalogoProductos;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(esEdicion ? 'Editar registro' : 'Nuevo registro de precio'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!esEdicion) ...[
                      // Selección de producto (solo al crear)
                      DropdownButtonFormField<int>(
                        value: productoNuevo ? null : idProductoSeleccionado,
                        decoration: const InputDecoration(
                          labelText: 'Producto',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          ...catalogo.map(
                            (p) => DropdownMenuItem<int>(
                              value: p['id'] as int,
                              child: Text('${p['nombre']} (#${p['id']})'),
                            ),
                          ),
                          const DropdownMenuItem<int>(
                            value: -1,
                            child: Text('+ Producto nuevo'),
                          ),
                        ],
                        onChanged: (valor) {
                          setDialogState(() {
                            if (valor == -1) {
                              productoNuevo = true;
                              idProductoSeleccionado = null;
                              nombreProductoSeleccionado = '';
                              precioAnterior = 0;
                            } else {
                              productoNuevo = false;
                              idProductoSeleccionado = valor;
                              final p = catalogo.firstWhere((e) => e['id'] == valor);
                              nombreProductoSeleccionado = p['nombre'] as String;
                              precioAnterior = (p['precioActual'] as num).toDouble();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      if (productoNuevo)
                        TextField(
                          controller: nombreNuevoCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del producto nuevo',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      if (productoNuevo) const SizedBox(height: 12),
                      if (!productoNuevo && idProductoSeleccionado != null)
                        Text(
                          'Precio anterior (automático): \$${_formatoMiles(precioAnterior)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                        ),
                      if (!productoNuevo && idProductoSeleccionado != null)
                        const SizedBox(height: 12),
                    ] else ...[
                      // En edición se muestran los datos del producto fijos
                      Text(nombreProductoSeleccionado,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('Precio anterior: \$${_formatoMiles(precioAnterior)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: precioNuevoCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Precio nuevo',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: motivoCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Motivo',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today_outlined, size: 16),
                            label: Text(_formatoFechaLarga(fecha)),
                            onPressed: () async {
                              final seleccionada = await showDatePicker(
                                context: ctx,
                                initialDate: fecha,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (seleccionada != null) {
                                setDialogState(() => fecha = seleccionada);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text('Producto activo', style: TextStyle(fontSize: 13)),
                      value: activo,
                      activeColor: AppColors.verde,
                      onChanged: (v) => setDialogState(() => activo = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.dorado),
                  onPressed: () {
                    final precioNuevo = double.tryParse(precioNuevoCtrl.text.trim());
                    if (precioNuevo == null) {
                      _mostrarSnack('Ingresa un precio nuevo válido', color: AppColors.rojo);
                      return;
                    }
                    if (!esEdicion) {
                      if (productoNuevo && nombreNuevoCtrl.text.trim().isEmpty) {
                        _mostrarSnack('Ingresa el nombre del producto nuevo', color: AppColors.rojo);
                        return;
                      }
                      if (!productoNuevo && idProductoSeleccionado == null) {
                        _mostrarSnack('Selecciona un producto', color: AppColors.rojo);
                        return;
                      }
                    }

                    final nuevoIdRegistro = _registros.isEmpty
                        ? 1
                        : (_registros.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1);

                    if (esEdicion) {
                      final actualizado = HistorialPrecio(
                        id: editar.id,
                        idProducto: editar.idProducto,
                        nombreProducto: editar.nombreProducto,
                        precioActual: precioNuevo.toDouble(),
                        activo: activo,
                        precioAnterior: editar.precioAnterior.toDouble(),
                        precioNuevo: precioNuevo.toDouble(),
                        fecha: fecha,
                        motivo: motivoCtrl.text.trim().isEmpty ? 'Sin motivo' : motivoCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                      _actualizar(actualizado);
                    } else {
                      final idProductoFinal = productoNuevo
                          ? (catalogo.isEmpty
                              ? 1
                              : (catalogo.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) + 1))
                          : idProductoSeleccionado!;
                      final nombreFinal =
                          productoNuevo ? nombreNuevoCtrl.text.trim() : nombreProductoSeleccionado;

                      final creado = HistorialPrecio(
                        id: nuevoIdRegistro,
                        idProducto: idProductoFinal,
                        nombreProducto: nombreFinal,
                        precioActual: precioNuevo.toDouble(),
                        activo: activo,
                        precioAnterior: (productoNuevo ? 0.0 : precioAnterior).toDouble(),
                        precioNuevo: precioNuevo.toDouble(),
                        fecha: fecha,
                        motivo: motivoCtrl.text.trim().isEmpty
                            ? (productoNuevo ? 'Precio inicial al crear producto' : 'Sin motivo')
                            : motivoCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                      _crear(creado);
                    }
                  },
                  child: Text(esEdicion ? 'Guardar cambios' : 'Crear registro'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rolCrudo = (widget.usuario?['rol'] ?? '').toString().toLowerCase();
    final esSoloLectura = rolCrudo == 'contadora';

    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarRegistros,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _encabezado(rolCrudo, esSoloLectura),
            const SizedBox(height: 14),

            // Tarjetas de resumen (4 en fila)
            Row(
              children: [
                Expanded(
                  child: _tarjetaResumen('Total', '${_registros.length}', AppColors.dorado),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen('Aumentos', '$_totalAumentos', AppColors.rojo),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen('Reduc.', '$_totalReducciones', AppColors.verde),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen('Sin cambio', '$_totalSinCambio', AppColors.gris),
                ),
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
                      Text('No se encontraron registros',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._filtrados.map((r) => _tarjetaRegistro(r, esSoloLectura)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // ENCABEZADO
  // ---------------------------------------------------------------------
  Widget _encabezado(String rolCrudo, bool esSoloLectura) {
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
                Text(
                  '${rolCrudo.toUpperCase()} · HISTORIAL DE PRECIOS',
                  style: const TextStyle(
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
                  'Registro de cambios de precio por producto',
                  style: TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                ),
              ],
            ),
          ),
          if (!esSoloLectura) ...[
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => _mostrarFormulario(),
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

  // ---------------------------------------------------------------------
  // BUSCADOR + FILTRO DE FECHA
  // ---------------------------------------------------------------------
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

  // ---------------------------------------------------------------------
  // TARJETA DE RESUMEN (3 args: título, valor, color)
  // ---------------------------------------------------------------------
  Widget _tarjetaResumen(String titulo, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // SEPARADOR "X REGISTROS" CON LÍNEAS VERDES
  // ---------------------------------------------------------------------
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

  // ---------------------------------------------------------------------
  // TARJETA DE REGISTRO CON BORDE LATERAL DE COLOR (2 args: registro, soloLectura)
  // ---------------------------------------------------------------------
  Widget _tarjetaRegistro(HistorialPrecio r, bool esSoloLectura) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border(
          left: BorderSide(color: colorVariacion, width: 4),
          top: BorderSide(color: Colors.grey.shade200),
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: #id + nombre --- acciones
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
                            color: AppColors.doradoOscuro,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: r.nombreProducto,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _botonAccion(
                  icono: Icons.remove_red_eye_outlined,
                  onTap: () => _verDetalle(r, esSoloLectura),
                ),
                if (!esSoloLectura) ...[
                  const SizedBox(width: 6),
                  _botonAccion(
                    icono: Icons.edit_outlined,
                    onTap: () => _mostrarFormulario(editar: r),
                  ),
                  const SizedBox(width: 6),
                  _botonAccion(
                    icono: Icons.delete_outline,
                    color: AppColors.rojo,
                    onTap: () => _confirmarEliminar(r),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),

            // Subtítulo: ID + Actual + Activo
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
                    decoration: BoxDecoration(
                      color: AppColors.verdeFondo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Activo',
                      style: TextStyle(
                          color: AppColors.verde, fontWeight: FontWeight.w600, fontSize: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Precio anterior --- flecha --- precio nuevo --- variación
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Precio Anterior',
                          style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                      Text(
                        '\$${_formatoMiles(r.precioAnterior)}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.dorado),
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
                      const Text('Precio Nuevo',
                          style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                      Text(
                        '\$${_formatoMiles(r.precioNuevo)}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.verde),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Variación',
                        style: TextStyle(fontSize: 10, color: AppColors.textoMuted)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: fondoVariacion,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (iconoVariacion != null)
                            Icon(iconoVariacion, size: 11, color: colorVariacion),
                          if (iconoVariacion != null) const SizedBox(width: 2),
                          Text(
                            textoVariacion,
                            style: TextStyle(
                                color: colorVariacion,
                                fontWeight: FontWeight.w600,
                                fontSize: 11),
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

            // Fecha --- motivo
            Row(
              children: [
                Text(
                  _formatoFechaLarga(r.fecha),
                  style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    r.motivo,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textoMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonAccion({required IconData icono, required VoidCallback onTap, Color? color}) {
    final colorFinal = color ?? AppColors.doradoOscuro;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.fondo,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color != null ? color.withValues(alpha: 0.35) : AppColors.doradoClaro),
        ),
        child: Icon(icono, size: 16, color: colorFinal),
      ),
    );
  }
}