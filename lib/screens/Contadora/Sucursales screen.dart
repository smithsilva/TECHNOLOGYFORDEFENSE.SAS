import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/sucursal.dart';
import '../../services/sucursales_service.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const doradoMezcla = Color(0xFFAB812E);
  static const fondo = Color(0xFFFAF3E4);

  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);

  static const verde = Color(0xFF2E9E5B);
  static const verdeFondo = Color(0xFFDDF2E1);

  static const naranja = Color(0xFFA17A2E);
  static const naranjaFondo = Color(0xFFF5E3C3);

  static const rojo = Color(0xFFC0293B);
  static const rojoFondo = Color(0xFFFADCE0);

  static const textoMuted = Color(0xFF6B7280);
  static const enlace = Color(0xFF2563EB);

  static const rosaMuted = Color(0xFFB98CA0);
  static const azulValor = Color(0xFF1B4F91);

  static const background = fondo;
  static const navy = navyOscuro;
  static const gold = dorado;
  static const goldDark = doradoOscuro;
  static const green = verde;
  static const greenBg = verdeFondo;
  static const textDark = Color(0xFF111827);
  static const textGrey = textoMuted;
  static const white = Colors.white;
  static const cardBorder = Color(0xFFEFEFF2);
  static const cardShadow = Color(0x14000000);
}

// ==================== PANTALLA PRINCIPAL ====================
class SucursalesScreen extends StatefulWidget {
  const SucursalesScreen({super.key});

  @override
  State<SucursalesScreen> createState() => _SucursalesScreenState();
}

class _SucursalesScreenState extends State<SucursalesScreen> {
  final SucursalesService _service = SucursalesService();

