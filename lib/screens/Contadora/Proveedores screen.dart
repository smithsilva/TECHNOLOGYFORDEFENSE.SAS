import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/proveedor.dart';
import '../../services/proveedores_service.dart';

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
class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  final ProveedoresService _service = ProveedoresService();
  final TextEditingController _busquedaCtrl = TextEditingController();

  List<Proveedor> _proveedores = [];
  bool _cargando = true;
  String? _error;
  String? _token;

  bool _filtrosAbiertos = true;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarProveedores() async {
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
      final datos = await _service.obtenerProveedores(token);
      setState(() {
        _proveedores = datos;
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

  Future<void> _abrirFormulario({Proveedor? proveedor}) async {
    if (_token == null) {
      _mostrarMensaje('Sesión no encontrada. Vuelve a iniciar sesión.', esError: true);
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProveedorFormSheet(
        proveedor: proveedor,
        onGuardar: (datos) => _guardarProveedor(datos, idExistente: proveedor?.id),
      ),
    );
  }

  Future<void> _guardarProveedor(Proveedor datos, {int? idExistente}) async {
    try {
      if (idExistente != null) {
        await _service.editarProveedor(_token!, idExistente, datos);
        _mostrarMensaje('Proveedor actualizado correctamente.');
      } else {
        await _service.crearProveedor(_token!, datos);
        _mostrarMensaje('Proveedor creado correctamente.');
      }
      if (mounted) Navigator.of(context).pop();
      await _cargarProveedores();
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  void _verDetalle(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (_) => _ProveedorDetailDialog(proveedor: proveedor),
    );
  }

  Future<void> _confirmarEliminar(Proveedor proveedor) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('¿Eliminar proveedor?'),
        content: Text('Esta acción eliminará "${proveedor.nombre}" de forma permanente.'),
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
      await _service.eliminarProveedor(_token!, proveedor.id);
      _mostrarMensaje('Proveedor eliminado correctamente.');
      await _cargarProveedores();
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''), esError: true);
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaCtrl.clear();
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

  List<Proveedor> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    if (texto.isEmpty) return _proveedores;
    return _proveedores.where((p) {
      return _normalizar(p.nombre).contains(texto) ||
          _normalizar(p.nit ?? '').contains(texto) ||
          _normalizar(p.direccion ?? '').contains(texto) ||
          _normalizar(p.contacto ?? '').contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: _cargarProveedores,
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
            eyebrow: 'CONTADORA - PROVEEDORES',
            title: 'Proveedores',
            subtitle: 'No se pudieron cargar los datos',
            onAgregar: () => _abrirFormulario(),
          ),
          const SizedBox(height: 24),
          _ErrorState(mensaje: _error!, onReintentar: _cargarProveedores),
        ],
      );
    }

    final total = _proveedores.length;
    final filtrados = _filtrados;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        _PageHeaderCard(
          eyebrow: 'CONTADORA - PROVEEDORES',
          title: 'Proveedores',
          subtitle: '$total proveedores registrados',
          onAgregar: () => _abrirFormulario(),
        ),
        const SizedBox(height: 14),
        _StatCard(label: 'Total', value: '$total', accentColor: AppColors.gold),
        const SizedBox(height: 14),
        _buildPanelFiltros(),
        const SizedBox(height: 14),
        if (total == 0)
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'No hay proveedores registrados todavía.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
          )
        else ...[
          Text(
            '${filtrados.length} ${filtrados.length == 1 ? "PROVEEDOR" : "PROVEEDORES"}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          if (filtrados.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'No se encontraron proveedores con esos filtros.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
              ),
            )
          else
            ...List.generate(filtrados.length, (index) {
              final proveedor = filtrados[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProveedorCard(
                  proveedor: proveedor,
                  onVer: () => _verDetalle(proveedor),
                  onEditar: () => _abrirFormulario(proveedor: proveedor),
                  onEliminar: () => _confirmarEliminar(proveedor),
                ),
              );
            }),
        ],
      ],
    );
  }

  // ------------------------------------------------------------
  // Panel "Filtros y Búsqueda" — solo buscador, sin filtro de
  // estado (tu modelo Proveedor no tiene ese campo).
  // ------------------------------------------------------------
  Widget _buildPanelFiltros() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
                  const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.doradoOscuro),
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
                  hintText: 'Buscar por nombre, NIT, dirección o contacto...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade400),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.gold),
                  ),
                ),
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
                  style: TextButton.styleFrom(foregroundColor: AppColors.doradoOscuro),
                ),
              ),
            ),
          ],
        ],
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
        border: Border.all(color: AppColors.gold, width: 1.2),
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
                    color: AppColors.subtitulo,
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
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(height: 4, color: accentColor),
          Padding(
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
        ],
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

