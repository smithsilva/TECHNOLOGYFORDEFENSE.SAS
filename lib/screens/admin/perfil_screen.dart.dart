import 'package:flutter/material.dart';

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
  static const textoMuted = Color(0xFF6B7280);
}

/// Pantalla de Perfil del usuario, inspirada en "Perfil del Administrador" (versión web).
/// Recibe el mapa de usuario ya cargado en sesión (mismo patrón que InventarioScreen).
class PerfilScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;
  final Future<void> Function(Map<String, dynamic> datos)? onGuardar;
  final VoidCallback? onCerrarSesion;

  const PerfilScreen({
    super.key,
    this.usuario,
    this.onGuardar,
    this.onCerrarSesion,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late TextEditingController _nombreCtrl;
  late TextEditingController _emailCtrl;
  bool _editando = false;
  bool _guardando = false;

  String get _nombre => widget.usuario?['nombre'] ?? widget.usuario?['username'] ?? 'Usuario';
  String get _email => widget.usuario?['correo'] ?? widget.usuario?['email'] ?? '—';
  String get _rol => (widget.usuario?['rol'] ?? 'usuario').toString();
  String get _estado => widget.usuario?['estado'] ?? 'Activo';
  String get _ultimoAcceso => widget.usuario?['ultimo_acceso'] ?? '—';
  String? get _fotoUrl => widget.usuario?['foto_url'];

  String get _iniciales {
    final partes = _nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes[0].substring(0, 1) + partes[1].substring(0, 1)).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: _nombre);
    _emailCtrl = TextEditingController(text: _email);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    setState(() => _guardando = true);
    try {
      await widget.onGuardar?.call({
        'nombre': _nombreCtrl.text.trim(),
      });
      if (mounted) {
        setState(() => _editando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado'),
            backgroundColor: AppColors.verde,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: const Color(0xFFD64545),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildAvatarCard(),
          const SizedBox(height: 14),
          _buildInfoCard(),
        ],
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
                Text(
                  '${_rol.toUpperCase()} · PERFIL',
                  style: const TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Mi Perfil',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestiona tu información personal',
                  style: TextStyle(color: AppColors.subtitulo, fontSize: 12),
                ),
              ],
            ),
          ),
          if (widget.onCerrarSesion != null)
            OutlinedButton.icon(
              onPressed: widget.onCerrarSesion,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: AppColors.dorado),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              icon: const Icon(Icons.logout, size: 16, color: AppColors.dorado),
              label: const Text('Cerrar', style: TextStyle(color: AppColors.dorado, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.dorado,
                backgroundImage: _fotoUrl != null ? NetworkImage(_fotoUrl!) : null,
                child: _fotoUrl == null
                    ? Text(
                        _iniciales,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // TODO: conectar selector de imagen (image_picker) para cambiar foto
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.doradoOscuro,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(_nombre, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(_email, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: AppColors.dorado, borderRadius: BorderRadius.circular(20)),
            child: Text(
              _rol.toLowerCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _datoMini('Estado', _estado, AppColors.verde, Icons.circle, 8),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _datoMini('Último acceso', _ultimoAcceso, AppColors.textoMuted, Icons.schedule, 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _datoMini(String label, String valor, Color colorIcono, IconData icono, double size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fondo.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icono, size: size, color: colorIcono),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  valor,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Configuración de cuenta',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              if (!_editando)
                TextButton.icon(
                  onPressed: () => setState(() => _editando = true),
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.doradoOscuro),
                  label: const Text('Editar', style: TextStyle(color: AppColors.doradoOscuro)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _campo(
            label: 'Nombre completo',
            controller: _nombreCtrl,
            icono: Icons.person_outline,
            habilitado: _editando,
          ),
          const SizedBox(height: 14),
          _campo(
            label: 'Correo electrónico',
            controller: _emailCtrl,
            icono: Icons.email_outlined,
            habilitado: false,
            ayuda: 'El correo no se puede modificar',
          ),
          const SizedBox(height: 14),
          _campoSoloLectura(label: 'Rol del sistema', valor: _rol, icono: Icons.shield_outlined),
          if (_editando) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _guardando
                        ? null
                        : () => setState(() {
                              _editando = false;
                              _nombreCtrl.text = _nombre;
                            }),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancelar', style: TextStyle(color: AppColors.textoMuted)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _guardando ? null : _guardarCambios,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dorado,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _guardando
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Guardar cambios', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _campo({
    required String label,
    required TextEditingController controller,
    required IconData icono,
    required bool habilitado,
    String? ayuda,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: habilitado,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icono, size: 18, color: AppColors.doradoOscuro),
            filled: true,
            fillColor: habilitado ? AppColors.fondo.withValues(alpha: 0.5) : Colors.grey.shade100,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        if (ayuda != null) ...[
          const SizedBox(height: 4),
          Text(ayuda, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
        ],
      ],
    );
  }

  Widget _campoSoloLectura({required String label, required String valor, required IconData icono}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icono, size: 18, color: AppColors.doradoOscuro),
              const SizedBox(width: 10),
              Text(valor, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}