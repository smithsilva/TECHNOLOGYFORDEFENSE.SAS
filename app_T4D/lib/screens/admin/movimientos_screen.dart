import 'package:flutter/material.dart';
import '../../models/movimiento.dart';
// import '../services/movimientos_service.dart'; // ← lo conectas cuando pases de mock a datos reales

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
}

class MovimientosScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const MovimientosScreen({super.key, this.usuario});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();

  String _filtroTipo = 'todos'; // todos | entrada | salida
  bool _cargando = false;
  bool _filtrosAbiertos = true;

  List<Movimiento> _movimientos = [];
  int _totalEntradas = 0;
  int _totalSalidas = 0;

  @override
  void initState() {
    super.initState();
    _cargarMovimientos();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Por ahora carga datos de ejemplo (mock) para la parte visual.
  /// Cuando conectes el backend, reemplaza el contenido de este método
  /// por una llamada a tu MovimientosService, por ejemplo:
  ///
  /// final data = await MovimientosService().obtenerMovimientos();
  /// setState(() => _movimientos = data);
  Future<void> _cargarMovimientos() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _movimientos = [
        Movimiento(
          id: 16,
          fecha: DateTime(2028, 7, 2, 14, 50),
          tipo: 'salida',
          producto: 'Llantaa',
          usuario: 'Juan',
          motivo: 'Ajuste de stock desde edición de producto',
          cantidad: -3,
        ),
        Movimiento(
          id: 15,
          fecha: DateTime(2028, 7, 2, 14, 49),
          tipo: 'entrada',
          producto: 'Llantaa',
          usuario: 'Juan',
          motivo: 'Ajuste de stock desde edición de producto',
          cantidad: 2,
        ),
        Movimiento(
          id: 14,
          fecha: DateTime(2028, 7, 2, 14, 47),
          tipo: 'salida',
          producto: 'Llantaa',
          usuario: 'Juan',
          motivo: 'Ajuste de stock desde edición de producto',
          cantidad: -23,
        ),
      ];
      _totalEntradas = 780267;
      _totalSalidas = 33;
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
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarMovimientos,
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
                    'Movimientos de Inventario',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Historial de entradas y salidas',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _mostrarProximamente('Exportar'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.dorado,
                            foregroundColor: Colors.white,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('Exportar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _cargarMovimientos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.doradoOscuro,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Actualizar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjetas de totales
            Row(
              children: [
                Expanded(
                  child: _tarjetaTotal(
                    'Total Entradas',
                    _formatoMiles(_totalEntradas),
                    'unidades en el periodo filtrado',
                    AppColors.verde,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaTotal(
                    'Total Salidas',
                    _formatoMiles(_totalSalidas),
                    'unidades en el periodo filtrado',
                    AppColors.rojo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Filtros y búsqueda
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
                            'Filtros y Búsqueda',
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
                          const SizedBox(height: 10),
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
            ),
            const SizedBox(height: 14),

            // Historial de movimientos
            Text(
              'Historial de Movimientos (${_filtrados.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

  Widget _tarjetaTotal(String titulo, String valor, String subtitulo, Color color) {
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

  Widget _chipTipo(String label, String valor) {
    final activo = _filtroTipo == valor;
    return ChoiceChip(
      label: Text(label),
      selected: activo,
      onSelected: (_) => setState(() => _filtroTipo = valor),
      selectedColor: AppColors.dorado,
      backgroundColor: AppColors.fondo,
      labelStyle: TextStyle(
        color: activo ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      shape: StadiumBorder(side: BorderSide(color: AppColors.doradoClaro)),
    );
  }

  Widget _tarjetaMovimiento(Movimiento m) {
    final esEntrada = m.tipo == 'entrada';
    final color = esEntrada ? AppColors.verde : AppColors.rojo;
    final fondo = esEntrada ? AppColors.verdeFondo : AppColors.rojoFondo;
    final signo = m.cantidad > 0 ? '+' : '';

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
          Row(
            children: [
              Text(
                _formatoFecha(m.fecha),
                style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
              ),
              const Spacer(),
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
            ],
          ),
          const SizedBox(height: 6),
          Text(
            m.producto,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            '${m.usuario} · ${m.motivo}',
            style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$signo${m.cantidad}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}