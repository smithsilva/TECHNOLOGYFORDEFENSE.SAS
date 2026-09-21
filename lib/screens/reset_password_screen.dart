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

class ResetPasswordScreen extends StatefulWidget {
  // Token que llega desde el enlace del correo (igual que en la web).
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _authService = AuthService();

  bool _cargando = false;
  bool _exito = false;
  bool _ocultarPassword = true;
  bool _ocultarConfirmar = true;
  String? _error;

  bool get _tieneToken => widget.token != null && widget.token!.isNotEmpty;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _restablecer() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_tieneToken) {
      setState(() => _error = 'El enlace no es válido. Solicita uno nuevo.');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      await _authService.resetPassword(
        token: widget.token!,
        nuevaPassword: _passwordController.text,
      );
      setState(() => _exito = true);
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
    required String hint,
    required Widget sufijo,
  }) {
    final bordeNormal = Colors.white.withValues(alpha: 0.14);
    final rojoClaro = Color.lerp(_AppColors.red, Colors.white, 0.35)!;
    OutlineInputBorder borde(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(color: _AppColors.lightBlue),
      floatingLabelStyle: const TextStyle(color: _AppColors.goldText),
      hintStyle: TextStyle(
        color: _AppColors.lightBlue.withValues(alpha: 0.45),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      prefixIcon: const Icon(Icons.lock_outline, color: _AppColors.goldText),
      suffixIcon: sufijo,
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
                          child: _exito ? _buildExito() : _buildFormulario(),
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
            'Restablecer contraseña',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ingresa tu nueva contraseña. Debe tener al menos 6 caracteres.',
            style: TextStyle(fontSize: 13, color: _AppColors.lightBlue),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _ocultarPassword,
            cursorColor: _AppColors.goldText,
            style: const TextStyle(color: Colors.white),
            decoration: _decoracion(
              label: 'Nueva contraseña',
              hint: 'Mínimo 6 caracteres',
              sufijo: IconButton(
                icon: Icon(
                  _ocultarPassword ? Icons.visibility_off : Icons.visibility,
                  color: _AppColors.lightBlue,
                ),
                onPressed: () {
                  setState(() => _ocultarPassword = !_ocultarPassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _confirmarController,
            obscureText: _ocultarConfirmar,
            cursorColor: _AppColors.goldText,
            style: const TextStyle(color: Colors.white),
            decoration: _decoracion(
              label: 'Confirmar contraseña',
              hint: 'Repite la contraseña',
              sufijo: IconButton(
                icon: Icon(
                  _ocultarConfirmar ? Icons.visibility_off : Icons.visibility,
                  color: _AppColors.lightBlue,
                ),
                onPressed: () {
                  setState(() => _ocultarConfirmar = !_ocultarConfirmar);
                },
              ),
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
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
              onPressed: _cargando ? null : _restablecer,
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
                  : const Text('Restablecer contraseña'),
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
          Icons.check_circle_outline,
          color: _AppColors.goldText,
          size: 48,
        ),
        const SizedBox(height: 16),
        const Text(
          '¡Contraseña actualizada!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tu contraseña fue actualizada correctamente. Ya puedes iniciar sesión.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: _AppColors.lightBlue),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
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
            child: const Text('Ir al inicio de sesión'),
          ),
        ),
      ],
    );
  }
}