// ============================================================================
// DEPENDENCIAS NECESARIAS (agrégalas a tu pubspec.yaml)
// ----------------------------------------------------------------------------
// dependencies:
//   excel: ^4.0.6
//   pdf: ^3.11.1
//   archive: ^3.6.1
//   share_plus: ^10.0.0
//
// Luego corre: flutter pub get
// ============================================================================
 
import 'dart:convert';
import 'dart:typed_data';
 
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as xlsx;
import 'package:archive/archive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
 
// import '../services/reportes_service.dart'; // ← conéctalo cuando pases de mock a datos reales
// Endpoint sugerido ya existente en tu backend: GET /reportes/financiero/balance
 
// ============================================================================
// PALETA DE COLORES
// ----------------------------------------------------------------------------
// Si ya tienes una clase AppColors en tu proyecto (por ejemplo la que usa tu
// ReportesScreen de Admin), BORRA este bloque completo y en su lugar importa
// ese archivo: import '../../shared/app_colors.dart';
// Los valores de aquí son idénticos a los que ya usas, para que se vea igual.
// ============================================================================
class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navy = Color(0xFF13202E);
  static const navyOscuro = Color(0xFF101F3C);
  static const navyClaro = Color(0xFF1B2B4E);
  static const azul = Color(0xFF3B82F6);
  static const morado = Color(0xFF8B5CF6);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const naranja = Color(0xFFC98A1B);
  static const naranjaFondo = Color(0xFFFBF0DD);
  static const textoMuted = Color(0xFF6B7280);
  static const subtitulo = Color(0xFF8FA3C4);
}
 
// ============================================================================
// MODELOS
// ============================================================================
 
/// Un renglón del balance mensual (ingreso vs egreso).
class BalancePeriodo {
  final String periodo; // Ej: "2026-09"
  final double ingreso;
  final double egreso;
 
  const BalancePeriodo({
    required this.periodo,
    required this.ingreso,
    required this.egreso,
  });
 
  double get neto => ingreso - egreso;
}
 
/// Resumen financiero mostrado en la pestaña "Financiero" de Contadora.
class ResumenFinancieroContadora {
  final int movimientos;
  final double totalIngresos;
  final int proveedores;
  final int sucursales;
  final List<BalancePeriodo> balancePorPeriodo;
 
  const ResumenFinancieroContadora({
    required this.movimientos,
    required this.totalIngresos,
    required this.proveedores,
    required this.sucursales,
    required this.balancePorPeriodo,
  });
}
 
// ============================================================================
// PANTALLA: Centro de Reportes (Contadora)
// ============================================================================
class ReportesContadoraScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;
 
  const ReportesContadoraScreen({super.key, this.usuario});
 
  @override
  State<ReportesContadoraScreen> createState() =>
      _ReportesContadoraScreenState();
}
 
class _ReportesContadoraScreenState extends State<ReportesContadoraScreen> {
  bool _cargando = false;
  bool _exportando = false;
 
  // 0 = Financiero, 1 = Productos
  int _tabSeleccionada = 0;
 