  List<Sucursal> _sucursales = [];
  bool _cargando = true;
  String? _error;
  String? _token;
  bool _exportando = false;

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          _error = 'Sesión no encontrada. Vuelve a iniciar sesión.';
          _cargando = false;
        });
        return;
      }

      _token = token;
      final datos = await _service.obtenerSucursales(token);
      setState(() {
        _sucursales = datos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? AppColors.rojo : AppColors.green,
      ),
    );
  }

  Future<void> _abrirFormulario({Sucursal? sucursal}) async {
    if (_token == null) {
      _mostrarMensaje('Sesión no encontrada. Vuelve a iniciar sesión.', esError: true);
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SucursalFormSheet(
        sucursal: sucursal,
        onGuardar: (datos) => _guardarSucursal(datos, idExistente: sucursal?.id),
      ),
    );
  }

  Future<void> _guardarSucursal(Sucursal datos, {int? idExistente}) async {
    try {
      if (idExistente != null) {
        await _service.editarSucursal(_token!, idExistente, datos);
        _mostrarMensaje('Sucursal actualizada correctamente.');
      } else {
        await _service.crearSucursal(_token!, datos);
        _mostrarMensaje('Sucursal creada correctamente.');
      }
      if (mounted) Navigator.of(context).pop();
      await _cargarSucursales();
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  void _verDetalle(Sucursal sucursal) {
    showDialog(
      context: context,
      builder: (_) => _SucursalDetailDialog(sucursal: sucursal),
    );
  }

  Future<void> _confirmarEliminar(Sucursal sucursal) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('¿Eliminar sucursal?'),
        content: Text('Esta acción eliminará "${sucursal.nombre}" de forma permanente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rojo,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    if (_token == null) {
      _mostrarMensaje('Sesión no encontrada. Vuelve a iniciar sesión.', esError: true);
      return;
    }

    try {
      await _service.eliminarSucursal(_token!, sucursal.id);
      _mostrarMensaje('Sucursal eliminada correctamente.');
      await _cargarSucursales();
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  // ==================== EXPORTAR A EXCEL ====================
  Future<void> _exportarExcel() async {
    if (_sucursales.isEmpty) {
      _mostrarMensaje('No hay sucursales para exportar.', esError: true);
      return;
    }

    setState(() => _exportando = true);
    try {
      final libro = excel_pkg.Excel.createExcel();
      final hoja = libro['Sucursales'];
      libro.delete('Sheet1');

      hoja.appendRow([
        excel_pkg.TextCellValue('ID'),
        excel_pkg.TextCellValue('Nombre'),
        excel_pkg.TextCellValue('Dirección'),
        excel_pkg.TextCellValue('Ciudad'),
        excel_pkg.TextCellValue('Teléfono'),
        excel_pkg.TextCellValue('Horario Apertura'),
        excel_pkg.TextCellValue('Horario Cierre'),
        excel_pkg.TextCellValue('Estado'),
      ]);

      for (final s in _sucursales) {
        hoja.appendRow([
          excel_pkg.IntCellValue(s.id),
          excel_pkg.TextCellValue(s.nombre),
          excel_pkg.TextCellValue(s.direccion ?? '—'),
          excel_pkg.TextCellValue(s.ciudad ?? '—'),
          excel_pkg.TextCellValue(s.telefono ?? '—'),
          excel_pkg.TextCellValue(s.horarioApertura ?? '—'),
          excel_pkg.TextCellValue(s.horarioCierre ?? '—'),
          excel_pkg.TextCellValue(s.activo ? 'Activa' : 'Inactiva'),
        ]);
      }

      final bytes = libro.save();
      if (bytes == null) throw Exception('No se pudo generar el archivo.');

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/sucursales.xlsx';
      final file = File(path);
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(path)], text: 'Reporte de Sucursales');
    } catch (e) {
      _mostrarMensaje('Error al exportar a Excel: $e', esError: true);
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  // ==================== EXPORTAR A PDF ====================
  Future<void> _exportarPDF() async {
    if (_sucursales.isEmpty) {
      _mostrarMensaje('No hay sucursales para exportar.', esError: true);
      return;
    }

    setState(() => _exportando = true);
    try {
      final doc = pw.Document();

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (context) => [
            pw.Header(level: 0, text: 'Reporte de Sucursales'),
            pw.Table.fromTextArray(
              headers: [
                'ID',
                'Nombre',
                'Dirección',
                'Ciudad',
                'Teléfono',
                'Horario',
                'Estado',
              ],
              data: _sucursales
                  .map((s) => [
                        '${s.id}',
                        s.nombre,
                        s.direccion ?? '—',
                        s.ciudad ?? '—',
                        s.telefono ?? '—',
                        '${s.horarioApertura ?? '—'} - ${s.horarioCierre ?? '—'}',
                        s.activo ? 'Activa' : 'Inactiva',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF0F1B2E)),
              headerHeight: 24,
              cellHeight: 22,
              cellAlignments: {0: pw.Alignment.centerLeft},
            ),
          ],
        ),
      );

      await Printing.sharePdf(bytes: await doc.save(), filename: 'sucursales.pdf');
    } catch (e) {
      _mostrarMensaje('Error al exportar a PDF: $e', esError: true);
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _sucursales.length;
    final activas = _sucursales.where((s) => s.activo).length;

    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _cargarSucursales,
            color: AppColors.gold,
            child: _buildBody(total, activas),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _abrirFormulario(),
              backgroundColor: AppColors.navy,
              icon: const Icon(Icons.add, color: AppColors.gold),
              label: const Text('Agregar', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int total, int activas) {
    if (_cargando) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 120),
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      );
    }

    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - SUCURSALES',
            title: 'Sucursales',
            subtitle: 'No se pudieron cargar los datos',
          ),
          const SizedBox(height: 14),
          _HeaderActionButtons(
            onActualizar: _cargarSucursales,
            onExportarExcel: _exportarExcel,
            onExportarPDF: _exportarPDF,
            exportando: _exportando,
          ),
          const SizedBox(height: 24),
          _ErrorState(mensaje: _error!, onReintentar: _cargarSucursales),
        ],
      );
    }

    if (_sucursales.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - SUCURSALES',
            title: 'Sucursales',
            subtitle: '0 sucursales registradas',
          ),
          const SizedBox(height: 14),
          _HeaderActionButtons(
            onActualizar: _cargarSucursales,
            onExportarExcel: _exportarExcel,
            onExportarPDF: _exportarPDF,
            exportando: _exportando,
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'No hay sucursales registradas todavía.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        _PageHeaderCard(
          eyebrow: 'CONTADORA - SUCURSALES',
          title: 'Sucursales',
          subtitle: '$total sucursales registradas',
        ),
        const SizedBox(height: 14),
        _HeaderActionButtons(
          onActualizar: _cargarSucursales,
          onExportarExcel: _exportarExcel,
          onExportarPDF: _exportarPDF,
          exportando: _exportando,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                valor: '$total',
                label: 'Total',
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                valor: '$activas',
                label: 'Activas',
                color: AppColors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...List.generate(_sucursales.length, (index) {
          final sucursal = _sucursales[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SucursalCard(
              numero: '#${index + 1}',
              sucursal: sucursal,
              onVer: () => _verDetalle(sucursal),
              onEditar: () => _abrirFormulario(sucursal: sucursal),
              onEliminar: () => _confirmarEliminar(sucursal),
            ),
          );
        }),
      ],
    );
  }
}

