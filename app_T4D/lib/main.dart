import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/Contadora/main_shell_contadora.dart';
import 'screens/Gerente/main_shell_gerente.dart';

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

  case 'admin':
    return MainShell(
      usuario: _usuario,
    );

  case 'contadora':
    return MainShellContadora(
      usuario: _usuario,
    );

  case 'gerente':
    return MainShellGerente(
      usuario: _usuario,
    );

  case 'mecanico':
    return MainShellGerente(
      usuario: _usuario,
    );

  case 'home':
  default:
    return MainShell(
      usuario: _usuario,
    );
}
  }
}