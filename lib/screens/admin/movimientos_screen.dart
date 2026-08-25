import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movimiento.dart';
import '../../services/movimientos_service.dart'; // ajusta el path real en tu proyecto

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const textoMuted = Color(0xFF6B7280);

  // Nuevos colores para el header oscuro
  static const headerOscuro = Color(0xFF15151F);
  static const headerOscuro2 = Color(0xFF1E1E2C);
  static const botonOscuro = Color(0xFF2B2B3A);
}

class MovimientosScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const MovimientosScreen({super.key, this.usuario});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  final MovimientosService _service = MovimientosService();

  String _filtroTipo = 'todos'; // todos | entrada | salida
  bool _cargando = false;
  bool _cargandoInicial = true;
  bool _filtrosAbiertos = true;
  String? _error;
  String? _token;

  List<Movimiento> _movimientos = [];

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    setState(() => _cargandoInicial = false);
    await _cargarMovimientos();
  }

  Future<void> _cargarMovimientos() async {
    if (_token == null) {
      setState(() => _error = 'No hay sesión activa (token no encontrado).');
      return;
    }
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final data = await _service.obtenerMovimientos(_token!);
      setState(() {
        _movimientos = data.map((json) => Movimiento.fromJson(json)).toList();
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

  List<Movimiento> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    return _movimientos.where((m) {
      final matchTexto = texto.isEmpty ||
          _normalizar(m.producto).contains(texto) ||
          _normalizar(m.usuario).contains(texto);
      final matchTipo = _filtroTipo == 'todos' || m.tipo == _filtroTipo;
      return matchTexto && matchTipo;
    }).toList();
  }

  int get _totalEntradas => _filtrados
      .where((m) => m.tipo == 'entrada')
      .fold(0, (a, m) => a + m.cantidad.abs());

  int get _totalSalidas => _filtrados
      .where((m) => m.tipo == 'salida')
      .fold(0, (a, m) => a + m.cantidad.abs());

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _filtroTipo = 'todos';
    });
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }

  String _formatoMiles(int numero) {
    final texto = numero.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final posDesdeFinal = texto.length - i;
      buffer.write(texto[i]);
      if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  String _formatoFecha(DateTime f) {
    final dia = f.day.toString().padLeft(2, '0');
    final mes = f.month.toString().padLeft(2, '0');
    final hora12 = f.hour % 12 == 0 ? 12 : f.hour % 12;
    final min = f.minute.toString().padLeft(2, '0');
    final ampm = f.hour >= 12 ? 'p. m.' : 'a. m.';
    return '$dia/$mes/${f.year}, $hora12:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoInicial) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarMovimientos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _encabezado(),
            const SizedBox(height: 14),

            // Tarjetas de totales
            Row(
              children: [
                Expanded(
                  child: _tarjetaTotal(
                    'TOTAL ENTRADAS',
                    _formatoMiles(_totalEntradas),
                    'unidades ingresadas',
                    AppColors.verde,
                    AppColors.verdeFondo,
                    Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaTotal(
                    'TOTAL SALIDAS',
                    _formatoMiles(_totalSalidas),
                    'unidades despachadas',
                    AppColors.rojo,
                    AppColors.rojoFondo,
                    Icons.arrow_downward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Filtros y búsqueda
            _panelFiltros(),
            const SizedBox(height: 18),

            // Separador "N REGISTROS"
            _separadorRegistros(_filtrados.length),
            const SizedBox(height: 12),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _cargarMovimientos,
                      child: const Text('Reintentar'),
                    ),
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
                      Icon(Icons.swap_horiz, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No se encontraron movimientos',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._filtrados.map((m) => _tarjetaMovimiento(m)),
          ],
        ),
      ),
    );
  }

  // ---------- ENCABEZADO OSCURO ----------
  Widget _encabezado() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.headerOscuro, AppColors.headerOscuro2],
          ),
        ),
        child: Stack(
          children: [
            // círculo decorativo
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.dorado.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (widget.usuario?['rol']?.toString().toUpperCase() ??
                          'ADMINISTRADOR') +
                      ' · MOVIMIENTOS',
                  style: const TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Movimientos de Inventario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Historial completo de entradas y salidas',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _mostrarProximamente('Exportar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dorado,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        icon: const Icon(Icons.file_download_outlined, size: 17),
                        label: const Text(
                          'Exportar',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _cargarMovimientos,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.botonOscuro,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        icon: const Icon(Icons.refresh, size: 17),
                        label: const Text(
                          'Actualizar',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- TARJETA DE TOTAL ----------
  Widget _tarjetaTotal(String titulo, String valor, String subtitulo,
      Color color, Color colorFondoIcono, IconData icono) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          top: BorderSide(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
          right: BorderSide(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
          bottom: BorderSide(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
          left: BorderSide(color: color, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textoMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 10, color: AppColors.textoMuted),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colorFondoIcono,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, size: 15, color: color),
          ),
        ],
      ),
    );
  }

  // ---------- PANEL DE FILTROS ----------
  Widget _panelFiltros() {
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
                  const Icon(Icons.filter_alt_outlined,
                      size: 18, color: AppColors.doradoOscuro),
                  const SizedBox(width: 8),
                  const Text(
                    'Filtros y búsqueda',
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
                      hintText: 'Buscar por producto o usuario...',
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
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _chipTipo('Todos', 'todos'),
                      _chipTipo('Entrada', 'entrada'),
                      _chipTipo('Salida', 'salida'),
                      TextButton.icon(
                        onPressed: _limpiarFiltros,
                        icon: const Icon(Icons.close, size: 14),
                        label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textoMuted,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _chipTipo(String label, String valor) {
    final activo = _filtroTipo == valor;
    return ChoiceChip(
      label: Text(label),
      selected: activo,
      onSelected: (_) => setState(() => _filtroTipo = valor),
      selectedColor: Colors.white,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: activo ? AppColors.dorado : Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: activo ? AppColors.dorado : Colors.grey.shade300,
          width: activo ? 1.4 : 1,
        ),
      ),
    );
  }

  // ---------- SEPARADOR "N REGISTROS" ----------
  Widget _separadorRegistros(int cantidad) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.doradoClaro.withValues(alpha: 0.6))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$cantidad REGISTRO${cantidad == 1 ? '' : 'S'}',
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textoMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.doradoClaro.withValues(alpha: 0.6))),
      ],
    );
  }

  // ---------- TARJETA DE MOVIMIENTO ----------
  Widget _tarjetaMovimiento(Movimiento m) {
    final esEntrada = m.tipo == 'entrada';
    final color = esEntrada ? AppColors.verde : AppColors.rojo;
    final fondo = esEntrada ? AppColors.verdeFondo : AppColors.rojoFondo;
    final signo = m.cantidad > 0 ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
          right: BorderSide(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
          bottom: BorderSide(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
          top: BorderSide(color: color, width: 3),
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
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
                  child: Icon(
                    esEntrada ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: fondo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    esEntrada ? 'Entrada' : 'Salida',
                    style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ),
                const Spacer(),
                Text(
                  '$signo${m.cantidad}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              m.producto,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person_outline, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  m.usuario,
                  style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                ),
                const Spacer(),
                Text(
                  _formatoFecha(m.fecha),
                  style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              m.motivo,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}