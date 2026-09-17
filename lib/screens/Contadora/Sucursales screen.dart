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
  static const background = Color(0xFFF7EFDD);
  static const navy = Color(0xFF101B33);
  static const gold = Color(0xFFC9A24A);
  static const goldDark = Color(0xFF8A6D1F);
  static const goldText = Color(0xFFD2A03C);
  static const lightBlue = Color(0xFF9FB4DE);
  static const inputBg = Color(0xFFEFE4CB);
  static const iconBg = Color(0xFFF0E3BE);
  static const cardBorder = Color(0xFFECE0BD);

  static const green = Color(0xFF2E9E4E);
  static const greenBg = Color(0xFFDCF2E3);
  static const olive = Color(0xFF8B7920);
  static const oliveBg = Color(0xFFF3ECD2);
  static const red = Color(0xFFC24555);
  static const redBg = Color(0xFFF8DCE0);

  // Colores auxiliares que no venían en la paleta pero que la pantalla
  // necesita (texto, tarjetas, sombra).
  static const white = Colors.white;
  static const textDark = Color(0xFF111827);
  static const textGrey = Color(0xFF6B7280);
  static const cardShadow = Color(0x14000000);
}

enum _FiltroEstado { todos, activa, inactiva }

// ==================== PANTALLA PRINCIPAL ====================
class SucursalesScreen extends StatefulWidget {
  const SucursalesScreen({super.key});

  @override
  State<SucursalesScreen> createState() => _SucursalesScreenState();
}

class _SucursalesScreenState extends State<SucursalesScreen> {
  final SucursalesService _service = SucursalesService();
  final TextEditingController _busquedaCtrl = TextEditingController();

  List<Sucursal> _sucursales = [];
  bool _cargando = true;
  String? _error;
  String? _token;
  bool _exportando = false;

  bool _filtrosAbiertos = true;
  _FiltroEstado _filtroEstado = _FiltroEstado.todos;

  // NOTA IMPORTANTE:
  // El modelo `Sucursal` y el servicio no tienen un campo "encargado".
  // Como solo se puede modificar este archivo, el nombre del encargado se
  // guarda aquí en memoria (no se envía ni se guarda en el backend). Si
  // luego agregas una columna "encargado" al modelo/servicio, reemplaza
  // este mapa por el valor real que venga de la API.
  final Map<int, String> _encargados = {};

