import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart' as xls;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';


class AppColors {
  static const dorado = Color(0xFFC9A24A); // gold
  static const doradoOscuro = Color(0xFF8A6D1F); // goldDark
  static const doradoClaro = Color(0xFFD2A03C); // goldText
  static const doradoMezcla = Color(0xFFAA8835); // punto medio gold/goldDark
  static const fondo = Color(0xFFF7EFDD); // background
  static const navyOscuro = Color(0xFF101B33); // navy
  static const navyClaro = Color(0xFF17253F); // derivado de navy
  static const subtitulo = Color(0xFF9FB4DE); // lightBlue
  static const inputBg = Color(0xFFEFE4CB); // inputBg
  static const iconBg = Color(0xFFF0E3BE); // iconBg
  static const cardBorder = Color(0xFFECE0BD); // cardBorder

  static const verde = Color(0xFF2E9E4E); // green
  static const verdeFondo = Color(0xFFDCF2E3); // greenBg
  static const naranja = Color(0xFF8B7920); // olive
  static const naranjaFondo = Color(0xFFF3ECD2); // oliveBg
  static const rojo = Color(0xFFC24555); // red
  static const rojoFondo = Color(0xFFF8DCE0); // redBg

  static const textoMuted = Color(0xFF6B7280);
  static const enlace = Color(0xFF2563EB);

  static const encabezado = navyOscuro;
  static const grisTexto = textoMuted;
}

// ============================================================
// MODELO
// ============================================================
enum TipoMovimiento { ingreso, egreso, ajuste }

enum CategoriaMovimiento { mantenimiento, reparacion, blindamiento }

class MovimientoContable {
  final int numero;
  final TipoMovimiento tipo;
  final CategoriaMovimiento categoria;
  final String vehiculoId;
  final String? vehiculoNombre;
  final String cliente;
  final String fecha;
  final int mantNumero;
  final double monto;

  const MovimientoContable({
    required this.numero,
    required this.tipo,
    required this.categoria,
    required this.vehiculoId,
    this.vehiculoNombre,
    required this.cliente,
    required this.fecha,
    required this.mantNumero,
    required this.monto,
  });

  String get tipoLabel {
    switch (tipo) {
      case TipoMovimiento.ingreso:
        return 'Ingreso';
      case TipoMovimiento.egreso:
        return 'Egreso';
      case TipoMovimiento.ajuste:
        return 'Ajuste';
    }
  }

  String get categoriaLabel {
    switch (categoria) {
      case CategoriaMovimiento.mantenimiento:
        return 'Mantenimiento';
      case CategoriaMovimiento.reparacion:
        return 'Reparación';
      case CategoriaMovimiento.blindamiento:
        return 'Blindamiento';
    }
  }
}

