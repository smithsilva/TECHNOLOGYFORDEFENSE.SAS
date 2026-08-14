import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const T4DApp());
}

class T4DApp extends StatelessWidget {
  const T4DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T4D',
      home: const RaizApp(),
    );
  }
}

/// Widget raíz con estado: decide qué pantalla mostrar según la
/// "vista" que llega desde LoginScreen (equivalente al setVista del JSX).
class RaizApp extends StatefulWidget {
  const RaizApp({super.key});

  @override
  State<RaizApp> createState() => _RaizAppState();
}

class _RaizAppState extends State<RaizApp> {
  String _vista = 'login';
  Map<String, dynamic>? _usuario;

  void _setVista(String vista) {
    setState(() => _vista = vista);
  }

  void _setUsuario(Map<String, dynamic> usuario) {
    setState(() => _usuario = usuario);
  }

  @override
  Widget build(BuildContext context) {
    switch (_vista) {
      case 'login':
        return LoginScreen(
          setVista: _setVista,
          setUsuario: _setUsuario,
        );

      // Por ahora todos los roles autenticados van al inventario.
      // Cuando tengas pantallas propias por rol (admin, gerente, etc.)
      // agregas más 'case' aquí, cada uno devolviendo su screen.
      case 'admin':
      case 'contadora':
      case 'gerente':
      case 'mecanico':
      case 'home':
      default:
        return MainShell(usuario: _usuario);
    }
  }
}