// ==================== TARJETA DE PROVEEDOR ====================
class _ProveedorCard extends StatelessWidget {
  final Proveedor proveedor;
  final VoidCallback onVer;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _ProveedorCard({
    required this.proveedor,
    required this.onVer,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
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
            Container(width: 4, color: AppColors.enlace),
            Expanded(
              child: InkWell(
                onTap: onVer,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proveedor.nombre,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'NIT: ${proveedor.nit ?? '—'}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, color: AppColors.cardBorder),
                      const SizedBox(height: 8),
                      _InfoRow(label: 'Contacto', value: proveedor.contacto ?? '—'),
                      _InfoRow(label: 'Teléfono', value: proveedor.telefono ?? '—'),
                      _InfoRow(
                        label: 'Correo',
                        value: proveedor.email ?? '—',
                        valueColor: AppColors.enlace,
                      ),
                      _InfoRow(label: 'Dirección', value: proveedor.direccion ?? '—'),
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
class _ProveedorDetailDialog extends StatelessWidget {
  final Proveedor proveedor;

  const _ProveedorDetailDialog({required this.proveedor});

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
                  'Detalle del Proveedor',
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
            _InfoRow(label: 'ID', value: '${proveedor.id}'),
            _InfoRow(label: 'NIT', value: proveedor.nit ?? '—'),
            _InfoRow(label: 'Nombre', value: proveedor.nombre),
            _InfoRow(label: 'Teléfono', value: proveedor.telefono ?? '—'),
            _InfoRow(label: 'Correo', value: proveedor.email ?? '—'),
            _InfoRow(label: 'Dirección', value: proveedor.direccion ?? '—'),
            _InfoRow(label: 'Contacto', value: proveedor.contacto ?? '—'),
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
class _ProveedorFormSheet extends StatefulWidget {
  final Proveedor? proveedor;
  final Future<void> Function(Proveedor datos) onGuardar;

  const _ProveedorFormSheet({this.proveedor, required this.onGuardar});

  @override
  State<_ProveedorFormSheet> createState() => _ProveedorFormSheetState();
}

class _ProveedorFormSheetState extends State<_ProveedorFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nitCtrl;
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _contactoCtrl;

  bool _guardando = false;

  bool get _esEdicion => widget.proveedor != null;

  @override
  void initState() {
    super.initState();
    final p = widget.proveedor;
    _nitCtrl = TextEditingController(text: p?.nit ?? '');
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _telefonoCtrl = TextEditingController(text: p?.telefono ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
    _direccionCtrl = TextEditingController(text: p?.direccion ?? '');
    _contactoCtrl = TextEditingController(text: p?.contacto ?? '');
  }

  @override
  void dispose() {
    _nitCtrl.dispose();
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    _direccionCtrl.dispose();
    _contactoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final datos = Proveedor(
      id: widget.proveedor?.id ?? 0,
      nit: _nitCtrl.text.trim().isEmpty ? null : _nitCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
      contacto: _contactoCtrl.text.trim().isEmpty ? null : _contactoCtrl.text.trim(),
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
                  _esEdicion ? 'Editar Proveedor' : 'Agregar Proveedor',
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
                _campoTexto(controller: _nitCtrl, label: 'NIT'),
                _campoTexto(controller: _nombreCtrl, label: 'Nombre del Proveedor', requerido: true),
                _campoTexto(controller: _telefonoCtrl, label: 'Teléfono', tipoTeclado: TextInputType.phone),
                _campoTexto(
                  controller: _emailCtrl,
                  label: 'Correo',
                  tipoTeclado: TextInputType.emailAddress,
                  validarEmail: true,
                ),
                _campoTexto(controller: _direccionCtrl, label: 'Dirección'),
                _campoTexto(controller: _contactoCtrl, label: 'Contacto'),
                const SizedBox(height: 6),
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
    bool validarEmail = false,
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
        validator: (v) {
          if (requerido && (v == null || v.trim().isEmpty)) {
            return 'Este campo es obligatorio';
          }
          if (validarEmail && v != null && v.trim().isNotEmpty) {
            final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
            if (!regex.hasMatch(v.trim())) return 'Correo inválido';
          }
          return null;
        },
      ),
    );
  }
}