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

  // ids de categorías cuyo toggle está en proceso (para deshabilitar el switch mientras responde el servidor)
  final Set<int> _actualizandoEstado = {};

  int? get _idRol => widget.usuario?['id_rol'] as int?;
  bool get _esAdmin => _idRol == 1;

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

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColors.rojo),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColors.verde),
    );
  }

  // =====================================
  // ACTIVAR / INHABILITAR (toggle rápido, sin abrir formulario)
  // =====================================
  Future<void> _toggleActiva(CategoriaBlindaje c) async {
    setState(() => _actualizandoEstado.add(c.id));

    final nuevoEstado = !c.activa;
    try {
      final token = await _obtenerToken();
      if (token == null) throw Exception('Sesión expirada, vuelve a iniciar sesión');

      // ⚠️ La columna real en Supabase se llama "activo", no "activa"
      await _categoriasService.actualizarParcial(token, c.id, {'activo': nuevoEstado});

      setState(() {
        final index = _categorias.indexWhere((x) => x.id == c.id);
        if (index != -1) {
          _categorias[index] = c.copyWith(activa: nuevoEstado);
        }
      });

      _mostrarExito(nuevoEstado ? 'Categoría activada' : 'Categoría inhabilitada');
    } catch (e) {
      _mostrarError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _actualizandoEstado.remove(c.id));
    }
  }

  // ─── Crear / Editar ──────────────────────────────────────────────────
  Future<void> _abrirFormulario({CategoriaBlindaje? categoria}) async {
    final nombreCtrl = TextEditingController(text: categoria?.nombre ?? '');
    final descCtrl = TextEditingController(text: categoria?.descripcion ?? '');
    bool activa = categoria?.activa ?? true;
    final esEdicion = categoria != null;

    final resultado = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(esEdicion ? 'Editar categoría' : 'Nueva categoría'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 2,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Activa'),
                  value: activa,
                  onChanged: (v) => setDialogState(() => activa = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.dorado),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(esEdicion ? 'Guardar' : 'Crear'),
            ),
          ],
        ),
      ),
    );

    if (resultado != true) return;

    if (nombreCtrl.text.trim().isEmpty) {
      _mostrarError('El nombre es obligatorio');
      return;
    }

    try {
      final token = await _obtenerToken();
      if (token == null) throw Exception('Sesión expirada, vuelve a iniciar sesión');

      final nuevaCategoria = CategoriaBlindaje(
        id: categoria?.id ?? 0,
        nombre: nombreCtrl.text.trim(),
        descripcion: descCtrl.text.trim(),
        activa: activa,
        categoriaPadre: categoria?.categoriaPadre,
      );

      if (esEdicion) {
        await _categoriasService.editarCategoria(token, categoria.id, nuevaCategoria);
        _mostrarExito('Categoría actualizada');
      } else {
        await _categoriasService.crearCategoria(token, nuevaCategoria);
        _mostrarExito('Categoría creada');
      }

      await _cargarCategorias();
    } catch (e) {
      _mostrarError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _confirmarEliminar(CategoriaBlindaje c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Seguro que deseas eliminar "${c.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                final token = await _obtenerToken();
                if (token == null) throw Exception('Sesión expirada, vuelve a iniciar sesión');
                await _categoriasService.eliminarCategoria(token, c.id);
                _mostrarExito('Categoría eliminada');
                await _cargarCategorias();
              } catch (e) {
                _mostrarError(e.toString().replaceFirst('Exception: ', ''));
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
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
          if (_esAdmin) ...[
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => _abrirFormulario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dorado,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Nueva', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
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
    final actualizando = _actualizandoEstado.contains(c.id);

    return Container(
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
              // ─── Badge + toggle activar/inhabilitar ───
              if (actualizando)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _esAdmin ? () => _toggleActiva(c) : null,
                  child: Container(
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
                        if (_esAdmin) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.sync_alt, size: 11, color: c.activa ? AppColors.verde : AppColors.rojo),
                        ],
                      ],
                    ),
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
            ],
          ),
          if (_esAdmin) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _abrirFormulario(categoria: c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.doradoOscuro.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 14, color: AppColors.doradoOscuro),
                        SizedBox(width: 4),
                        Text('Editar',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.doradoOscuro,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _confirmarEliminar(c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.rojo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, size: 14, color: AppColors.rojo),
                        SizedBox(width: 4),
                        Text('Eliminar',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.rojo,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}