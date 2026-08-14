import 'package:flutter/material.dart';

/// Pantalla temporal para secciones que todavía no están construidas.
/// La usan Movimientos, Historial de Precios, Notificaciones, Reportes,
/// Usuarios y Registro hasta que tengan su propia pantalla real.
class PlaceholderScreen extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const PlaceholderScreen({
    super.key,
    required this.titulo,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F1E3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48, color: const Color(0xFF8C6B3F)),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Próximamente',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}