import 'package:flutter/material.dart';
// import '../services/usuarios_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const fondoInput = Color(0xFFF4F1EA);
  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);
  static const textoMuted = Color(0xFF6B7280);
}

class RegistroScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const RegistroScreen({super.key, this.usuario});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  String? _rolSeleccionado;
  bool _passVisible = false;
  bool _confirmarVisible = false;
  bool _guardando = false;
  bool _reenviando = false;

  static const _roles = [
    {'valor': 'admin', 'label': 'Admin'},
    {'valor': 'contador', 'label': 'Contador'},
    {'valor': 'gerente', 'label': 'Gerente'},
    {'valor': 'mecanico', 'label': 'Mecanico'},
  ];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _passCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  String? _validarNombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'El nombre es obligatorio';
    if (valor.trim().length < 2) return 'Nombre muy corto';
    return null;
  }

  String? _validarCorreo(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'El correo es obligatorio';
    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(valor.trim())) return 'Correo inválido';
    return null;
  }

  String? _validarPassword(String? valor) {
    if (valor == null || valor.isEmpty) return 'La contraseña es obligatoria';
    if (valor.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validarConfirmar(String? valor) {
    if (valor == null || valor.isEmpty) return 'Confirma la contraseña';
    if (valor != _passCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> _registrar() async {
    final formValido = _formKey.currentState!.validate();
    if (!formValido || _rolSeleccionado == null) {
      if (_rolSeleccionado == null) setState(() {}); // fuerza repintar el error de rol
      return;
    }

    setState(() => _guardando = true);

    // TODO: reemplazar por la llamada real, por ejemplo:
    // await UsuariosService().crear(
    //   nombre: _nombreCtrl.text.trim(),
    //   correo: _correoCtrl.text.trim(),
    //   password: _passCtrl.text,
    //   rol: _rolSeleccionado!,
    // );
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _guardando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario "${_nombreCtrl.text.trim()}" registrado correctamente')),
    );

    _formKey.currentState!.reset();
    _nombreCtrl.clear();
    _correoCtrl.clear();
    _passCtrl.clear();
    _confirmarCtrl.clear();
    setState(() => _rolSeleccionado = null);
  }

  // ---------------------------------------------------------
  // NUEVO: botón "Reenviar Credenciales" — no existía en tu código
  // original. Placeholder hasta que tengas el endpoint real, ej:
  // await UsuariosService().reenviarCredenciales(correo: ...);
  // ---------------------------------------------------------
  Future<void> _reenviarCredenciales() async {
    if (_correoCtrl.text.trim().isEmpty || _validarCorreo(_correoCtrl.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo válido para reenviar credenciales')),
      );
      return;
    }

    setState(() => _reenviando = true);
    await Future.delayed(const Duration(milliseconds: 600)); // TODO: llamada real
    if (!mounted) return;
    setState(() => _reenviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Credenciales reenviadas a ${_correoCtrl.text.trim()}')),
    );
  }

  InputDecoration _decoracion(String hint, IconData icono) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(icono, size: 18, color: AppColors.doradoOscuro),
      filled: true,
      fillColor: AppColors.fondoInput,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dorado, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _labelRequerido(String texto) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
        children: [
          TextSpan(text: texto),
          const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          _buildFormulario(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navyOscuro, AppColors.navyClaro],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Círculo decorativo, igual al de la captura
            Positioned(
              right: -20,
              top: -30,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADMINISTRADOR · REGISTRO',
                  style: TextStyle(
                    color: AppColors.dorado,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Registro de Usuarios',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Crea y gestiona accesos al sistema',
                  style: TextStyle(color: AppColors.subtitulo, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.doradoClaro.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add_alt, size: 20, color: AppColors.doradoOscuro),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nuevo Usuario',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('Completa todos los campos requeridos',
                        style: TextStyle(fontSize: 11.5, color: AppColors.doradoOscuro)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            _labelRequerido('Nombre Completo'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nombreCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _decoracion('Ej: Carlos Martínez', Icons.person_outline),
              validator: _validarNombre,
            ),
            const SizedBox(height: 14),

            _labelRequerido('Correo Electrónico'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _correoCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoracion('usuario@empresa.com', Icons.mail_outline),
              validator: _validarCorreo,
            ),
            const SizedBox(height: 14),

            // Contraseña / Confirmar en fila
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelRequerido('Contraseña'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: !_passVisible,
                        decoration: _decoracion('••••••', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 18,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () => setState(() => _passVisible = !_passVisible),
                          ),
                        ),
                        validator: _validarPassword,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelRequerido('Confirmar'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmarCtrl,
                        obscureText: !_confirmarVisible,
                        decoration: _decoracion('••••••', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmarVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 18,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () => setState(() => _confirmarVisible = !_confirmarVisible),
                          ),
                        ),
                        validator: _validarConfirmar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _labelRequerido('Rol del Usuario'),
            const SizedBox(height: 8),
            Row(
              children: _roles.map((r) {
                final seleccionado = _rolSeleccionado == r['valor'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _rolSeleccionado = r['valor']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: seleccionado ? AppColors.doradoClaro.withValues(alpha: 0.25) : AppColors.fondoInput,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: seleccionado ? AppColors.dorado : Colors.grey.shade300,
                            width: seleccionado ? 1.4 : 1,
                          ),
                        ),
                        child: Text(
                          r['label']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: seleccionado ? AppColors.doradoOscuro : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_rolSeleccionado == null)
              const Padding(
                padding: EdgeInsets.only(top: 6, left: 2),
                child: Text(
                  'Selecciona un rol',
                  style: TextStyle(fontSize: 11.5, color: Colors.redAccent),
                ),
              ),
            const SizedBox(height: 20),

            // Botón principal: Registrar Usuario (dorado)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _guardando ? null : _registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dorado,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: _guardando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87),
                      )
                    : const Icon(Icons.person_add_alt, size: 18),
                label: Text(
                  _guardando ? 'Registrando...' : 'Registrar Usuario',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Botón secundario: Reenviar Credenciales (navy)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _reenviando ? null : _reenviarCredenciales,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyOscuro,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: _reenviando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text(
                  _reenviando ? 'Enviando...' : 'Reenviar Credenciales',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}