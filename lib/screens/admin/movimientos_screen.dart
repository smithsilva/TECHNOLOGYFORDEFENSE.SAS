import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart' hide Border, BorderStyle;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/movimiento.dart';
import '../../services/movimientos_service.dart'; // ajusta el path real en tu proyecto

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
  final MovimientosService _service = MovimientosService();

  String _filtroTipo = 'todos'; // todos | entrada | salida
  bool _cargando = false;
  bool _cargandoInicial = true;
  bool _filtrosAbiertos = true;
  bool _exportando = false;
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
      final matchTexto =
          texto.isEmpty ||
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

  // =====================================================
  // ---------------- EXPORTAR ----------------
  // =====================================================

  void _mostrarOpcionesExportar() {
    if (_filtrados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay movimientos para exportar.')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exportar Movimientos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppColors.rojo),
                title: const Text('PDF'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportarPDF();
                },
              ),
              ListTile(
                leading: const Icon(Icons.grid_on, color: AppColors.verde),
                title: const Text('Excel (.xlsx)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportarExcel();
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.blueAccent),
                title: const Text('Word (.docx)'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportarWord();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _guardarYCompartir(Uint8List bytes, String nombreArchivo) async {
    setState(() => _exportando = true);
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$nombreArchivo');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Movimientos de Inventario',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  Future<void> _exportarPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'Movimientos de Inventario',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generado: ${_formatoFecha(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Tipo', 'Producto', 'Usuario', 'Cantidad', 'Fecha', 'Motivo'],
            data: _filtrados
                .map((m) => [
                      m.tipo == 'entrada' ? 'Entrada' : 'Salida',
                      m.producto,
                      m.usuario,
                      m.cantidad.toString(),
                      _formatoFecha(m.fecha),
                      m.motivo,
                    ])
                .toList(),
            headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.amber100),
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            cellAlignment: pw.Alignment.centerLeft,
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.1),
              1: const pw.FlexColumnWidth(1.6),
              2: const pw.FlexColumnWidth(1.3),
              3: const pw.FlexColumnWidth(0.9),
              4: const pw.FlexColumnWidth(1.6),
              5: const pw.FlexColumnWidth(1.8),
            },
          ),
        ],
      ),
    );
    final bytes = await pdf.save();
    await _guardarYCompartir(bytes, 'movimientos_inventario.pdf');
  }

  Future<void> _exportarExcel() async {
    final excel = Excel.createExcel();
    final nombreHoja = 'Movimientos';
    final sheet = excel[nombreHoja];
    excel.setDefaultSheet(nombreHoja);
    // Elimina la hoja por defecto "Sheet1" si quedó vacía y no es la nuestra
    if (excel.sheets.containsKey('Sheet1') && nombreHoja != 'Sheet1') {
      excel.delete('Sheet1');
    }

    sheet.appendRow([
      TextCellValue('Tipo'),
      TextCellValue('Producto'),
      TextCellValue('Usuario'),
      TextCellValue('Cantidad'),
      TextCellValue('Fecha'),
      TextCellValue('Motivo'),
    ]);

    for (final m in _filtrados) {
      sheet.appendRow([
        TextCellValue(m.tipo == 'entrada' ? 'Entrada' : 'Salida'),
        TextCellValue(m.producto),
        TextCellValue(m.usuario),
        IntCellValue(m.cantidad),
        TextCellValue(_formatoFecha(m.fecha)),
        TextCellValue(m.motivo),
      ]);
    }

    final bytes = excel.encode();
    if (bytes != null) {
      await _guardarYCompartir(Uint8List.fromList(bytes), 'movimientos_inventario.xlsx');
    }
  }

  Future<void> _exportarWord() async {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.writeln(
      '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">',
    );
    buffer.writeln('<w:body>');
    buffer.writeln(_parrafoWord('Movimientos de Inventario', bold: true, size: 32));
    buffer.writeln(_parrafoWord('Generado: ${_formatoFecha(DateTime.now())}', size: 18));
    buffer.writeln('<w:p/>');

    for (final m in _filtrados) {
      final tipo = m.tipo == 'entrada' ? 'ENTRADA' : 'SALIDA';
      buffer.writeln(_parrafoWord('$tipo — ${m.producto}  (${m.cantidad})', bold: true, size: 22));
      buffer.writeln(_parrafoWord('Usuario: ${m.usuario}   |   Fecha: ${_formatoFecha(m.fecha)}'));
      if (m.motivo.isNotEmpty) {
        buffer.writeln(_parrafoWord('Motivo: ${m.motivo}'));
      }
      buffer.writeln('<w:p/>');
    }

    buffer.writeln('</w:body>');
    buffer.writeln('</w:document>');

    final bytes = _crearDocx(buffer.toString());
    await _guardarYCompartir(bytes, 'movimientos_inventario.docx');
  }

  String _parrafoWord(String texto, {bool bold = false, int size = 20}) {
    final textoEscapado = texto
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
    final rPr = bold
        ? '<w:rPr><w:b/><w:sz w:val="$size"/></w:rPr>'
        : '<w:rPr><w:sz w:val="$size"/></w:rPr>';
    return '<w:p><w:r>$rPr<w:t xml:space="preserve">$textoEscapado</w:t></w:r></w:p>';
  }

  Uint8List _crearDocx(String documentXml) {
    final archive = Archive();

    const contentTypes = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''';

    const rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''';

    void addFile(String path, String content) {
      final data = Uint8List.fromList(utf8.encode(content));
      archive.addFile(ArchiveFile(path, data.length, data));
    }

    addFile('[Content_Types].xml', contentTypes);
    addFile('_rels/.rels', rels);
    addFile('word/document.xml', documentXml);

    final zipData = ZipEncoder().encode(archive);
    return Uint8List.fromList(zipData!);
  }

  // =====================================================
  // ---------------- UI ----------------
  // =====================================================

  @override
  Widget build(BuildContext context) {
    if (_cargandoInicial) {
      return const Center(child: CircularProgressIndicator());
    }

    final rolCrudo = (widget.usuario?['rol'] ?? 'administrador').toString().toLowerCase();

    return Container(
      color: AppColors.fondo,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _cargarMovimientos,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _encabezado(rolCrudo),
                const SizedBox(height: 14),

                // Tarjetas de totales
                Row(
                  children: [
                    Expanded(
                      child: _tarjetaTotal(
                        'TOTAL ENTRADAS',
                        _formatoMiles(_totalEntradas),
                        'unidades',
                        AppColors.verde,
                        Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _tarjetaTotal(
                        'TOTAL SALIDAS',
                        _formatoMiles(_totalSalidas),
                        'unidades',
                        AppColors.rojo,
                        Icons.arrow_downward,
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
                      children: [
                        TextField(
                          controller: _busquedaCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Buscar por producto o usuario...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                            prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade400),
                            filled: true,
                            fillColor: AppColors.fondo,
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
                              borderSide: const BorderSide(color: AppColors.dorado),
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
                ),
                const SizedBox(height: 16),

                // Historial de movimientos
                Row(
                  children: [
                    const Text(
                      'Historial de Movimientos',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      '${_filtrados.length} registro${_filtrados.length != 1 ? "s" : ""}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 40,
                          color: Colors.red.shade400,
                        ),
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
                          Icon(
                            Icons.swap_horiz,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No se encontraron movimientos',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._filtrados.map((m) => _tarjetaMovimiento(m)),
              ],
            ),
          ),
          if (_exportando)
            Container(
              color: Colors.black.withValues(alpha: 0.15),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Generando archivo...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------- ENCABEZADO (navy, igual al resto de pantallas del admin) ----------
  Widget _encabezado(String rolCrudo) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${rolCrudo.toUpperCase()} · MOVIMIENTOS',
            style: const TextStyle(
              color: AppColors.dorado,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Movimientos de Inventario',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Historial completo de entradas y salidas',
            style: TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _exportando ? null : _mostrarOpcionesExportar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dorado,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Exportar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(width: 2),
                      Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cargando ? null : _cargarMovimientos,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const StadiumBorder(),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Actualizar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- TARJETA DE TOTAL (borde de color a la izquierda) ----------
  Widget _tarjetaTotal(String titulo, String valor, String subtitulo, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 12, color: color),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              titulo,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textoMuted,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        valor,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitulo,
                        style: const TextStyle(fontSize: 10, color: AppColors.textoMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
      showCheckmark: false,
      labelStyle: TextStyle(
        color: activo ? AppColors.dorado : Colors.grey.shade500,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: activo ? AppColors.dorado : Colors.grey.shade200,
          width: activo ? 1.4 : 1,
        ),
      ),
    );
  }

  // ---------- TARJETA DE MOVIMIENTO (franja de color a la izquierda) ----------
  Widget _tarjetaMovimiento(Movimiento m) {
    final esEntrada = m.tipo == 'entrada';
    final color = esEntrada ? AppColors.verde : AppColors.rojo;
    final fondo = esEntrada ? AppColors.verdeFondo : AppColors.rojoFondo;
    final signo = m.cantidad > 0 ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: fondo,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              esEntrada ? 'Entrada' : 'Salida',
                              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$signo${m.cantidad}',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                      if (m.motivo.isNotEmpty) ...[
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}