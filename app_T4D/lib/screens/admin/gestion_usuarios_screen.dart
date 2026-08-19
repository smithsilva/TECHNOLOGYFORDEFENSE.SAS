import 'package:flutter/material.dart';
import '../../models/usuario_lista.dart';
// import '../services/usuarios_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navy = Color(0xFF13202E);
  static const verde = Color(0xFF1F9D55);
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
    if (texto.isEmpty) return _usuarios;
    return _usuarios.where((u) {
      return _normalizar(u.nombre).contains(texto) ||
          _normalizar(u.correo).contains(texto) ||
          _normalizar(u.rol).contains(texto);
    }).toList();
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
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

  void _confirmarEliminar(UsuarioLista u) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text('¿Seguro que deseas eliminar a "${u.nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _usuarios.removeWhere((x) => x.id == u.id));
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
        onRefresh: _cargarUsuarios,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Encabezado / título de la sección
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.doradoClaro),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestión de Usuarios',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Administra los usuarios del sistema',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjetas de estadísticas (oscuras)
            Row(
              children: [
                Expanded(
                  child: _tarjetaEstadistica('Total Usuarios', '${_usuarios.length}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaEstadistica('Administradores', '$_totalAdmins'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _tarjetaEstadistica('Mecánicos', '$_totalMecanicos'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tarjetaEstadistica('Otros Roles', '$_totalOtros'),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Buscador
            TextField(
              controller: _busquedaCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, correo o rol...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              '${_filtrados.length} usuarios',
              style: const TextStyle(fontSize: 12, color: AppColors.doradoOscuro, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Lista de usuarios
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

  Widget _tarjetaEstadistica(String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaUsuario(UsuarioLista u) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.dorado,
                child: Text(
                  u.inicial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Text(
                      u.correo,
                      style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.dorado),
                ),
                child: Text(
                  _etiquetaRol(u.rol),
                  style: const TextStyle(
                    color: AppColors.doradoOscuro,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.verde,
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
              _accionIcono(Icons.delete_outline, AppColors.rojo,
                  () => _confirmarEliminar(u)),
            ],
          ),
        ],
      ),
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