  ResumenFinancieroContadora? _resumen;
 
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }
 
  /// Por ahora carga datos de ejemplo (mock). Cuando conectes el backend,
  /// reemplaza el contenido por algo como:
  ///
  /// final data = await ReportesService().obtenerBalanceFinanciero();
  /// setState(() => _resumen = data);
  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));
 
    setState(() {
      _resumen = const ResumenFinancieroContadora(
        movimientos: 15,
        totalIngresos: 12683998,
        proveedores: 3,
        sucursales: 8,
        balancePorPeriodo: [
          BalancePeriodo(periodo: '2026-09', ingreso: 0, egreso: 100000),
          BalancePeriodo(periodo: '2026-07', ingreso: 0, egreso: 34000),
          BalancePeriodo(periodo: '2026-06', ingreso: 0, egreso: 12649998),
        ],
      );
      _cargando = false;
    });
 
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos actualizados'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
 
  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }
 
  String _formatoMiles(num numero) {
    final esNegativo = numero < 0;
    final texto = numero.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final posDesdeFinal = texto.length - i;
      buffer.write(texto[i]);
      if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
    }
    return '${esNegativo ? '-' : ''}${buffer.toString()}';
  }
 
  // --------------------------------------------------------------------
  // EXPORTACIÓN: Excel / Word / PDF
  // --------------------------------------------------------------------
 
  Future<void> _exportar(String tipo) async {
    final r = _resumen;
    if (r == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aún no hay datos para exportar')),
      );
      return;
    }
 
    setState(() => _exportando = true);
    try {
      late Uint8List bytes;
      late String nombre;
      late String mime;
 
      switch (tipo) {
        case 'excel':
          bytes = _generarExcelBytes(r);
          nombre = 'reporte_financiero.xlsx';
          mime =
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
          break;
        case 'word':
          bytes = _generarWordBytes(r);
          nombre = 'reporte_financiero.docx';
          mime =
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
        case 'pdf':
          bytes = await _generarPdfBytes(r);
          nombre = 'reporte_financiero.pdf';
          mime = 'application/pdf';
          break;
        default:
          setState(() => _exportando = false);
          return;
      }
 
      await Share.shareXFiles(
        [XFile.fromData(bytes, name: nombre, mimeType: mime)],
        text: 'Reporte financiero - Centro de Reportes',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }
 
  /// Genera un archivo .xlsx real con el resumen financiero y el balance
  /// por periodo, usando el paquete `excel`.
  Uint8List _generarExcelBytes(ResumenFinancieroContadora r) {
    final libro = xlsx.Excel.createExcel();
    final hoja = libro['Reporte'];
    libro.delete('Sheet1');
 
    hoja.appendRow([xlsx.TextCellValue('Centro de Reportes - Contadora')]);
    hoja.appendRow([xlsx.TextCellValue('Finanzas y productos del taller')]);
    hoja.appendRow([xlsx.TextCellValue('')]);
 
    hoja.appendRow([
      xlsx.TextCellValue('Métrica'),
      xlsx.TextCellValue('Valor'),
    ]);
    hoja.appendRow([
      xlsx.TextCellValue('Movimientos'),
      xlsx.IntCellValue(r.movimientos),
    ]);
    hoja.appendRow([
      xlsx.TextCellValue('Total ingresos'),
      xlsx.DoubleCellValue(r.totalIngresos),
    ]);
    hoja.appendRow([
      xlsx.TextCellValue('Proveedores'),
      xlsx.IntCellValue(r.proveedores),
    ]);
    hoja.appendRow([
      xlsx.TextCellValue('Sucursales'),
      xlsx.IntCellValue(r.sucursales),
    ]);
    hoja.appendRow([xlsx.TextCellValue('')]);
 
    hoja.appendRow([xlsx.TextCellValue('Balance por periodo')]);
    hoja.appendRow([
      xlsx.TextCellValue('Periodo'),
      xlsx.TextCellValue('Ingreso'),
      xlsx.TextCellValue('Egreso'),
      xlsx.TextCellValue('Neto'),
    ]);
    for (final b in r.balancePorPeriodo) {
      hoja.appendRow([
        xlsx.TextCellValue(b.periodo),
        xlsx.DoubleCellValue(b.ingreso),
        xlsx.DoubleCellValue(b.egreso),
        xlsx.DoubleCellValue(b.neto),
      ]);
    }
 
    final bytes = libro.encode();
    return Uint8List.fromList(bytes!);
  }
 
  /// Genera un archivo .docx real (Word) construyendo manualmente el paquete
  /// OOXML mínimo (zip con document.xml), sin depender de un template.
  Uint8List _generarWordBytes(ResumenFinancieroContadora r) {
    final filas = r.balancePorPeriodo.map((b) => '''
      <w:tr>
        ${_celdaDocx(b.periodo)}
        ${_celdaDocx('\$${_formatoMiles(b.ingreso)}')}
        ${_celdaDocx('\$${_formatoMiles(b.egreso)}')}
        ${_celdaDocx('\$${_formatoMiles(b.neto)}')}
      </w:tr>
    ''').join();
 
    final documentXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body>
${_parrafoDocx('Centro de Reportes - Contadora', negrita: true, tamano: 32)}
${_parrafoDocx('Finanzas y productos del taller', tamano: 20)}
${_parrafoDocx('')}
${_parrafoDocx('Resumen financiero', negrita: true, tamano: 26)}
${_parrafoDocx('Movimientos: ${r.movimientos}')}
${_parrafoDocx('Total ingresos: \$${_formatoMiles(r.totalIngresos)}')}
${_parrafoDocx('Proveedores: ${r.proveedores}')}
${_parrafoDocx('Sucursales: ${r.sucursales}')}
${_parrafoDocx('')}
${_parrafoDocx('Balance por periodo', negrita: true, tamano: 26)}
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="0" w:type="auto"/>
    <w:tblBorders>
      <w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/>
      <w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/>
      <w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/>
      <w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/>
      <w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/>
      <w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/>
    </w:tblBorders>
  </w:tblPr>
  <w:tr>
    ${_celdaDocx('Periodo', negrita: true)}
    ${_celdaDocx('Ingreso', negrita: true)}
    ${_celdaDocx('Egreso', negrita: true)}
    ${_celdaDocx('Neto', negrita: true)}
  </w:tr>
  $filas
</w:tbl>
${_parrafoDocx('')}
<w:sectPr/>
</w:body>
</w:document>''';
 
    final archivo = Archive();
    void agregar(String ruta, String contenido) {
      final data = Uint8List.fromList(utf8.encode(contenido));
      archivo.addFile(ArchiveFile(ruta, data.length, data));
    }
 
    agregar('[Content_Types].xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''');
 
    agregar('_rels/.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''');
 
    agregar('word/document.xml', documentXml);
 
    final bytesZip = ZipEncoder().encode(archivo);
    return Uint8List.fromList(bytesZip!);
  }
 
  /// Genera un archivo .pdf real con el resumen financiero y el balance
  /// por periodo, usando el paquete `pdf`.
  Future<Uint8List> _generarPdfBytes(ResumenFinancieroContadora r) async {
    final documento = pw.Document();
 
    documento.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Centro de Reportes - Contadora',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Finanzas y productos del taller',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Resumen financiero',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Table.fromTextArray(
            headers: ['Métrica', 'Valor'],
            data: [
              ['Movimientos', '${r.movimientos}'],
              ['Total ingresos', '\$${_formatoMiles(r.totalIngresos)}'],
              ['Proveedores', '${r.proveedores}'],
              ['Sucursales', '${r.sucursales}'],
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Balance por periodo',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Table.fromTextArray(
            headers: ['Periodo', 'Ingreso', 'Egreso', 'Neto'],
            data: r.balancePorPeriodo
                .map((b) => [
                      b.periodo,
                      '\$${_formatoMiles(b.ingreso)}',
                      '\$${_formatoMiles(b.egreso)}',
                      '\$${_formatoMiles(b.neto)}',
                    ])
                .toList(),
          ),
        ],
      ),
    );
 
    return documento.save();
  }
 
  @override
  Widget build(BuildContext context) {
    final r = _resumen;
    final rolCrudo =
        (widget.usuario?['rol'] ?? 'contadora').toString().toUpperCase();
 
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: _cargando || r == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _encabezado(rolCrudo),
                  const SizedBox(height: 14),
                  _barraAcciones(),
                  const SizedBox(height: 14),
                  _selectorTabs(),
                  const SizedBox(height: 14),
                  if (_tabSeleccionada == 0)
                    ..._contenidoFinanciero(r)
                  else
                    ..._contenidoProductos(),
                ],
              ),
      ),
    );
  }
 
  // --------------------------------------------------------------------
  // ENCABEZADO OSCURO (mismo estilo navy/dorado del resto de la app)
  // --------------------------------------------------------------------
  Widget _encabezado(String rolCrudo) {
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
                  Text(
                    '$rolCrudo · REPORTES',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dorado,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Centro de Reportes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Finanzas y productos del taller',
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
 
  // --------------------------------------------------------------------
  // BARRA DE ACCIONES: Actualizar / Exportar
  // --------------------------------------------------------------------
  Widget _barraAcciones() {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 10,
      runSpacing: 10,
      children: [
        OutlinedButton.icon(
          onPressed: _cargando ? null : _cargarDatos,
          icon: _cargando
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh, size: 16, color: AppColors.doradoOscuro),
          label: const Text('Actualizar'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.doradoOscuro,
            side: const BorderSide(color: AppColors.doradoClaro),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        PopupMenuButton<String>(
          enabled: !_exportando,
          onSelected: _exportar,
          offset: const Offset(0, 46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) => [
            _itemExportar('excel', Icons.grid_on, const Color(0xFF1D7044), 'Exportar Excel'),
            _itemExportar('word', Icons.description, const Color(0xFF2A5DB0), 'Exportar Word'),
            _itemExportar('pdf', Icons.picture_as_pdf, AppColors.rojo, 'Exportar PDF'),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.dorado, AppColors.doradoOscuro],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_exportando)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.file_download_outlined, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                const Text(
                  'Exportar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_drop_down, size: 18, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
 
  PopupMenuItem<String> _itemExportar(
      String valor, IconData icono, Color color, String texto) {
    return PopupMenuItem<String>(
      value: valor,
      child: Row(
        children: [
          Icon(icono, size: 18, color: color),
          const SizedBox(width: 10),
          Text(texto),
        ],
      ),
    );
  }
 
  // --------------------------------------------------------------------
  // SELECTOR DE PESTAÑAS (Financiero / Productos)
  // --------------------------------------------------------------------
  Widget _selectorTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro),
      ),
      child: Row(
        children: [
          Expanded(
            child: _botonTab('Financiero', Icons.attach_money, 0),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _botonTab('Productos', Icons.inventory_2_outlined, 1),
          ),
        ],
      ),
    );
  }
 
  Widget _botonTab(String texto, IconData icono, int indice) {
    final seleccionado = _tabSeleccionada == indice;
    return InkWell(
      onTap: () => setState(() => _tabSeleccionada = indice),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: seleccionado
              ? const LinearGradient(
                  colors: [AppColors.dorado, AppColors.doradoOscuro],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 16,
              color: seleccionado ? Colors.white : AppColors.textoMuted,
            ),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: seleccionado ? Colors.white : AppColors.textoMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  // --------------------------------------------------------------------
  // PESTAÑA: FINANCIERO
  // --------------------------------------------------------------------
  List<Widget> _contenidoFinanciero(ResumenFinancieroContadora r) {
    return [
      Row(
        children: [
          Expanded(
            child: _tarjetaStat(
              titulo: 'Movimientos',
              valor: '${r.movimientos}',
              icono: Icons.sync_alt,
              color: AppColors.dorado,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _tarjetaStat(
              titulo: 'Total Ingresos',
              valor: '\$${_formatoMiles(r.totalIngresos)}',
              icono: Icons.receipt_long_outlined,
              color: AppColors.rojo,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: _tarjetaStat(
              titulo: 'Proveedores',
              valor: '${r.proveedores}',
              icono: Icons.local_shipping_outlined,
              color: AppColors.azul,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _tarjetaStat(
              titulo: 'Sucursales',
              valor: '${r.sucursales}',
              icono: Icons.store_outlined,
              color: AppColors.morado,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      _tarjetaBalancePorPeriodo(r.balancePorPeriodo),
    ];
  }
 
  Widget _tarjetaStat({
    required String titulo,
    required String valor,
    required IconData icono,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 4, color: color),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        titulo.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: AppColors.textoMuted,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icono, size: 15, color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _tarjetaBalancePorPeriodo(List<BalancePeriodo> lista) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.doradoClaro),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.rojo,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Balance por periodo (últimos 12 meses)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...lista.map(_filaBalance),
        ],
      ),
    );
  }
 
  Widget _filaBalance(BalancePeriodo b) {
    final neto = b.neto;
    final esPositivo = neto >= 0;
    final colorNeto = esPositivo ? AppColors.verde : AppColors.rojo;
 
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                b.periodo,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                '${esPositivo ? '+' : '-'}\$${_formatoMiles(neto.abs())}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorNeto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingreso',
                      style: TextStyle(fontSize: 10, color: AppColors.textoMuted),
                    ),
                    Text(
                      '\$${_formatoMiles(b.ingreso)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.verde,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Egreso',
                      style: TextStyle(fontSize: 10, color: AppColors.textoMuted),
                    ),
                    Text(
                      '\$${_formatoMiles(b.egreso)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.rojo,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
 
  // --------------------------------------------------------------------
  // PESTAÑA: PRODUCTOS (placeholder — dime qué debe mostrar y lo armo)
  // --------------------------------------------------------------------
  List<Widget> _contenidoProductos() {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.doradoClaro),
        ),
        child: Column(
          children: [
            const Icon(Icons.inventory_2_outlined,
                size: 44, color: AppColors.doradoClaro),
            const SizedBox(height: 12),
            const Text(
              'Reporte de Productos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            const Text(
              'Próximamente',
              style: TextStyle(fontSize: 12, color: AppColors.textoMuted),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _mostrarProximamente('Reporte de productos'),
              child: const Text('Notificarme cuando esté listo'),
            ),
          ],
        ),
      ),
    ];
  }
}
 
// ============================================================================
// HELPERS OOXML (Word) — construyen el XML mínimo necesario para un .docx
// ============================================================================
 
String _escaparXml(String texto) => texto
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
 
String _parrafoDocx(String texto, {bool negrita = false, int tamano = 22}) {
  final propiedades = negrita
      ? '<w:rPr><w:b/><w:sz w:val="$tamano"/></w:rPr>'
      : '<w:rPr><w:sz w:val="$tamano"/></w:rPr>';
  return '<w:p><w:r>$propiedades<w:t xml:space="preserve">${_escaparXml(texto)}</w:t></w:r></w:p>';
}
 
String _celdaDocx(String texto, {bool negrita = false}) {
  return '<w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/></w:tcPr>${_parrafoDocx(texto, negrita: negrita, tamano: 20)}</w:tc>';
}