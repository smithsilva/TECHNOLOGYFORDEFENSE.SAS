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
            // Encabezado / título de la sección
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
                  const Text(
                    'Historial de Precios',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rastrea y analiza cambios de precios',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (rolCrudo.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.doradoClaro.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        rolCrudo.toUpperCase() +
                            (esSoloLectura ? '  ·  Solo lectura' : ''),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.doradoOscuro,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjetas de resumen
            Row(
              children: [
                Expanded(
                  child: _tarjetaResumen(
                      'Total Registros', '${_registros.length}',
                      'cambios registrados', AppColors.doradoOscuro),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen('Aumentos', '$_totalAumentos',
                      'precios incrementados', AppColors.rojo),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _tarjetaResumen('Reducciones', '$_totalReducciones',
                      'precios reducidos', AppColors.dorado),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaResumen('Sin Cambio', '$_totalSinCambio',
                      'sin variación', AppColors.gris),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Búsqueda y filtros
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
                          const Icon(Icons.filter_alt_outlined,
                              size: 18, color: AppColors.doradoOscuro),
                          const SizedBox(width: 8),
                          const Text(
                            'Búsqueda y Filtros',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const Spacer(),
                          Icon(
                            _filtrosAbiertos
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_filtrosAbiertos)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Column(
                        children: [
                          TextField(
                            controller: _busquedaCtrl,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Buscar por producto, ID o motivo...',
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
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: _elegirFecha,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.fondo,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 16, color: AppColors.textoMuted),
                                  const SizedBox(width: 8),
                                  Text(
                                    _fechaFiltro == null
                                        ? 'dd/mm/aaaa'
                                        : _formatoFechaLarga(_fechaFiltro!),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _fechaFiltro == null
                                          ? Colors.grey.shade500
                                          : Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_fechaFiltro != null)
                                    InkWell(
                                      onTap: () => setState(() => _fechaFiltro = null),
                                      child: const Icon(Icons.close,
                                          size: 16, color: AppColors.textoMuted),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _limpiarFiltros,
                              icon: const Icon(Icons.close, size: 14),
                              label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textoMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Registro histórico
            Row(
              children: [
                const Text(
                  'Registro Histórico de Precios',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${_filtrados.length} registros encontrados',
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

  Widget _tarjetaResumen(String titulo, String valor, String subtitulo, Color color) {
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
          const SizedBox(height: 2),
          Text(
            subtitulo,
            style: const TextStyle(fontSize: 10, color: AppColors.textoMuted),
          ),
        ],
      ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
                          fontSize: 14,
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
                  style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}