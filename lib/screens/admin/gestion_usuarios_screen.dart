import 'package:flutter/material.dart';
import '../../models/usuario_lista.dart';
// import '../services/usuarios_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const fondo = Color(0xFFFAF3E4);
  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);
  static const verde = Color(0xFF2E9E5B);
  static const verdeFondo = Color(0xFFDDF2E1);
  static const morado = Color(0xFF6D5BD0);
  static const moradoFondo = Color(0xFFEDE9FE);
  static const naranja = Color(0xFFC9682E);
  static const naranjaFondo = Color(0xFFF7E3D3);
  static const azul = Color(0xFF2F6FED);
  static const azulFondo = Color(0xFFE8F0FE);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const textoMuted = Color(0xFF6B7280);
}

class UsuariosScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const UsuariosScreen({super.key, this.usuario});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();

  bool _cargando = false;
  String _filtroRol = 'todos'; // todos | admin | gerente | mecanico | contador
  List<UsuarioLista> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Por ahora carga datos de ejemplo (mock) para la parte visual.
  /// Cuando conectes el backend, reemplaza el contenido de este método
  /// por una llamada a tu UsuariosService, por ejemplo:
  ///
  /// final data = await UsuariosService().obtenerUsuarios();
  /// setState(() => _usuarios = data);
  Future<void> _cargarUsuarios() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _usuarios = [
        UsuarioLista(
          id: 1,
          nombre: 'Nicol',
          correo: 'contadora@gmail.com',
          rol: 'contador',
          activo: true,
        ),
        UsuarioLista(
          id: 2,
          nombre: 'Juan',
          correo: 'admin@gmail.com',
          rol: 'admin',
          activo: true,
        ),
        UsuarioLista(
          id: 3,
          nombre: 'Gisel',
          correo: 'gerente@gmail.com',
          rol: 'gerente',
          activo: true,
        ),
        UsuarioLista(
          id: 4,
          nombre: 'Camilo',
          correo: 'mecanico@gmail.com',
          rol: 'mecanico',
          activo: true,
        ),
        UsuarioLista(
          id: 5,
          nombre: 'camilo',
          correo: 'camilo2@gmail.com',
          rol: 'mecanico',
          activo: true,
        ),
      ];
      _cargando = false;
    });
  }

  int get _total => _usuarios.length;
  int get _totalAdmins => _usuarios.where((u) => u.rol == 'admin').length;
  int get _totalMecanicos => _usuarios.where((u) => u.rol == 'mecanico').length;
  int get _totalOtros =>
      _usuarios.where((u) => u.rol != 'admin' && u.rol != 'mecanico').length;

  String _normalizar(String texto) {
    const conTilde = 'áàäâéèëêíìïîóòöôúùüû';
    const sinTilde = 'aaaaeeeeiiiioooouuuu';
    var resultado = texto.toLowerCase();
    for (var i = 0; i < conTilde.length; i++) {
      resultado = resultado.replaceAll(conTilde[i], sinTilde[i]);
    }
    return resultado;
  }

  List<UsuarioLista> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    return _usuarios.where((u) {
      final matchTexto = texto.isEmpty ||
          _normalizar(u.nombre).contains(texto) ||
          _normalizar(u.correo).contains(texto) ||
          _normalizar(u.rol).contains(texto);
      final matchRol = _filtroRol == 'todos' || u.rol == _filtroRol;
      return matchTexto && matchRol;
    }).toList();
  }

  void _mostrarProximamente(String accion) {
    _mostrarSnack('$accion: próximamente', AppColors.navyOscuro);
  }

  void _mostrarSnack(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _etiquetaRol(String rol) {
    switch (rol) {
      case 'admin':
        return 'Admin';
      case 'contador':
        return 'Contador';
      case 'gerente':
        return 'Gerente';
      case 'mecanico':
        return 'Mecanico';
      default:
        return rol.isEmpty
            ? 'Usuario'
            : rol[0].toUpperCase() + rol.substring(1);
    }
  }

  // Color principal asociado a cada rol (avatar, borde lateral y badge)
  Color _colorRol(String rol) {
    switch (rol) {
      case 'admin':
        return AppColors.dorado;
      case 'contador':
        return AppColors.verde;
      case 'gerente':
        return AppColors.morado;
      case 'mecanico':
        return AppColors.azul;
      default:
        return AppColors.textoMuted;
    }
  }

  Color _fondoRol(String rol) {
    switch (rol) {
      case 'admin':
        return AppColors.doradoClaro.withValues(alpha: 0.3);
      case 'contador':
        return AppColors.verdeFondo;
      case 'gerente':
        return AppColors.moradoFondo;
      case 'mecanico':
        return AppColors.azulFondo;
      default:
        return Colors.grey.shade200;
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // ─── HELPERS DE DISEÑO COMPARTIDOS PARA LOS MODALES ────────────────────
  // (header navy con ícono, contenedor base, campos, footer de botones)
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
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitulo,
                  style: const TextStyle(color: Color(0xFF8FA3C4), fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, size: 18, color: AppColors.doradoOscuro),
          filled: true,
          fillColor: AppColors.fondo,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _dropdownRol(String valor, ValueChanged<String> onChanged) {
    const roles = [
      ('admin', 'Administrador'),
      ('gerente', 'Gerente'),
      ('mecanico', 'Mecánico'),
      ('contador', 'Contador'),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: AppColors.fondo, borderRadius: BorderRadius.circular(14)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            value: valor,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.badge_outlined, size: 18, color: AppColors.doradoOscuro),
            ),
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            items: roles
                .map((r) => DropdownMenuItem(value: r.$1, child: Text(r.$2)))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }

  Widget _footerBotones({
    required String textoConfirmar,
    required VoidCallback onConfirmar,
    required VoidCallback onCancelar,
    String textoCancelar = 'Cancelar',
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancelar,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Text(textoCancelar,
                  style: const TextStyle(color: AppColors.textoMuted, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onConfirmar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dorado,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(textoConfirmar, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
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
          Text(
            valor,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // ─── VER DETALLE ────────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════
  void _verDetalle(UsuarioLista u) {
    final color = _colorRol(u.rol);
    _mostrarDialogoBase(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerDialogo(
            icon: Icons.person_outline,
            titulo: u.nombre,
            subtitulo: u.correo,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
              child: Text(
                _etiquetaRol(u.rol).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Column(
              children: [
                _filaDetalleIcono(Icons.email_outlined, 'Correo', u.correo),
                _filaDetalleIcono(Icons.badge_outlined, 'Rol', _etiquetaRol(u.rol)),
                _filaDetalleIcono(Icons.fingerprint, 'ID', '#${u.id}'),
                const SizedBox(height: 6),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _cajaStat(
                        'Estado',
                        u.activo ? 'Activo' : 'Inactivo',
                        u.activo ? AppColors.verde : AppColors.textoMuted,
                        Icons.toggle_on_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _cajaStat('Rol', _etiquetaRol(u.rol), color, Icons.badge_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _abrirFormulario(usuario: u);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dorado,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Editar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // ─── CREAR / EDITAR ─────────────────────────────────────────────────
  // (por ahora solo actualiza la lista mock local; conecta aquí tu
  // UsuariosService cuando tengas el endpoint de crear/editar listo)
  // ══════════════════════════════════════════════════════════════════════
  Future<void> _abrirFormulario({UsuarioLista? usuario}) async {
    final nombreCtrl = TextEditingController(text: usuario?.nombre ?? '');
    final correoCtrl = TextEditingController(text: usuario?.correo ?? '');
    final passwordCtrl = TextEditingController();
    String rol = usuario?.rol ?? 'mecanico';
    bool activo = usuario?.activo ?? true;
    final esEdicion = usuario != null;

    final resultado = await _mostrarDialogoBase<bool>(
      child: StatefulBuilder(
        builder: (ctx, setDialogState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _headerDialogo(
              icon: esEdicion ? Icons.edit_outlined : Icons.person_add_alt,
              titulo: esEdicion ? 'Editar usuario' : 'Nuevo usuario',
              subtitulo: esEdicion
                  ? 'Actualiza los datos del usuario'
                  : 'Agrega un usuario al sistema',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                children: [
                  _campoTexto(
                    controller: nombreCtrl,
                    label: 'Nombre completo',
                    icon: Icons.person_outline,
                  ),
                  _campoTexto(
                    controller: correoCtrl,
                    label: 'Correo electrónico',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (!esEdicion)
                    _campoTexto(
                      controller: passwordCtrl,
                      label: 'Contraseña temporal',
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                  _dropdownRol(rol, (v) => setDialogState(() => rol = v)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.fondo,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.dorado,
                      title: const Text('Usuario activo',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: activo,
                      onChanged: (v) => setDialogState(() => activo = v),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            _footerBotones(
              textoConfirmar: esEdicion ? 'Guardar cambios' : 'Crear usuario',
              onCancelar: () => Navigator.of(ctx).pop(false),
              onConfirmar: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      ),
    );

    if (resultado != true) return;

    if (nombreCtrl.text.trim().isEmpty || correoCtrl.text.trim().isEmpty) {
      _mostrarSnack('Nombre y correo son obligatorios', AppColors.rojo);
      return;
    }

    // TODO: reemplazar por UsuariosService().crearUsuario(...) / .editarUsuario(...)
    setState(() {
      if (esEdicion) {
        final index = _usuarios.indexWhere((x) => x.id == usuario.id);
        if (index != -1) {
          _usuarios[index] = UsuarioLista(
            id: usuario.id,
            nombre: nombreCtrl.text.trim(),
            correo: correoCtrl.text.trim(),
            rol: rol,
            activo: activo,
          );
        }
      } else {
        final nuevoId = (_usuarios.isEmpty
                ? 0
                : _usuarios.map((u) => u.id).reduce((a, b) => a > b ? a : b)) +
            1;
        _usuarios.add(UsuarioLista(
          id: nuevoId,
          nombre: nombreCtrl.text.trim(),
          correo: correoCtrl.text.trim(),
          rol: rol,
          activo: activo,
        ));
      }
    });

    _mostrarSnack(esEdicion ? 'Usuario actualizado' : 'Usuario creado', AppColors.verde);
  }

  void _confirmarEliminar(UsuarioLista u) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.rojoFondo, shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: AppColors.rojo, size: 28),
            ),
            const SizedBox(height: 14),
            const Text('¿Eliminar usuario?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 13, color: AppColors.textoMuted),
                children: [
                  const TextSpan(text: 'Vas a eliminar a '),
                  TextSpan(
                    text: '"${u.nombre}"',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const TextSpan(text: '. Esta acción no se puede deshacer.'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        actions: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textoMuted)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rojo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _usuarios.removeWhere((x) => x.id == u.id));
              },
              child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
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
        onRefresh: _cargarUsuarios,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildStats(),
            const SizedBox(height: 14),
            _buildBuscador(),
            const SizedBox(height: 10),
            _buildFiltros(),
            const SizedBox(height: 10),
            Text(
              '${_filtrados.length} ${_filtrados.length == 1 ? "USUARIO" : "USUARIOS"}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),

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
                      Icon(Icons.people_outline, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No se encontraron usuarios', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._filtrados.map((u) => _tarjetaUsuario(u)),
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
                  'ADMINISTRADOR · USUARIOS',
                  style: TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Gestión de Usuarios',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Administra el acceso y roles del sistema',
                  style: TextStyle(color: AppColors.subtitulo, fontSize: 12),
                ),
              ],
            ),
          ),
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
            label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _statCard('$_total', 'Total', AppColors.dorado)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('$_totalAdmins', 'Admins', AppColors.naranja)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('$_totalMecanicos', 'Mecánicos', AppColors.morado)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('$_totalOtros', 'Otros', AppColors.verde)),
      ],
    );
  }

  Widget _statCard(String valor, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(valor, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
        ],
      ),
    );
  }

  Widget _buildBuscador() {
    return TextField(
      controller: _busquedaCtrl,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, correo o rol...',
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

  Widget _buildFiltros() {
    final opciones = [
      ('Todos', 'todos', AppColors.dorado),
      ('Admin', 'admin', AppColors.dorado),
      ('Gerente', 'gerente', AppColors.morado),
      ('Mecanico', 'mecanico', AppColors.azul),
      ('Contador', 'contador', AppColors.verde),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: opciones.map((o) => _chipFiltro(o.$1, o.$2, o.$3)).toList(),
    );
  }

  Widget _chipFiltro(String label, String valor, Color color) {
    final activo = _filtroRol == valor;
    return ChoiceChip(
      label: Text(label),
      selected: activo,
      onSelected: (_) => setState(() => _filtroRol = valor),
      selectedColor: Colors.white,
      backgroundColor: Colors.white,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: activo ? color : Colors.grey.shade500,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      shape: StadiumBorder(
        side: BorderSide(color: activo ? color : Colors.grey.shade200, width: activo ? 1.4 : 1),
      ),
    );
  }

  Widget _tarjetaUsuario(UsuarioLista u) {
    final color = _colorRol(u.rol);
    final fondo = _fondoRol(u.rol);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _verDetalle(u),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Borde lateral de color según el rol
                Container(width: 5, color: color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: color,
                              child: Text(
                                u.inicial,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(u.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                  Text(
                                    u.correo,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _badgeRol(_etiquetaRol(u.rol), color, fondo),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: u.activo ? AppColors.verde : AppColors.textoMuted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              u.activo ? 'Activo' : 'Inactivo',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: u.activo ? AppColors.verde : AppColors.textoMuted,
                              ),
                            ),
                            const Spacer(),
                            // ─── Acciones: mismo estilo cuadrado con ícono que
                            // usa ProductoCard (Inventario) y Categorías —
                            // dorado claro para Ver/Editar/Restablecer, rojo
                            // claro para Eliminar, sin borde ni texto.
                            _accionBoton(
                              Icons.remove_red_eye_outlined,
                              AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD),
                              () => _verDetalle(u),
                            ),
                            const SizedBox(width: 8),
                            _accionBoton(
                              Icons.edit_outlined,
                              AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD),
                              () => _abrirFormulario(usuario: u),
                            ),
                            const SizedBox(width: 8),
                            _accionBoton(
                              Icons.refresh,
                              AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD),
                              () => _mostrarProximamente('Restablecer contraseña de "${u.nombre}"'),
                            ),
                            const SizedBox(width: 8),
                            _accionBoton(
                              Icons.delete_outline,
                              const Color(0xFFD64545),
                              const Color(0xFFFBE3E3),
                              () => _confirmarEliminar(u),
                            ),
                          ],
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

  Widget _badgeRol(String texto, Color color, Color fondo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(20)),
      child: Text(texto, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
    );
  }

  // Mismo helper que usa ProductoCard y Categorías: botón cuadrado,
  // ícono solo, fondo de color suave, sin texto ni borde.
  Widget _accionBoton(IconData icon, Color color, Color fondo, VoidCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}