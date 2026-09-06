import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/categoria.dart';
import '../../services/categorias_service.dart';

// ─── Paleta (igual a Inventario / Movimientos) ────────────────────────────
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

class CategoriasScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const CategoriasScreen({super.key, this.usuario});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  final CategoriasService _categoriasService = CategoriasService();

  bool _cargando = false;
  String? _error;
  List<CategoriaBlindaje> _categorias = [];
  String? _token;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<String?> _obtenerToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Future<void> _cargarCategorias() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final token = await _obtenerToken();
      if (token == null) throw Exception('Sesión expirada, vuelve a iniciar sesión');

      final data = await _categoriasService.obtenerCategorias(token);
      setState(() => _categorias = data);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
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

  List<CategoriaBlindaje> get _filtradas {
    final texto = _normalizar(_busquedaCtrl.text);
    if (texto.isEmpty) return _categorias;
    return _categorias.where((c) {
      return _normalizar(c.nombre).contains(texto) ||
          _normalizar(c.descripcion).contains(texto) ||
          _normalizar(c.codigo).contains(texto);
    }).toList();
  }

  int get _totalActivas => _categorias.where((c) => c.activa).length;
  int get _totalInactivas => _categorias.where((c) => !c.activa).length;

  // ══════════════════════════════════════════════════════════════════════
  // ─── HELPERS DE DISEÑO COMPARTIDOS PARA EL MODAL DE DETALLE ────────────
  // ══════════════════════════════════════════════════════════════════════

  Future<T?> _mostrarDialogoBase<T>({required Widget child}) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }

  Widget _headerDialogo({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyOscuro, AppColors.navyClaro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.dorado.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.dorado, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitulo,
                  style: const TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _filaDetalleIcono(IconData icon, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.doradoOscuro),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cajaStat(String label, String valor, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.fondo,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textoMuted, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // ─── VER DETALLE (solo lectura) ─────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════
  void _verDetalle(CategoriaBlindaje c) {
    _mostrarDialogoBase(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerDialogo(
            icon: Icons.shield_outlined,
            titulo: c.nombre,
            subtitulo: 'ID #${c.id}',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: c.activa ? AppColors.verde : AppColors.rojo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                c.activa ? 'ACTIVA' : 'INACTIVA',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Column(
              children: [
                _filaDetalleIcono(
                  Icons.notes_outlined,
                  'Descripción',
                  c.descripcion.isEmpty ? 'Sin descripción' : c.descripcion,
                ),
                _filaDetalleIcono(Icons.qr_code_2, 'Código', c.codigo),
                if (c.categoriaPadre != null)
                  _filaDetalleIcono(Icons.account_tree_outlined, 'Categoría padre', c.categoriaPadre.toString()),
                const SizedBox(height: 6),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _cajaStat(
                        'Estado',
                        c.activa ? 'Activa' : 'Inactiva',
                        c.activa ? AppColors.verde : AppColors.rojo,
                        Icons.toggle_on_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _cajaStat('ID', '#${c.id}', AppColors.dorado, Icons.tag),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text('Cerrar',
                    style: TextStyle(color: AppColors.textoMuted, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarCategorias,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildStats(),
            const SizedBox(height: 14),
            _buildBuscador(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Categorías Registradas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${_filtradas.length} categoría${_filtradas.length != 1 ? "s" : ""}',
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
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 40, color: AppColors.rojo),
                      const SizedBox(height: 8),
                      Text(_error!, style: const TextStyle(color: AppColors.rojo)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _cargarCategorias,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_filtradas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.shield_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'No se encontraron categorías',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._filtradas.map((c) => _tarjetaCategoria(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CATEGORÍAS · BLINDAJE',
                  style: TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Categorías de Blindaje',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestión de niveles de protección balística',
                  style: TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            '${_categorias.length}',
            'Total Categorías',
            'niveles registrados',
            AppColors.dorado,
            Icons.shield_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            '$_totalActivas',
            'Activas',
            'en uso',
            AppColors.verde,
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            '$_totalInactivas',
            'Inactivas',
            'deshabilitadas',
            AppColors.rojo,
            Icons.cancel_outlined,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String valor, String label, String sublabel, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: color, width: 3)),
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
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textoMuted, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(sublabel, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
        ],
      ),
    );
  }

  Widget _buildBuscador() {
    return TextField(
      controller: _busquedaCtrl,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Buscar categoría...',
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
          borderSide: const BorderSide(color: AppColors.dorado),
        ),
      ),
    );
  }

  Widget _tarjetaCategoria(CategoriaBlindaje c) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _verDetalle(c),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
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
                  c.codigo,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.doradoOscuro,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // ─── Badge de estado (solo informativo, sin toggle) ───
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.activa ? AppColors.verdeFondo : AppColors.rojoFondo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        c.activa ? Icons.check_circle : Icons.cancel,
                        size: 11,
                        color: c.activa ? AppColors.verde : AppColors.rojo,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        c.activa ? 'Activa' : 'Inactiva',
                        style: TextStyle(
                          color: c.activa ? AppColors.verde : AppColors.rojo,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: AppColors.fondo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shield, size: 17, color: AppColors.doradoOscuro),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c.descripcion,
                        style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}