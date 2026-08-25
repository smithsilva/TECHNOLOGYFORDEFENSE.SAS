import 'package:flutter/material.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const azul = Color(0xFF2563EB);
  static const azulFondo = Color(0xFFE3EBFD);
  static const textoMuted = Color(0xFF6B7280);
}

class Mantenimiento {
  final int id;
  final String vehiculo;
  final String descripcion;
  final DateTime fecha;
  final String estado; // 'pendiente' | 'en_proceso' | 'completado'

  Mantenimiento({
    required this.id,
    required this.vehiculo,
    required this.descripcion,
    required this.fecha,
    required this.estado,
  });
}

class MantenimientosScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const MantenimientosScreen({super.key, this.usuario});

  @override
  State<MantenimientosScreen> createState() => _MantenimientosScreenState();
}

class _MantenimientosScreenState extends State<MantenimientosScreen> {
  bool _cargando = false;
  List<Mantenimiento> _mantenimientos = [];

  @override
  void initState() {
    super.initState();
    _cargarMantenimientos();
  }

  /// Mock. Cuando conectes el backend, filtra por el mecánico logueado.
  Future<void> _cargarMantenimientos() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _mantenimientos = [
        Mantenimiento(
          id: 1,
          vehiculo: 'Camioneta Blindada 4x4',
          descripcion: 'Revisión de sistema de frenos',
          fecha: DateTime.now().add(const Duration(days: 2)),
          estado: 'pendiente',
        ),
        Mantenimiento(
          id: 2,
          vehiculo: 'Sedán Blindado Nivel 3',
          descripcion: 'Cambio de aceite y filtros',
          fecha: DateTime.now(),
          estado: 'en_proceso',
        ),
        Mantenimiento(
          id: 3,
          vehiculo: 'Camioneta Blindada 4x4',
          descripcion: 'Reemplazo de vidrio blindado delantero',
          fecha: DateTime.now().subtract(const Duration(days: 3)),
          estado: 'completado',
        ),
      ];
      _cargando = false;
    });
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }

  Map<String, dynamic> _estiloEstado(String estado) {
    switch (estado) {
      case 'completado':
        return {'texto': 'Completado', 'color': AppColors.verde, 'fondo': AppColors.verdeFondo};
      case 'en_proceso':
        return {'texto': 'En proceso', 'color': AppColors.azul, 'fondo': AppColors.azulFondo};
      default:
        return {'texto': 'Pendiente', 'color': AppColors.doradoOscuro, 'fondo': AppColors.doradoClaro.withValues(alpha: 0.35)};
    }
  }

  String _formatoFecha(DateTime f) {
    final dia = f.day.toString().padLeft(2, '0');
    final mes = f.month.toString().padLeft(2, '0');
    return '$dia/$mes/${f.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarMantenimientos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.doradoClaro),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mis Mantenimientos',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Trabajos asignados y su estado',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _mostrarProximamente('Nuevo mantenimiento'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.doradoOscuro,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Nuevo'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_mantenimientos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.build_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No tienes mantenimientos asignados', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._mantenimientos.map((m) => _tarjetaMantenimiento(m)),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaMantenimiento(Mantenimiento m) {
    final estilo = _estiloEstado(m.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.doradoClaro.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(m.vehiculo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: estilo['fondo'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  estilo['texto'],
                  style: TextStyle(color: estilo['color'], fontWeight: FontWeight.w600, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(m.descripcion, style: const TextStyle(fontSize: 12, color: AppColors.textoMuted)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textoMuted),
              const SizedBox(width: 4),
              Text(_formatoFecha(m.fecha), style: const TextStyle(fontSize: 11, color: AppColors.textoMuted)),
              const Spacer(),
              if (m.estado != 'completado')
                TextButton(
                  onPressed: () => _mostrarProximamente('Actualizar estado'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Actualizar estado',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.doradoOscuro)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}