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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$accion: próximamente'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navyOscuro,
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

    return Container(
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
                          _accionIcono(Icons.remove_red_eye_outlined, Colors.grey.shade700,
                              () => _mostrarProximamente('Ver "${u.nombre}"')),
                          const SizedBox(width: 6),
                          _accionIcono(Icons.edit_outlined, AppColors.doradoOscuro,
                              () => _mostrarProximamente('Editar "${u.nombre}"')),
                          const SizedBox(width: 6),
                          _accionIcono(Icons.refresh, AppColors.doradoOscuro,
                              () => _mostrarProximamente('Restablecer contraseña de "${u.nombre}"')),
                          const SizedBox(width: 6),
                          _accionIcono(Icons.delete_outline, AppColors.rojo, () => _confirmarEliminar(u)),
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
    );
  }

  Widget _badgeRol(String texto, Color color, Color fondo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(20)),
      child: Text(texto, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
    );
  }

  Widget _accionIcono(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}