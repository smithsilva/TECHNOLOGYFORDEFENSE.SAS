import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/historial_precio.dart';
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
  bool _filtrosAbiertos = true;
  String? _error;

  List<HistorialPrecio> _registros = [];

  /// El token se guarda por separado en SharedPreferences durante el login
  /// (ver login_screen.dart: prefs.setString('token', token)), NO dentro
  /// del mapa `usuario`. Por eso se obtiene aquí de forma asíncrona.
  Future<String?> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

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

  /// Carga el historial real desde el backend.
  Future<void> _cargarRegistros() async {
    final token = await _obtenerToken();

    if (token == null || token.isEmpty) {
      setState(() {
        _error = 'No se encontró el token de sesión. Vuelve a iniciar sesión.';
        _cargando = false;
      });
      debugPrint('>>> HistorialPrecios: token nulo o vacío en widget.usuario');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final data = await _service.obtenerHistorial(token);
      debugPrint('>>> HistorialPrecios: ${data.length} registros recibidos');

      if (!mounted) return;
      setState(() {
        _registros = data;
        _cargando = false;
      });
    } catch (e) {
      debugPrint('>>> HistorialPrecios: error al cargar -> $e');
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar el historial: $e';
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
  // ELIMINAR (llamada real al backend)
  // =======================================================================

  Future<void> _eliminar(HistorialPrecio r) async {
    final token = await _obtenerToken();
    if (token == null) return;

    try {
      await _service.eliminarHistorial(token, r.id);
      if (!mounted) return;
      setState(() => _registros.removeWhere((x) => x.id == r.id));
      _mostrarSnack('Registro eliminado', color: AppColors.rojo);
    } catch (e) {
      _mostrarSnack('No se pudo eliminar: $e', color: AppColors.rojo);
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // ─── HELPERS DE DISEÑO COMPARTIDOS PARA EL MODAL (mismo estilo que
  // Inventario / Categorías / Usuarios: header navy con ícono, campos
  // redondeados, cajitas de stats y footer con botón dorado) ─────────────
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
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
                Text(
                  subtitulo,
                  style: const TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                ),
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
      decoration: BoxDecoration(
        color: AppColors.fondo,
        borderRadius: BorderRadius.circular(14),
      ),
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
  // DIÁLOGO: VER DETALLE
  // =======================================================================
  void _verDetalle(HistorialPrecio r, bool esSoloLectura) {
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
              decoration: BoxDecoration(
                color: fondoVariacion,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconoVariacion, size: 11, color: colorVariacion),
                  const SizedBox(width: 3),
                  Text(
                    textoVariacion,
                    style: TextStyle(color: colorVariacion, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Column(
              children: [
                _filaDetalleIcono(Icons.calendar_today_outlined, 'Fecha', _formatoFechaLarga(r.fecha)),
                _filaDetalleIcono(
                  Icons.check_circle_outline,
                  'Estado',
                  r.activo ? 'Activo' : 'Inactivo',
                ),
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
                      child: _cajaStat(
                        'Precio Anterior',
                        '\$${_formatoMiles(r.precioAnterior)}',
                        AppColors.dorado,
                        Icons.arrow_back,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _cajaStat(
                        'Precio Nuevo',
                        '\$${_formatoMiles(r.precioNuevo)}',
                        AppColors.verde,
                        Icons.arrow_forward,
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
                if (!esSoloLectura) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _confirmarEliminar(r);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rojo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
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

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.rojoFondo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.rojo, fontSize: 13),
                ),
              ),
              const SizedBox(height: 14),
            ],

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
  // TARJETA DE RESUMEN
  //
  // Mismo estilo que usa Inventario (_statCard): borde superior de 3px
  // con el color del dato, sombra suave, y el número grande centrado
  // arriba de la etiqueta.
  // ---------------------------------------------------------------------
  Widget _tarjetaResumen(String titulo, String valor, Color color) {
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
          Text(titulo, style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // SEPARADOR
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
  // TARJETA DE REGISTRO
  // ---------------------------------------------------------------------
  //
  // NOTA DEL FIX: antes esta tarjeta usaba un solo Container con
  // BoxDecoration(borderRadius: ..., border: Border(left: colorVariacion,
  // top/right/bottom: gris)). Flutter NO permite un borderRadius sobre un
  // Border con colores distintos por lado ("A borderRadius can only be
  // given on borders with uniform colors."), y lanzaba esa excepción en
  // cada frame, dejando las tarjetas en blanco/rotas. La solución es
  // separar la franja de color izquierda en su propio widget (un
  // Container angosto dentro de un Row), y dejar el borderRadius solo
  // sobre un borde de un único color uniforme (gris claro).
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

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _verDetalle(r, esSoloLectura),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Franja de color izquierda, separada del borde del contenedor.
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
                        // ─── Acciones: mismo estilo cuadrado con ícono que
                        // usa ProductoCard/Categorías/Usuarios — sin borde,
                        // fondo sólido de color suave.
                        _accionBoton(
                          Icons.remove_red_eye_outlined,
                          AppColors.doradoOscuro,
                          const Color(0xFFFBF1DD),
                          () => _verDetalle(r, esSoloLectura),
                        ),
                        if (!esSoloLectura) ...[
                          const SizedBox(width: 8),
                          _accionBoton(
                            Icons.delete_outline,
                            const Color(0xFFD64545),
                            const Color(0xFFFBE3E3),
                            () => _confirmarEliminar(r),
                          ),
                        ],
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
            ),
          ],
          ),
        ),
      ),
      ),
    );
  }

  // Mismo helper que usa ProductoCard, Categorías y Usuarios: botón
  // cuadrado, ícono solo, fondo de color suave, sin texto ni borde.
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