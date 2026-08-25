import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

// ==========================
// Paleta de colores (equivalente al objeto C del JSX)
// ==========================
class AppColors {
  static const cardBg = Color(0x730E1621); // rgba(14,22,33,0.45)
  static const cardBorder = Color(0x4DB89B6A); // rgba(184,155,106,0.30)
  static const titulo = Color(0xFFFFFFFF);
  static const dorado = Color(0xFFB89B6A);
  static const doradoClaro = Color(0xFFC9A84C);
  static const doradoOsc = Color(0xFF8B6914);
  static const inputBg = Color(0xFF1A2336);
  static const inputBorder = Color(0xFF2D3A52);
  static const inputTxt = Color(0xFFC5CFE0);
  static const placeholder = Color(0xFF4E6080);
  static const labelTxt = Color(0xFF9AB0C8);
  static const navy = Color(0xFF0E1621);
  static const navyClaro = Color(0xFF16202E);
}

/// Callback que recibe la vista destino tras el login (equivalente a setVista)
typedef OnNavigate = void Function(String vista);

/// Callback que recibe el usuario adaptado (equivalente a setUsuario)
typedef OnUsuario = void Function(Map<String, dynamic> usuario);

class LoginScreen extends StatefulWidget {
  final OnNavigate setVista;
  final OnUsuario? setUsuario;

  const LoginScreen({super.key, required this.setVista, this.setUsuario});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _codigoCtrl = TextEditingController();

  bool _showPass = false;
  bool _cargando = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _correoCtrl.dispose();
    _passwordCtrl.dispose();
    _codigoCtrl.dispose();
    super.dispose();
  }

  /// Normaliza un rol: minúsculas, sin espacios extremos, sin tildes.
  String _normalizarRol(String? rol) {
    if (rol == null) return '';
    final sinTildes = rol
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u');
    return sinTildes;
  }

  /// Diálogo de resultado (éxito o error) con el estilo dorado/navy de la app,
  /// en vez del AlertDialog genérico de Flutter.
  Future<void> _mostrarDialogo({
    required String titulo,
    required String texto,
    bool exito = false,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.navyClaro,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: (exito ? Colors.greenAccent : Colors.redAccent)
                  .withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (exito ? Colors.green : Colors.redAccent)
                      .withValues(alpha: 0.15),
                ),
                child: Icon(
                  exito ? Icons.check_rounded : Icons.priority_high_rounded,
                  color: exito ? Colors.greenAccent : Colors.redAccent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.titulo,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.inputTxt,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.doradoOsc,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Entendido',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _manejarLogin() async {
    final correo = _correoCtrl.text.trim();
    final password = _passwordCtrl.text;
    final codigo = _codigoCtrl.text.trim();

    if (correo.isEmpty || password.isEmpty || codigo.isEmpty) {
      await _mostrarDialogo(
        titulo: 'Campos vacíos',
        texto: 'Completa todos los campos',
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final data = await _authService.login(
        email: correo,
        password: password,
        codigo: codigo,
      );

      final usuarioBD = data['usuario'] as Map<String, dynamic>;
      final token = data['token'] as String;
      String rolReal;
      switch (usuarioBD['id_rol']) {
        case 1:
          rolReal = 'Admin';
          break;
        case 2:
          rolReal = 'Contadora';
          break;
        case 3:
          rolReal = 'Gerente';
          break;
        case 4:
          rolReal = 'Mecanico';
          break;
        default:
          rolReal = usuarioBD['rol']?.toString() ?? 'Usuario';
      }

      final rolFinalRaw = _normalizarRol(rolReal);
      final rolFinal = rolFinalRaw.isEmpty ? 'usuario' : rolFinalRaw;

      final usuarioAdaptado = {
        ...usuarioBD,
        'nombre': usuarioBD['username'] ?? 'Usuario',
        'correo': usuarioBD['email'] ?? '',
        'rol': rolFinal,
        'id_usuario': usuarioBD['id_usuario'],
        'username': usuarioBD['username'],
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('usuario', jsonEncode(usuarioAdaptado));
      await prefs.setString('token', token);

      widget.setUsuario?.call(usuarioAdaptado);

      await _mostrarDialogo(
        titulo: 'Inicio exitoso',
        texto: 'Bienvenido ${usuarioBD['username']}',
        exito: true,
      );

      if (rolFinal == 'admin') {
        widget.setVista('admin');
      } else if (rolFinal == 'contador' || rolFinal == 'contadora') {
        widget.setVista('contadora');
      } else if (rolFinal == 'gerente') {
        widget.setVista('gerente');
      } else if (rolFinal == 'mecanico') {
        widget.setVista('mecanico');
      } else {
        widget.setVista('home');
      }
    } catch (e) {
      debugPrint('$e');
      await _mostrarDialogo(
        titulo: 'Error de conexión',
        texto: 'No se pudo conectar con el servidor',
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
      filled: true,
      fillColor: AppColors.inputBg,
      prefixIcon: Icon(icon, color: AppColors.dorado, size: 18),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.dorado),
      ),
    );
  }

  Widget _label(String texto, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.dorado, size: 14),
          const SizedBox(width: 7),
          Text(
            texto,
            style: const TextStyle(
              color: AppColors.labelTxt,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagen10.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro
          Container(color: const Color(0x40050A16)),

          // Card centrada
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x8C000000),
                          blurRadius: 60,
                          offset: Offset(0, 24),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/escudo1.png',
                          width: 84,
                          height: 84,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),

                        // Título
                        const Text(
                          'TECHNOLOGY FOR DEFENSE S.A.S.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.titulo,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtítulo con líneas doradas
                        Row(
                          children: [
                            Expanded(
                              child: Container(height: 1, color: AppColors.dorado),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                'Sistema de Control de Inventario',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.dorado,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(height: 1, color: AppColors.dorado),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Correo
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _label('Correo electrónico', Icons.person_outline),
                        ),
                        TextField(
                          controller: _correoCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.inputTxt, fontSize: 13),
                          decoration: _inputDecoration(
                            label: 'Ingrese su correo electrónico',
                            icon: Icons.person_outline,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Contraseña
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _label('Contraseña', Icons.lock_outline),
                        ),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: !_showPass,
                          style: const TextStyle(color: AppColors.inputTxt, fontSize: 13),
                          decoration: _inputDecoration(
                            label: 'Ingrese su contraseña',
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.dorado,
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _showPass = !_showPass),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Código de verificación
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _label(
                            'Código de verificación',
                            Icons.shield_outlined,
                          ),
                        ),
                        TextField(
                          controller: _codigoCtrl,
                          style: const TextStyle(
                            color: AppColors.inputTxt,
                            fontSize: 13,
                            letterSpacing: 3,
                          ),
                          decoration: _inputDecoration(
                            label: 'Ingrese el código de verific...',
                            icon: Icons.shield_outlined,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Código enviado a tu correo',
                              style: TextStyle(
                                color: AppColors.placeholder,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Botón
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _cargando ? null : _manejarLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: AppColors.doradoOsc,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 6,
                            ).copyWith(
                              backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => states.contains(WidgetState.pressed)
                                    ? AppColors.doradoOsc
                                    : AppColors.doradoClaro,
                              ),
                            ),
                            child: _cargando
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}