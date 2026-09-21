import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Paleta de colores (incluida en este archivo, no necesita otro archivo)
class _AppColors {
  static const background = Color(0xFFF7EFDD);
  static const navy = Color(0xFF101B33);
  static const gold = Color(0xFFC9A24A);
  static const goldDark = Color(0xFF8A6D1F);
  static const goldText = Color(0xFFD2A03C);
  static const lightBlue = Color(0xFF9FB4DE);
  static const inputBg = Color(0xFFEFE4CB);
  static const iconBg = Color(0xFFF0E3BE);
  static const cardBorder = Color(0xFFECE0BD);

  static const green = Color(0xFF2E9E4E);
  static const greenBg = Color(0xFFDCF2E3);
  static const olive = Color(0xFF8B7920);
  static const oliveBg = Color(0xFFF3ECD2);
  static const red = Color(0xFFC24555);
  static const redBg = Color(0xFFF8DCE0);
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  bool _cargando = false;
  bool _enviado = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      await _authService.forgotPassword(email: _emailController.text.trim());
      setState(() => _enviado = true);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => _cargando = false);
    }
  }

  InputDecoration _decoracion({
    required String label,
    required IconData icono,
  }) {
    final bordeNormal = Colors.white.withValues(alpha: 0.14);
    final rojoClaro = Color.lerp(_AppColors.red, Colors.white, 0.35)!;
    OutlineInputBorder borde(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _AppColors.lightBlue),
      floatingLabelStyle: const TextStyle(color: _AppColors.goldText),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      prefixIcon: Icon(icono, color: _AppColors.goldText),
      border: borde(bordeNormal),
      enabledBorder: borde(bordeNormal),
      focusedBorder: borde(_AppColors.goldText),
      errorBorder: borde(_AppColors.red),
      focusedErrorBorder: borde(_AppColors.red),
      errorStyle: TextStyle(color: rojoClaro),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.navy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _AppColors.goldText,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con la imagen del carro
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

          // Tarjeta azul borrosa
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.55),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _AppColors.navy.withValues(alpha: 0.40),
                                _AppColors.navy.withValues(alpha: 0.26),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _AppColors.gold.withValues(alpha: 0.30),
                            ),
                          ),
                          child: _enviado ? _buildExito() : _buildFormulario(),
                        ),
                      ),
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

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingresa tu correo electrónico',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Te enviaremos un enlace para restablecer tu contraseña.',
            style: TextStyle(fontSize: 13, color: _AppColors.lightBlue),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: _AppColors.goldText,
            style: const TextStyle(color: Colors.white),
            decoration: _decoracion(
              label: 'Correo electrónico',
              icono: Icons.email_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El correo es requerido';
              }
              if (!value.contains('@')) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(
                color: Color.lerp(_AppColors.red, Colors.white, 0.35),
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _cargando ? null : _enviarSolicitud,
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppColors.goldText,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _cargando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Enviar enlace'),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: _AppColors.lightBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExito() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          color: _AppColors.goldText,
          size: 48,
        ),
        const SizedBox(height: 16),
        const Text(
          'Revisa tu correo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Si el correo existe en nuestro sistema, se ha enviado un enlace de recuperación. Revisa tu bandeja de entrada y la carpeta de spam.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: _AppColors.lightBlue),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              foregroundColor: _AppColors.goldText,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: _AppColors.gold.withValues(alpha: 0.40)),
              ),
            ),
            child: const Text('Volver al inicio de sesión'),
          ),
        ),
      ],
    );
  }
}