  String _encargadoDe(Sucursal s) => _encargados[s.id] ?? '—';

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
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
        backgroundColor: esError ? AppColors.red : AppColors.green,
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
        encargadoInicial: sucursal == null ? '' : _encargados[sucursal.id] ?? '',
        onGuardar: (datos, encargado) => _guardarSucursal(
          datos,
          encargado,
          idExistente: sucursal?.id,
        ),
      ),
    );
  }

  Future<void> _guardarSucursal(
    Sucursal datos,
    String encargado, {
    int? idExistente,
  }) async {
    try {
      if (idExistente != null) {
        await _service.editarSucursal(_token!, idExistente, datos);
        setState(() {
          if (encargado.trim().isEmpty) {
            _encargados.remove(idExistente);
          } else {
            _encargados[idExistente] = encargado.trim();
          }
        });
        _mostrarMensaje('Sucursal actualizada correctamente.');
        if (mounted) Navigator.of(context).pop();
        await _cargarSucursales();
      } else {
        await _service.crearSucursal(_token!, datos);
        _mostrarMensaje('Sucursal creada correctamente.');
        await _cargarSucursales();
        if (encargado.trim().isNotEmpty) {
          // Busca la sucursal recién creada (por nombre + ciudad) para
          // asociarle el encargado localmente, ya que el backend no lo guarda.
          final creada = _sucursales.where(
            (s) => s.nombre == datos.nombre && s.ciudad == datos.ciudad,
          );
          if (creada.isNotEmpty) {
            setState(() => _encargados[creada.first.id] = encargado.trim());
          }
        }
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  void _verDetalle(Sucursal sucursal) {
    showDialog(
      context: context,
      builder: (_) => _SucursalDetailDialog(
        sucursal: sucursal,
        encargado: _encargadoDe(sucursal),
        onEditar: () {
          Navigator.of(context).pop();
          _abrirFormulario(sucursal: sucursal);
        },
        onEliminar: () {
          Navigator.of(context).pop();
          _confirmarEliminar(sucursal);
        },
      ),
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
              backgroundColor: AppColors.red,
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
      setState(() => _encargados.remove(sucursal.id));
      _mostrarMensaje('Sucursal eliminada correctamente.');
      await _cargarSucursales();
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
      _filtroEstado = _FiltroEstado.todos;
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

  List<Sucursal> get _filtradas {
    final texto = _normalizar(_busquedaCtrl.text);
    return _sucursales.where((s) {
      final coincideTexto = texto.isEmpty ||
          _normalizar(s.nombre).contains(texto) ||
          _normalizar(s.ciudad ?? '').contains(texto) ||
          _normalizar(_encargadoDe(s)).contains(texto);

      final coincideEstado = switch (_filtroEstado) {
        _FiltroEstado.todos => true,
        _FiltroEstado.activa => s.activo,
        _FiltroEstado.inactiva => !s.activo,
      };

      return coincideTexto && coincideEstado;
    }).toList();
  }

  // NOTA: se dejaron ambos métodos de exportación intactos (sin quitarlos)
  // aunque ya no hay un botón en pantalla que los dispare, por si luego
  // quieres volver a engancharlos desde otro lugar (por ejemplo un menú).

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
              headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF101B33)),
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
    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: _cargarSucursales,
        color: AppColors.gold,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return ListView(
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 120),
            child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
          ),
        ],
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
            onAgregar: () => _abrirFormulario(),
          ),
          const SizedBox(height: 24),
          _ErrorState(mensaje: _error!, onReintentar: _cargarSucursales),
        ],
      );
    }

    final total = _sucursales.length;
    final activas = _sucursales.where((s) => s.activo).length;
    final filtradas = _filtradas;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        _PageHeaderCard(
          eyebrow: 'CONTADORA - SUCURSALES',
          title: 'Sucursales',
          subtitle: '$total sucursales registradas',
          onAgregar: () => _abrirFormulario(),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(label: 'Total', value: '$total', accentColor: AppColors.gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(label: 'Activas', value: '$activas', accentColor: AppColors.green),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildPanelFiltros(),
        const SizedBox(height: 14),
        if (total == 0)
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'No hay sucursales registradas todavía.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
          )
        else ...[
          Text(
            '${filtradas.length} ${filtradas.length == 1 ? "SUCURSAL" : "SUCURSALES"}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          if (filtradas.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'No se encontraron sucursales con esos filtros.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
              ),
            )
          else
            ...List.generate(filtradas.length, (index) {
              final sucursal = filtradas[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SucursalCard(
                  numero: index + 1,
                  sucursal: sucursal,
                  encargado: _encargadoDe(sucursal),
                  onVer: () => _verDetalle(sucursal),
                ),
              );
            }),
        ],
      ],
    );
  }

  Widget _buildPanelFiltros() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
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
                  const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.goldDark),
                  const SizedBox(width: 8),
                  const Text('Filtros y Búsqueda',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const Spacer(),
                  Icon(
                    _filtrosAbiertos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_filtrosAbiertos) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: TextField(
                controller: _busquedaCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, ciudad o encargado...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: AppColors.inputBg,
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
                    borderSide: const BorderSide(color: AppColors.navy),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                children: [
                  _FiltroEstadoChip(
                    label: 'Todos',
                    seleccionado: _filtroEstado == _FiltroEstado.todos,
                    onTap: () => setState(() => _filtroEstado = _FiltroEstado.todos),
                  ),
                  const SizedBox(width: 8),
                  _FiltroEstadoChip(
                    label: 'Activa',
                    seleccionado: _filtroEstado == _FiltroEstado.activa,
                    onTap: () => setState(() => _filtroEstado = _FiltroEstado.activa),
                  ),
                  const SizedBox(width: 8),
                  _FiltroEstadoChip(
                    label: 'Inactiva',
                    seleccionado: _filtroEstado == _FiltroEstado.inactiva,
                    onTap: () => setState(() => _filtroEstado = _FiltroEstado.inactiva),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _limpiarFiltros,
                  icon: const Icon(Icons.close, size: 14),
                  label: const Text('Limpiar filtros', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(foregroundColor: AppColors.goldDark),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== CHIP DE FILTRO DE ESTADO ====================
class _FiltroEstadoChip extends StatelessWidget {
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  const _FiltroEstadoChip({
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: seleccionado ? AppColors.goldText : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== BADGE DE ESTADO ====================
class _EstadoBadge extends StatelessWidget {
  final bool activo;

  const _EstadoBadge({required this.activo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? AppColors.greenBg : AppColors.redBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        activo ? 'Activa' : 'Inactiva',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: activo ? AppColors.green : AppColors.red,
        ),
      ),
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
        border: Border.all(color: AppColors.red.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.red, size: 32),
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
  final VoidCallback? onAgregar;

  const _PageHeaderCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                    color: AppColors.lightBlue,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          if (onAgregar != null) ...[
            const SizedBox(width: 12),
            Material(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onAgregar,
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(Icons.add, color: AppColors.navy, size: 24),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ESTADÍSTICA ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== FILA ETIQUETA / VALOR ====================
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE SUCURSAL ====================
class _SucursalCard extends StatelessWidget {
  final int numero;
  final Sucursal sucursal;
  final String encargado;
  final VoidCallback onVer;

  const _SucursalCard({
    required this.numero,
    required this.sucursal,
    required this.encargado,
    required this.onVer,
  });

  String get _codigo => 'SUC-${numero.toString().padLeft(3, '0')}';

  @override
  Widget build(BuildContext context) {
    final activa = sucursal.activo;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: activa ? AppColors.green : AppColors.textGrey),
            Expanded(
              child: InkWell(
                onTap: onVer,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
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
                                    text: '#$numero ',
                                    style: const TextStyle(
                                      color: AppColors.goldText,
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
                      const SizedBox(height: 3),
                      Text(
                        _codigo,
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, color: AppColors.cardBorder),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sucursal.ciudad ?? '—',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                          ),
                          Text(
                            encargado,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
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
  final String encargado;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _SucursalDetailDialog({
    required this.sucursal,
    required this.encargado,
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
            _InfoRow(label: 'ID', value: '${sucursal.id}'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estado', style: TextStyle(fontSize: 10.5, color: AppColors.textGrey)),
                  _EstadoBadge(activo: sucursal.activo),
                ],
              ),
            ),
            _InfoRow(label: 'Nombre', value: sucursal.nombre),
            _InfoRow(label: 'Ciudad', value: sucursal.ciudad ?? '—'),
            _InfoRow(label: 'Dirección', value: sucursal.direccion ?? '—'),
            _InfoRow(label: 'Teléfono', value: sucursal.telefono ?? '—'),
            _InfoRow(label: 'Horario', value: _horario),
            _InfoRow(label: 'Encargado', value: encargado),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEditar,
                    icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.goldDark),
                    label: const Text('Editar', style: TextStyle(color: AppColors.goldDark)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.navy),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEliminar,
                    icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.red),
                    label: const Text('Eliminar', style: TextStyle(color: AppColors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
  final String encargadoInicial;
  final Future<void> Function(Sucursal datos, String encargado) onGuardar;

  const _SucursalFormSheet({
    this.sucursal,
    required this.encargadoInicial,
    required this.onGuardar,
  });

  @override
  State<_SucursalFormSheet> createState() => _SucursalFormSheetState();
}

class _SucursalFormSheetState extends State<_SucursalFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _ciudadCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _encargadoCtrl;

  late bool _activo;
  bool _guardando = false;

  bool get _esEdicion => widget.sucursal != null;

  @override
  void initState() {
    super.initState();
    final s = widget.sucursal;
    _nombreCtrl = TextEditingController(text: s?.nombre ?? '');
    _ciudadCtrl = TextEditingController(text: s?.ciudad ?? '');
    _direccionCtrl = TextEditingController(text: s?.direccion ?? '');
    _telefonoCtrl = TextEditingController(text: s?.telefono ?? '');
    _encargadoCtrl = TextEditingController(text: widget.encargadoInicial);
    _activo = s?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _ciudadCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _encargadoCtrl.dispose();
    super.dispose();
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
      horarioApertura: widget.sucursal?.horarioApertura,
      horarioCierre: widget.sucursal?.horarioCierre,
      activo: _activo,
    );

    await widget.onGuardar(datos, _encargadoCtrl.text.trim());

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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONTADORA · SUCURSALES',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _esEdicion ? 'Editar Sucursal' : 'Nueva Sucursal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                _campoTexto(controller: _nombreCtrl, label: 'Nombre', requerido: true),
                _campoTexto(controller: _ciudadCtrl, label: 'Ciudad'),
                _campoTexto(controller: _direccionCtrl, label: 'Dirección'),
                _campoTexto(controller: _telefonoCtrl, label: 'Teléfono', tipoTeclado: TextInputType.phone),
                _campoTexto(controller: _encargadoCtrl, label: 'Encargado'),
                const Text(
                  'Estado',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _EstadoToggle(
                        label: 'Activa',
                        seleccionado: _activo,
                        onTap: () => setState(() => _activo = true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _EstadoToggle(
                        label: 'Inactiva',
                        seleccionado: !_activo,
                        onTap: () => setState(() => _activo = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guardando ? null : _guardar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _guardando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
                          )
                        : Text(
                            _esEdicion ? 'Actualizar Sucursal' : 'Crear Sucursal',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _guardando ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.cardBorder),
                    ),
                    child: const Text('Cancelar', style: TextStyle(color: AppColors.textDark)),
                  ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: tipoTeclado,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
              ),
            ),
            validator: requerido
                ? (v) => (v == null || v.trim().isEmpty) ? 'Este campo es obligatorio' : null
                : null,
          ),
        ],
      ),
    );
  }
}

// ==================== TOGGLE DE ESTADO (FORMULARIO) ====================
class _EstadoToggle extends StatelessWidget {
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  const _EstadoToggle({
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: seleccionado ? AppColors.goldText : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}