// ============================================================
// DATOS — los 15 movimientos completos
// ============================================================
const List<MovimientoContable> movimientosData = [
  MovimientoContable(
    numero: 1,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-023',
    cliente: 'Sara Jiménez',
    fecha: '02/07/2026',
    mantNumero: 15,
    monto: 34000,
  ),
  MovimientoContable(
    numero: 2,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-014',
    vehiculoNombre: 'Toyota Prado',
    cliente: 'Felipe Torres',
    fecha: '30/06/2026',
    mantNumero: 14,
    monto: 450003,
  ),
  MovimientoContable(
    numero: 3,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-013',
    vehiculoNombre: 'Hyundai Tucson',
    cliente: 'Cristian Muñoz',
    fecha: '30/06/2026',
    mantNumero: 13,
    monto: 270000,
  ),
  MovimientoContable(
    numero: 4,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-012',
    vehiculoNombre: 'Kia Sportage',
    cliente: 'Camila Torres',
    fecha: '30/06/2026',
    mantNumero: 12,
    monto: 980000,
  ),
  MovimientoContable(
    numero: 5,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-011',
    vehiculoNombre: 'Renault Duster',
    cliente: 'Andrés Martínez',
    fecha: '30/06/2026',
    mantNumero: 11,
    monto: 180000,
  ),
  MovimientoContable(
    numero: 6,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-010',
    vehiculoNombre: 'Isuzu D-Max',
    cliente: 'Carlos Fernández',
    fecha: '30/06/2026',
    mantNumero: 10,
    monto: 3200001,
  ),
  MovimientoContable(
    numero: 7,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-009',
    vehiculoNombre: 'Mazda BT-50',
    cliente: 'Andrés Martínez',
    fecha: '30/06/2026',
    mantNumero: 9,
    monto: 349998,
  ),
  MovimientoContable(
    numero: 8,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-008',
    vehiculoNombre: 'Mitsubishi L200',
    cliente: 'Carlos Fernández',
    fecha: '30/06/2026',
    mantNumero: 8,
    monto: 220000,
  ),
  MovimientoContable(
    numero: 9,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.blindamiento,
    vehiculoId: 'VT-007',
    vehiculoNombre: 'Chevrolet Colorado',
    cliente: 'Juan Esteban Gómez',
    fecha: '30/06/2026',
    mantNumero: 7,
    monto: 2399997,
  ),
  MovimientoContable(
    numero: 10,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-006',
    vehiculoNombre: 'Jeep Wrangler',
    cliente: 'Cristian Muñoz',
    fecha: '30/06/2026',
    mantNumero: 6,
    monto: 1750000,
  ),
  MovimientoContable(
    numero: 11,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-005',
    vehiculoNombre: 'Ford Ranger',
    cliente: 'Andrés Cárdenas',
    fecha: '30/06/2026',
    mantNumero: 5,
    monto: 650000,
  ),
  MovimientoContable(
    numero: 12,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-004',
    vehiculoNombre: 'Nissan Frontier',
    cliente: 'Natalia Ramírez',
    fecha: '30/06/2026',
    mantNumero: 4,
    monto: 179999,
  ),
  MovimientoContable(
    numero: 13,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-003',
    vehiculoNombre: 'Chevrolet D-Max',
    cliente: 'Andrés Martínez',
    fecha: '30/06/2026',
    mantNumero: 3,
    monto: 750000,
  ),
  MovimientoContable(
    numero: 14,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-002',
    vehiculoNombre: 'Toyota Hilux',
    cliente: 'Cristian Muñoz',
    fecha: '30/06/2026',
    mantNumero: 2,
    monto: 420000,
  ),
  MovimientoContable(
    numero: 15,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-001',
    vehiculoNombre: 'Humvee Blindado',
    cliente: 'Andrés Cárdenas',
    fecha: '30/06/2026',
    mantNumero: 1,
    monto: 850000,
  ),
];

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================
class MovimientosContablesScreen extends StatefulWidget {
  final bool embedded;

  const MovimientosContablesScreen({super.key, this.embedded = false});

  @override
  State<MovimientosContablesScreen> createState() =>
      _MovimientosContablesScreenState();
}

