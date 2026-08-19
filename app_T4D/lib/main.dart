import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App T4D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const RaizApp(),
    );
  }
}

/// Controla qué "vista" se muestra (equivalente al setVista/vista de tu web en React).
class RaizApp extends StatefulWidget {
  const RaizApp({super.key});

  @override
  State<RaizApp> createState() => _RaizAppState();
}

class _RaizAppState extends State<RaizApp> {
  String _vista = 'login';
  Map<String, dynamic>? _usuario;
  bool _cargandoSesion = true;

  @override
  void initState() {
    super.initState();
    _restaurarSesion();
  }

  /// Revisa si ya había una sesión guardada en SharedPreferences
  /// y salta directo a la vista correspondiente.
  Future<void> _restaurarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioGuardado = prefs.getString('usuario');

    if (usuarioGuardado != null) {
      final usuario = jsonDecode(usuarioGuardado) as Map<String, dynamic>;
      final rol = (usuario['rol'] ?? '').toString();
      setState(() {
        _usuario = usuario;
        _vista = _vistaSegunRol(rol);
        _cargandoSesion = false;
      });
    } else {
      setState(() => _cargandoSesion = false);
    }
  }

  String _vistaSegunRol(String rol) {
    switch (rol) {
      case 'admin':
        return 'admin';
      case 'mecanico':
        return 'mecanico';
      case 'contador':
      case 'contadora':
        return 'contadora';
      case 'gerente':
        return 'gerente';
      default:
        return 'home';
    }
  }

  void _setVista(String vista) {
    setState(() => _vista = vista);
  }

  void _setUsuario(Map<String, dynamic> usuario) {
    setState(() => _usuario = usuario);
  }

  /// Limpia la sesión y vuelve al login. Se pasa como onLogout a los shells.
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
    await prefs.remove('token');
    setState(() {
      _usuario = null;
      _vista = 'login';
    });
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