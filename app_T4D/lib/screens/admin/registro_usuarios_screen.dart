import 'package:flutter/material.dart';
// import '../services/usuarios_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navy = Color(0xFF13202E);
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

  static const _roles = [
    {'valor': 'admin', 'label': 'Administrador'},
    {'valor': 'gerente', 'label': 'Gerente'},
    {'valor': 'contador', 'label': 'Contador'},
    {'valor': 'mecanico', 'label': 'Mecánico'},
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

  String? _validarRol(String? valor) {
    if (valor == null || valor.isEmpty) return 'Selecciona un rol';
    return null;
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

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

  InputDecoration _decoracion(String hint, IconData icono) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(icono, size: 18, color: AppColors.doradoOscuro),
      filled: true,
      fillColor: AppColors.fondo,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
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
                  'Registro de Usuarios',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Administra el acceso al sistema',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Formulario
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.doradoClaro),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person_add_alt, size: 18, color: AppColors.doradoOscuro),
                      SizedBox(width: 8),
                      Text(
                        'Nuevo Usuario',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text('Nombre Completo',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nombreCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoracion('Nombre Completo', Icons.person_outline),
                    validator: _validarNombre,
                  ),
                  const SizedBox(height: 14),

                  const Text('Correo Electrónico',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _decoracion('Correo Electrónico', Icons.mail_outline),
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
                            const Text('Contraseña',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: !_passVisible,
                              decoration: _decoracion('Contraseña', Icons.lock_outline).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 18,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed: () =>
                                      setState(() => _passVisible = !_passVisible),
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
                            const Text('Confirmar',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _confirmarCtrl,
                              obscureText: !_confirmarVisible,
                              decoration: _decoracion('Confirmar', Icons.lock_outline).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _confirmarVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 18,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed: () => setState(
                                      () => _confirmarVisible = !_confirmarVisible),
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

                  const Text('Rol del Usuario',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _rolSeleccionado,
                    decoration: _decoracion('Seleccionar rol', Icons.badge_outlined),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    hint: const Text('Seleccionar rol',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    items: _roles
                        .map((r) => DropdownMenuItem(
                              value: r['valor'],
                              child: Text(r['label']!, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (valor) => setState(() => _rolSeleccionado = valor),
                    validator: _validarRol,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _guardando ? null : _registrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _guardando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.person_add_alt, size: 18),
                      label: Text(
                        _guardando ? 'Registrando...' : 'Registrar Usuario',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}