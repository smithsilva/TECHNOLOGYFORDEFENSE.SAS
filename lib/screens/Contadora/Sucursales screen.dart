import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sucursal.dart';
import '../services/sucursales_service.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const doradoMezcla = Color(0xFFAB812E);
  static const fondo = Color(0xFFFAF3E4);

  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);

  static const verde = Color(0xFF2E9E5B);
  static const verdeFondo = Color(0xFFDDF2E1);

  static const naranja = Color(0xFFA17A2E);
  static const naranjaFondo = Color(0xFFF5E3C3);

  static const rojo = Color(0xFFC0293B);
  static const rojoFondo = Color(0xFFFADCE0);

  static const textoMuted = Color(0xFF6B7280);
  static const enlace = Color(0xFF2563EB);

  static const rosaMuted = Color(0xFFB98CA0);
  static const azulValor = Color(0xFF1B4F91);

  static const background = fondo;
  static const navy = navyOscuro;
  static const gold = dorado;
  static const goldDark = doradoOscuro;
  static const green = verde;
  static const greenBg = verdeFondo;
  static const textDark = Color(0xFF111827);
  static const textGrey = textoMuted;
  static const white = Colors.white;
  static const cardBorder = Color(0xFFEFEFF2);
  static const cardShadow = Color(0x14000000);
}

// ==================== PANTALLA PRINCIPAL ====================
class SucursalesScreen extends StatefulWidget {
  const SucursalesScreen({super.key});

  @override
  State<SucursalesScreen> createState() => _SucursalesScreenState();
}

class _SucursalesScreenState extends State<SucursalesScreen> {
  final SucursalesService _service = SucursalesService();

  List<Sucursal> _sucursales = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          _error = 'Sesión no encontrada. Vuelve a iniciar sesión.';
          _cargando = false;
        });
        return;
      }

      final datos = await _service.obtenerSucursales(token);
      setState(() {
        _sucursales = datos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _sucursales.length;
    final activas = _sucursales.where((s) => s.activo).length;

    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: _cargarSucursales,
        color: AppColors.gold,
        child: _buildBody(total, activas),
      ),
    );
  }

  Widget _buildBody(int total, int activas) {
    if (_cargando) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 120),
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      );
    }

    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - SUCURSALES',
            title: 'Sucursales',
            subtitle: 'No se pudieron cargar los datos',
          ),
          const SizedBox(height: 24),
          _ErrorState(mensaje: _error!, onReintentar: _cargarSucursales),
        ],
      );
    }

    if (_sucursales.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _PageHeaderCard(
            eyebrow: 'CONTADORA - SUCURSALES',
            title: 'Sucursales',
            subtitle: '0 sucursales registradas',
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'No hay sucursales registradas todavía.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        _PageHeaderCard(
          eyebrow: 'CONTADORA - SUCURSALES',
          title: 'Sucursales',
          subtitle: '$total sucursales registradas',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                valor: '$total',
                label: 'Total',
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                valor: '$activas',
                label: 'Activas',
                color: AppColors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...List.generate(_sucursales.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SucursalCard(
              numero: '#${index + 1}',
              sucursal: _sucursales[index],
            ),
          );
        }),
      ],
    );
  }
}

// ==================== ESTADO DE ERROR ====================
class _ErrorState extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorState({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.rojo.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.rojo, size: 32),
          const SizedBox(height: 10),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onReintentar,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ENCABEZADO ====================
class _PageHeaderCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _PageHeaderCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.subtitulo,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ESTADÍSTICA ====================
class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BADGE DE ESTADO (activo) ====================
class _EstadoBadge extends StatelessWidget {
  final bool activo;

  const _EstadoBadge({required this.activo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? AppColors.greenBg : const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        activo ? 'Activa' : 'Inactiva',
        style: TextStyle(
          color: activo ? AppColors.green : AppColors.textGrey,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ==================== FILA ETIQUETA / VALOR ====================
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.rosaMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.azulValor,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE SUCURSAL ====================
class _SucursalCard extends StatelessWidget {
  final String numero;
  final Sucursal sucursal;

  const _SucursalCard({required this.numero, required this.sucursal});

  String get _horario {
    final apertura = sucursal.horarioApertura;
    final cierre = sucursal.horarioCierre;
    if (apertura == null && cierre == null) return '—';
    return '${apertura ?? '—'} - ${cierre ?? '—'}';
  }

  @override
  Widget build(BuildContext context) {
    final bool activa = sucursal.activo;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: activa ? AppColors.green : AppColors.textGrey,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$numero ',
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: sucursal.nombre,
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _EstadoBadge(activo: activa),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${sucursal.id}',
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Ciudad', value: sucursal.ciudad ?? '—'),
                    _InfoRow(label: 'Dirección', value: sucursal.direccion ?? '—'),
                    _InfoRow(label: 'Teléfono', value: sucursal.telefono ?? '—'),
                    _InfoRow(label: 'Horario', value: _horario),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}