class _MovimientosContablesScreenState
    extends State<MovimientosContablesScreen> {
  String _filtroTipo = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  bool _filtrosExpandido = true;

  // ------------------------------------------------------------
  // TODO: Reemplaza esto por tu fetch real a Supabase
  // (tabla movimientos_contables + join con mantenimiento/vehiculos)
  // ------------------------------------------------------------
  final List<MovimientoContable> _movimientos = movimientosData;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MovimientoContable> get _movimientosFiltrados {
    final query = _searchController.text.toLowerCase();
    return _movimientos.where((m) {
      final coincideTipo = _filtroTipo == 'Todos' ||
          m.tipoLabel.toLowerCase() == _filtroTipo.toLowerCase();
      final coincideBusqueda = query.isEmpty ||
          m.cliente.toLowerCase().contains(query) ||
          m.vehiculoId.toLowerCase().contains(query) ||
          m.categoriaLabel.toLowerCase().contains(query) ||
          m.numero.toString().contains(query);
      return coincideTipo && coincideBusqueda;
    }).toList();
  }

  double get _totalIngresos => _movimientos
      .where((m) => m.tipo == TipoMovimiento.ingreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get _totalEgresos => _movimientos
      .where((m) => m.tipo == TipoMovimiento.egreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get _totalAjustes => _movimientos
      .where((m) => m.tipo == TipoMovimiento.ajuste)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get _balance => _totalIngresos - _totalEgresos + _totalAjustes;

  String _formatoMoneda(double monto) {
    final esNegativo = monto < 0;
    final entero = monto.abs().round();
    final str = entero.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    final signo = esNegativo ? '-' : '';
    return '$signo\$${buffer.toString()}';
  }

  void _mostrarMensaje(String texto, {bool esError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(fontSize: 13)),
        backgroundColor: esError ? AppColors.rojo : AppColors.encabezado,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ============================================================
  // EXPORTAR — abre un selector de formato y genera el archivo
  // ============================================================
  void _exportar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Exportar movimientos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.encabezado,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.rojo),
              title: const Text('Exportar como PDF'),
              onTap: () {
                Navigator.pop(ctx);
                _exportarPDF();
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.enlace),
              title: const Text('Exportar como Word'),
              onTap: () {
                Navigator.pop(ctx);
                _exportarWord();
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined, color: AppColors.verde),
              title: const Text('Exportar como Excel'),
              onTap: () {
                Navigator.pop(ctx);
                _exportarExcel();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  List<List<String>> _filasParaExportar() {
    return _movimientosFiltrados
        .map((m) => [
              m.numero.toString(),
              m.tipoLabel,
              m.categoriaLabel,
              m.vehiculoNombre == null
                  ? m.vehiculoId
                  : '${m.vehiculoId} - ${m.vehiculoNombre}',
              m.cliente,
              m.fecha,
              '#${m.mantNumero}',
              _formatoMoneda(m.monto),
            ])
        .toList();
  }

  Future<void> _exportarPDF() async {
    try {
      final pdf = pw.Document();
      final filas = _filasParaExportar();

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Header(level: 0, text: 'Movimientos Contables'),
            pw.Text('Ingresos: ${_formatoMoneda(_totalIngresos)}'),
            pw.Text('Egresos: ${_formatoMoneda(_totalEgresos)}'),
            pw.Text('Ajustes: ${_formatoMoneda(_totalAjustes)}'),
            pw.Text('Balance: ${_formatoMoneda(_balance)}'),
            pw.SizedBox(height: 14),
            pw.TableHelper.fromTextArray(
              headers: const [
                '#',
                'Tipo',
                'Categoría',
                'Vehículo',
                'Cliente',
                'Fecha',
                'Mant.',
                'Monto'
              ],
              data: filas,
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerStyle:
                  pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColor.fromInt(0xFFC9A24A)),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'movimientos_contables.pdf',
      );
    } catch (e) {
      _mostrarMensaje('Error al exportar PDF: $e', esError: true);
    }
  }

  Future<void> _exportarExcel() async {
    try {
      final excel = xls.Excel.createExcel();
      final nombreHoja = 'Movimientos';
      final sheet = excel[nombreHoja];
      excel.setDefaultSheet(nombreHoja);
      // Elimina la hoja por defecto "Sheet1" si Excel la crea aparte
      if (excel.sheets.containsKey('Sheet1') && nombreHoja != 'Sheet1') {
        excel.delete('Sheet1');
      }

      // La API v4 del paquete `excel` exige que cada celda sea un
      // CellValue explícito (TextCellValue, IntCellValue,
      // DoubleCellValue) en vez de un String/int/double "crudo".
      xls.TextCellValue t(String v) => xls.TextCellValue(v);
      xls.DoubleCellValue money(double v) => xls.DoubleCellValue(v);

      sheet.appendRow([t('Ingresos'), t(_formatoMoneda(_totalIngresos))]);
      sheet.appendRow([t('Egresos'), t(_formatoMoneda(_totalEgresos))]);
      sheet.appendRow([t('Ajustes'), t(_formatoMoneda(_totalAjustes))]);
      sheet.appendRow([t('Balance'), t(_formatoMoneda(_balance))]);
      sheet.appendRow(<xls.CellValue?>[]);
      sheet.appendRow([
        t('#'),
        t('Tipo'),
        t('Categoría'),
        t('Vehículo'),
        t('Cliente'),
        t('Fecha'),
        t('Mant.'),
        t('Monto'),
      ]);

      for (final m in _movimientosFiltrados) {
        sheet.appendRow([
          xls.IntCellValue(m.numero),
          t(m.tipoLabel),
          t(m.categoriaLabel),
          t(m.vehiculoNombre == null
              ? m.vehiculoId
              : '${m.vehiculoId} - ${m.vehiculoNombre}'),
          t(m.cliente),
          t(m.fecha),
          t('#${m.mantNumero}'),
          money(m.monto),
        ]);
      }

      final bytes = excel.encode();
      if (bytes == null) throw Exception('No se pudo generar el archivo');

      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(bytes),
          name: 'movimientos_contables.xlsx',
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ]);
    } catch (e) {
      _mostrarMensaje('Error al exportar Excel: $e', esError: true);
    }
  }

  Future<void> _exportarWord() async {
    try {
      final bytes = _generarDocxBytes(_movimientosFiltrados);
      await Share.shareXFiles([
        XFile.fromData(
          bytes,
          name: 'movimientos_contables.docx',
          mimeType:
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        ),
      ]);
    } catch (e) {
      _mostrarMensaje('Error al exportar Word: $e', esError: true);
    }
  }

  // Genera un .docx válido a mano (sin plantillas), con el resumen
  // y una línea de texto por cada movimiento.
  Uint8List _generarDocxBytes(List<MovimientoContable> movimientos) {
    String esc(Object valor) => valor
        .toString()
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');

    final cuerpo = StringBuffer();
    cuerpo.writeln(
        '<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="32"/></w:rPr><w:t>Movimientos Contables</w:t></w:r></w:p>');
    cuerpo.writeln('<w:p/>');
    cuerpo.writeln(
        '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>${esc('Ingresos: ${_formatoMoneda(_totalIngresos)}')}</w:t></w:r></w:p>');
    cuerpo.writeln(
        '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>${esc('Egresos: ${_formatoMoneda(_totalEgresos)}')}</w:t></w:r></w:p>');
    cuerpo.writeln(
        '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>${esc('Ajustes: ${_formatoMoneda(_totalAjustes)}')}</w:t></w:r></w:p>');
    cuerpo.writeln(
        '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>${esc('Balance: ${_formatoMoneda(_balance)}')}</w:t></w:r></w:p>');
    cuerpo.writeln('<w:p/>');

    for (final m in movimientos) {
      final vehiculo = m.vehiculoNombre == null
          ? m.vehiculoId
          : '${m.vehiculoId} - ${m.vehiculoNombre}';
      final linea =
          '#${m.numero} | ${m.tipoLabel} | ${m.categoriaLabel} | Vehículo: $vehiculo | '
          'Cliente: ${m.cliente} | Fecha: ${m.fecha} | Mant. #${m.mantNumero} | '
          'Monto: ${_formatoMoneda(m.monto)}';
      cuerpo.writeln('<w:p><w:r><w:t>${esc(linea)}</w:t></w:r></w:p>');
    }

    final documentXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    $cuerpo
    <w:sectPr/>
  </w:body>
</w:document>''';

    const contentTypesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>''';

    const relsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>''';

    const documentRelsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>''';

    const coreXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>Movimientos Contables</dc:title>
  <dc:creator>App</dc:creator>
</cp:coreProperties>''';

    const appXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
  <Application>Flutter</Application>
</Properties>''';

    final archive = Archive();
    void addFile(String path, String content) {
      final data = utf8.encode(content);
      archive.addFile(ArchiveFile(path, data.length, data));
    }

    addFile('[Content_Types].xml', contentTypesXml);
    addFile('_rels/.rels', relsXml);
    addFile('word/document.xml', documentXml);
    addFile('word/_rels/document.xml.rels', documentRelsXml);
    addFile('docProps/core.xml', coreXml);
    addFile('docProps/app.xml', appXml);

    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) throw Exception('No se pudo generar el .docx');
    return Uint8List.fromList(zipData);
  }

  // ============================================================
  // UI
  // ============================================================

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _buildTituloYExportar(),
        const SizedBox(height: 18),
        _buildStatsGrid(),
        const SizedBox(height: 18),
        _buildFiltrosHeader(),
        if (_filtrosExpandido) ...[
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 14),
          _buildFiltros(),
        ],
        const SizedBox(height: 16),
        Text(
          '${_movimientosFiltrados.length} movimientos',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.encabezado,
          ),
        ),
        const SizedBox(height: 14),
        if (_movimientosFiltrados.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No se encontraron movimientos',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: AppColors.grisTexto,
                ),
              ),
            ),
          )
        else
          ..._movimientosFiltrados.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildMovimientoCard(m),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: SafeArea(child: _buildContent(context)),
    );
  }

  // AJUSTE: se quitó el borde dorado (Border.all(color: dorado)) de
  // este contenedor.
  Widget _buildTituloYExportar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyOscuro,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONTADORA · MOVIMIENTOS',
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                    color: AppColors.doradoClaro,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Movimientos Contables',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Administra los movimientos financieros',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.subtitulo,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _GoldButton(
            icon: Icons.file_download_outlined,
            label: 'Exportar',
            onTap: _exportar,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Ingresos',
                valor: _formatoMoneda(_totalIngresos),
                colorAcento: AppColors.verde,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Egresos',
                valor: _formatoMoneda(_totalEgresos),
                colorAcento: AppColors.rojo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Ajustes',
                valor: _formatoMoneda(_totalAjustes),
                colorAcento: AppColors.subtitulo,
                colorValor: AppColors.navyClaro,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Balance',
                valor: _formatoMoneda(_balance),
                colorAcento: _balance < 0 ? AppColors.rojo : AppColors.verde,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFiltrosHeader() {
    return InkWell(
      onTap: () => setState(() => _filtrosExpandido = !_filtrosExpandido),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_outlined, size: 17, color: AppColors.dorado),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Filtros y Búsqueda',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.encabezado,
              ),
            ),
          ),
          AnimatedRotation(
            turns: _filtrosExpandido ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColors.dorado,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BUSCADOR
  //
  // AJUSTE: se quitó el borde dorado al enfocar (focusedBorder). Ahora el
  // borde se mantiene gris tanto en reposo como con el foco.
  // ---------------------------------------------------------------------
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(color: AppColors.navyOscuro, fontSize: 13.5),
      decoration: InputDecoration(
        hintText: 'Buscar por ID, concepto o cliente...',
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
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // CHIPS DE FILTRO (Todos / Egreso / Ingreso)
  //
  // AJUSTE: se quitaron los bordes dorados de los chips. Ahora usan un
  // borde gris claro, igual que el buscador. El chip activo se sigue
  // distinguiendo por su fondo y el color del texto.
  // ---------------------------------------------------------------------
  Widget _buildFiltros() {
    final opciones = ['Todos', 'Egreso', 'Ingreso'];
    return Row(
      children: opciones.map((op) {
        final activo = _filtroTipo == op;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: OutlinedButton(
            onPressed: () => setState(() => _filtroTipo = op),
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  activo ? AppColors.doradoClaro.withOpacity(0.28) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            child: Text(
              op,
              style: TextStyle(
                color: activo ? AppColors.doradoMezcla : AppColors.textoMuted,
                fontSize: 12.5,
                fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMovimientoCard(MovimientoContable m) {
    final esEgreso = m.tipo == TipoMovimiento.egreso;
    final colorTipo = esEgreso
        ? AppColors.rojo
        : (m.tipo == TipoMovimiento.ingreso ? AppColors.verde : AppColors.subtitulo);
    final fondoTipo = esEgreso
        ? AppColors.rojoFondo
        : (m.tipo == TipoMovimiento.ingreso ? AppColors.verdeFondo : AppColors.naranjaFondo);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: colorTipo, width: 4),
            top: const BorderSide(color: AppColors.cardBorder, width: 1.2),
            right: const BorderSide(color: AppColors.cardBorder, width: 1.2),
            bottom: const BorderSide(color: AppColors.cardBorder, width: 1.2),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconoCategoria(m.categoria, fondoTipo),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${m.numero}',
                        style: const TextStyle(
                          color: AppColors.navyClaro,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: fondoTipo,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          m.tipoLabel,
                          style: TextStyle(
                            color: colorTipo,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.navyClaro,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                      children: [
                        TextSpan(text: '${m.categoriaLabel} — Vehículo: '),
                        TextSpan(
                          text: m.vehiculoNombre == null
                              ? m.vehiculoId
                              : '${m.vehiculoId} — ${m.vehiculoNombre}',
                          style: const TextStyle(
                            color: AppColors.enlace,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' — Cliente: '),
                        TextSpan(
                          text: m.cliente,
                          style: const TextStyle(
                            color: AppColors.enlace,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${m.cliente} · ${m.fecha}',
                              style: const TextStyle(
                                color: AppColors.grisTexto,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mant. #${m.mantNumero}',
                              style: const TextStyle(
                                color: AppColors.grisTexto,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatoMoneda(m.monto),
                        style: TextStyle(
                          color: colorTipo,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
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
    );
  }

  Widget _iconoCategoria(CategoriaMovimiento categoria, Color fondo) {
    IconData icono;
    switch (categoria) {
      case CategoriaMovimiento.mantenimiento:
        icono = Icons.build_outlined;
        break;
      case CategoriaMovimiento.reparacion:
        icono = Icons.car_repair_outlined;
        break;
      case CategoriaMovimiento.blindamiento:
        icono = Icons.shield_outlined;
        break;
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icono, size: 18, color: AppColors.doradoMezcla),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================

class _GoldButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GoldButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dorado,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: AppColors.encabezado),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.encabezado,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _StatCard
// La franja de color izquierda va en su propio Container y el
// borderRadius se aplica sobre un borde de un único color
// (cardBorder), para evitar la excepción de Flutter con bordes
// de colores distintos + borderRadius.
// ============================================================
class _StatCard extends StatelessWidget {
  final String label;
  final String valor;
  final Color colorAcento;
  final Color? colorValor;

  const _StatCard({
    required this.label,
    required this.valor,
    required this.colorAcento,
    this.colorValor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: colorAcento),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(color: AppColors.grisTexto, fontSize: 11.5),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          valor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorValor ?? colorAcento,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
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
}

// ============================================================
// DEMO STANDALONE — flutter run
// ============================================================
void main() {
  runApp(const _DemoApp());
}

class _DemoApp extends StatelessWidget {
  const _DemoApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movimientos Contables',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.fondo,
        fontFamily: 'Roboto',
      ),
      home: const MovimientosContablesScreen(),
    );
  }
}