// ==================== ESTADO DE ERROR ====================
class _ErrorState extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorState({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.rojo.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.rojo, size: 32),
          const SizedBox(height: 10),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onReintentar,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ENCABEZADO ====================
class _PageHeaderCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _PageHeaderCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.subtitulo,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BOTONES DE ACTUALIZAR / EXPORTAR ====================
class _HeaderActionButtons extends StatelessWidget {
  final VoidCallback onActualizar;
  final VoidCallback onExportarExcel;
  final VoidCallback onExportarPDF;
  final bool exportando;

  const _HeaderActionButtons({
    required this.onActualizar,
    required this.onExportarExcel,
    required this.onExportarPDF,
    required this.exportando,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GoldActionButton(
            icon: Icons.refresh,
            label: 'Actualizar',
            onTap: onActualizar,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PopupMenuButton<String>(
            enabled: !exportando,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (valor) {
              if (valor == 'excel') onExportarExcel();
              if (valor == 'pdf') onExportarPDF();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    Icon(Icons.grid_on, size: 18, color: Color(0xFF1D6F42)),
                    SizedBox(width: 10),
                    Text('Exportar Excel'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 18, color: Color(0xFFE53935)),
                    SizedBox(width: 10),
                    Text('Exportar PDF'),
                  ],
                ),
              ),
            ],
            child: _GoldActionButton(
              icon: Icons.download,
              label: exportando ? 'Exportando...' : 'Exportar',
              onTap: null,
              cargando: exportando,
              mostrarFlecha: !exportando,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoldActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool cargando;
  final bool mostrarFlecha;

  const _GoldActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.cargando = false,
    this.mostrarFlecha = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.dorado, AppColors.doradoOscuro],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.doradoOscuro.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cargando
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (mostrarFlecha) ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== TARJETA DE ESTADÍSTICA ====================
class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BADGE DE ESTADO (activo) ====================
class _EstadoBadge extends StatelessWidget {
  final bool activo;

  const _EstadoBadge({required this.activo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? AppColors.greenBg : const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        activo ? 'Activa' : 'Inactiva',
        style: TextStyle(
          color: activo ? AppColors.green : AppColors.textGrey,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ==================== FILA ETIQUETA / VALOR ====================
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.rosaMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.azulValor,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BOTÓN DE ACCIÓN PEQUEÑO ====================
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.doradoClaro),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ==================== TARJETA DE SUCURSAL ====================
class _SucursalCard extends StatelessWidget {
  final String numero;
  final Sucursal sucursal;
  final VoidCallback onVer;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _SucursalCard({
    required this.numero,
    required this.sucursal,
    required this.onVer,
    required this.onEditar,
    required this.onEliminar,
  });

  String get _horario {
    final apertura = sucursal.horarioApertura;
    final cierre = sucursal.horarioCierre;
    if (apertura == null && cierre == null) return '—';
    return '${apertura ?? '—'} - ${cierre ?? '—'}';
  }

  @override
  Widget build(BuildContext context) {
    final bool activa = sucursal.activo;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: activa ? AppColors.green : AppColors.textGrey,
            ),
            Expanded(
              child: InkWell(
                onTap: onVer,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$numero ',
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: sucursal.nombre,
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _EstadoBadge(activo: activa),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${sucursal.id}',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 10.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, color: AppColors.cardBorder),
                      const SizedBox(height: 6),
                      _InfoRow(label: 'Ciudad', value: sucursal.ciudad ?? '—'),
                      _InfoRow(label: 'Dirección', value: sucursal.direccion ?? '—'),
                      _InfoRow(label: 'Teléfono', value: sucursal.telefono ?? '—'),
                      _InfoRow(label: 'Horario', value: _horario),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _ActionIconButton(
                            icon: Icons.visibility_outlined,
                            color: AppColors.textDark,
                            background: AppColors.white,
                            onTap: onVer,
                          ),
                          const SizedBox(width: 8),
                          _ActionIconButton(
                            icon: Icons.edit_outlined,
                            color: AppColors.doradoOscuro,
                            background: AppColors.fondo,
                            onTap: onEditar,
                          ),
                          const SizedBox(width: 8),
                          _ActionIconButton(
                            icon: Icons.delete_outline,
                            color: AppColors.rojo,
                            background: AppColors.rojoFondo,
                            onTap: onEliminar,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DIÁLOGO DE DETALLE (VER) ====================
class _SucursalDetailDialog extends StatelessWidget {
  final Sucursal sucursal;

  const _SucursalDetailDialog({required this.sucursal});

  String get _horario {
    final apertura = sucursal.horarioApertura;
    final cierre = sucursal.horarioCierre;
    if (apertura == null && cierre == null) return '—';
    return '${apertura ?? '—'} - ${cierre ?? '—'}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detalle de la Sucursal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColors.textGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            _InfoRow(label: 'Nombre', value: sucursal.nombre),
            _InfoRow(label: 'Dirección', value: sucursal.direccion ?? '—'),
            _InfoRow(label: 'Ciudad', value: sucursal.ciudad ?? '—'),
            _InfoRow(label: 'Teléfono', value: sucursal.telefono ?? '—'),
            _InfoRow(label: 'Horario', value: _horario),
            _InfoRow(label: 'Estado', value: sucursal.activo ? 'Activa' : 'Inactiva'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HOJA DE FORMULARIO (AGREGAR / EDITAR) ====================
class _SucursalFormSheet extends StatefulWidget {
  final Sucursal? sucursal;
  final Future<void> Function(Sucursal datos) onGuardar;

  const _SucursalFormSheet({this.sucursal, required this.onGuardar});

  @override
  State<_SucursalFormSheet> createState() => _SucursalFormSheetState();
}

class _SucursalFormSheetState extends State<_SucursalFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _ciudadCtrl;
  late final TextEditingController _telefonoCtrl;

  TimeOfDay? _apertura;
  TimeOfDay? _cierre;
  bool _activo = true;
  bool _guardando = false;

  bool get _esEdicion => widget.sucursal != null;

  @override
  void initState() {
    super.initState();
    final s = widget.sucursal;
    _nombreCtrl = TextEditingController(text: s?.nombre ?? '');
    _direccionCtrl = TextEditingController(text: s?.direccion ?? '');
    _ciudadCtrl = TextEditingController(text: s?.ciudad ?? '');
    _telefonoCtrl = TextEditingController(text: s?.telefono ?? '');
    _apertura = _parseHora(s?.horarioApertura);
    _cierre = _parseHora(s?.horarioCierre);
    _activo = s?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  TimeOfDay? _parseHora(String? valor) {
    if (valor == null || valor.isEmpty) return null;
    final partes = valor.split(':');
    if (partes.length < 2) return null;
    final hora = int.tryParse(partes[0]);
    final minuto = int.tryParse(partes[1]);
    if (hora == null || minuto == null) return null;
    return TimeOfDay(hour: hora, minute: minuto);
  }

  String _formatearHora(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _seleccionarHora({required bool esApertura}) async {
    final actual = esApertura ? _apertura : _cierre;
    final elegido = await showTimePicker(
      context: context,
      initialTime: actual ?? TimeOfDay.now(),
    );
    if (elegido == null) return;
    setState(() {
      if (esApertura) {
        _apertura = elegido;
      } else {
        _cierre = elegido;
      }
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final datos = Sucursal(
      id: widget.sucursal?.id ?? 0,
      nombre: _nombreCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
      ciudad: _ciudadCtrl.text.trim().isEmpty ? null : _ciudadCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      horarioApertura: _apertura == null ? null : _formatearHora(_apertura!),
      horarioCierre: _cierre == null ? null : _formatearHora(_cierre!),
      activo: _activo,
    );

    await widget.onGuardar(datos);

    if (mounted) setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  _esEdicion ? 'Editar Sucursal' : 'Agregar Sucursal',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                _campoTexto(controller: _nombreCtrl, label: 'Nombre de la Sucursal', requerido: true),
                _campoTexto(controller: _direccionCtrl, label: 'Dirección'),
                _campoTexto(controller: _ciudadCtrl, label: 'Ciudad'),
                _campoTexto(controller: _telefonoCtrl, label: 'Teléfono', tipoTeclado: TextInputType.phone),
                Row(
                  children: [
                    Expanded(
                      child: _campoHora(
                        label: 'Horario Apertura',
                        valor: _apertura,
                        onTap: () => _seleccionarHora(esApertura: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _campoHora(
                        label: 'Horario Cierre',
                        valor: _cierre,
                        onTap: () => _seleccionarHora(esApertura: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.gold,
                  title: const Text(
                    'Sucursal activa',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  value: _activo,
                  onChanged: (v) => setState(() => _activo = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _guardando ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.cardBorder),
                        ),
                        child: const Text('Cancelar', style: TextStyle(color: AppColors.textDark)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _guardando ? null : _guardar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _guardando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
                              )
                            : Text(_esEdicion ? 'Actualizar' : 'Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    bool requerido = false,
    TextInputType? tipoTeclado,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: tipoTeclado,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12.5, color: AppColors.textGrey),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
          ),
        ),
        validator: requerido
            ? (v) => (v == null || v.trim().isEmpty) ? 'Este campo es obligatorio' : null
            : null,
      ),
    );
  }

  Widget _campoHora({
    required String label,
    required TimeOfDay? valor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 12.5, color: AppColors.textGrey),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                valor == null ? '—' : _formatearHora(valor),
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const Icon(Icons.access_time, size: 16, color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}