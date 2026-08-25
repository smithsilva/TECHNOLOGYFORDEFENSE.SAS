import 'package:flutter/material.dart';
import '../../models/historial_precio.dart';
// import '../services/historial_precios_service.dart'; // ← lo conectas cuando pases de mock a datos reales

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

  // Nuevos colores para el header oscuro tipo mockup
  static const navyOscuro = Color(0xFF101F3C);
  static const navyClaro = Color(0xFF1B2B4E);
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
  int get _totalIniciales => _registros
      .where((r) => _normalizar(r.motivo).contains('inicial'))
      .length;

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _fechaFiltro = null;
    });
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
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

            // Tarjetas de resumen (4 en fila, como el mockup)
            Row(
              children: [
                Expanded(
                  child: _tarjetaResumen(
                    'Total',
                    '${_registros.length}',
                    AppColors.dorado,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen(
                    'Aumentos',
                    '$_totalAumentos',
                    AppColors.rojo,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen(
                    'Reduc.',
                    '$_totalReducciones',
                    AppColors.verde,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen(
                    'Iniciales',
                    '$_totalIniciales',
                    AppColors.gris,
                  ),
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
              ..._filtrados.map((r) => _tarjetaRegistro(r)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // ENCABEZADO OSCURO
  // ---------------------------------------------------------------------
  Widget _encabezado(String rolCrudo, bool esSoloLectura) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navyOscuro, AppColors.navyClaro],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Círculo decorativo
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rolCrudo.isNotEmpty)
                    Text(
                      rolCrudo.toUpperCase() +
                          (esSoloLectura ? ' · SOLO LECTURA' : ' · PRECIOS'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dorado,
                        letterSpacing: 0.5,
                      ),
                    ),
                  const SizedBox(height: 6),
                  const Text(
                    'Historial de Precios',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rastrea y analiza cada cambio de precio',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TARJETA DE RESUMEN CON BARRA SUPERIOR DE COLOR
  // ---------------------------------------------------------------------
  Widget _tarjetaResumen(String titulo, String valor, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(height: 4, color: color),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                children: [
                  Text(
                    valor,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: AppColors.textoMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BUSCADOR SIMPLIFICADO (con filtro de fecha accesible por icono)
  // ---------------------------------------------------------------------
  Widget _buscador() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, size: 20, color: AppColors.textoMuted),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _busquedaCtrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Buscar por producto, ID o motivo...',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Filtrar por fecha',
            onPressed: _elegirFecha,
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: _fechaFiltro != null ? AppColors.doradoOscuro : AppColors.textoMuted,
            ),
          ),
          if (_fechaFiltro != null)
            IconButton(
              tooltip: 'Limpiar filtros',
              onPressed: _limpiarFiltros,
              icon: const Icon(Icons.close, size: 18, color: AppColors.textoMuted),
            ),
          const SizedBox(width: 4),
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
  // TARJETA DE REGISTRO CON BORDE LATERAL DE COLOR
  // ---------------------------------------------------------------------
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
      textoVariacion = '+${r.variacionPorcentaje!.toStringAsFixed(1)}%';
    } else if (tipo == 'reduccion') {
      colorVariacion = AppColors.verde;
      fondoVariacion = AppColors.verdeFondo;
      iconoVariacion = Icons.arrow_downward;
      textoVariacion = '${r.variacionPorcentaje!.toStringAsFixed(1)}%';
    } else {
      colorVariacion = AppColors.gris;
      fondoVariacion = AppColors.grisFondo;
      iconoVariacion = null;
      textoVariacion = 'Sin cambio';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
            // Fila superior: #id + nombre --- ojo
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
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _mostrarProximamente('Ver "${r.nombreProducto}"'),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.fondo,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.doradoClaro),
                    ),
                    child: const Icon(Icons.remove_red_eye_outlined,
                        size: 16, color: AppColors.doradoOscuro),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Subtítulo: ID Prod + Activo
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'ID Prod: ${r.idProducto}  ',
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

            // Caja: Anterior --- flecha --- Nuevo --- Variación
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.fondo.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Anterior',
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
                        const Text('Nuevo',
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
                    ],
                  ),
                ],
              ),
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
}