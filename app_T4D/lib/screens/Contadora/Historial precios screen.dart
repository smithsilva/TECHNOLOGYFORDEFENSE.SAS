import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historial de Precios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const HistorialPreciosScreen(),
    );
  }
}

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const background = Color(0xFFF1EEE6);
  static const navy = Color(0xFF13161F);
  static const gold = Color(0xFFE0A93B);
  static const goldDark = Color(0xFFC8901E);
  static const green = Color(0xFF33B76A);
  static const greenBg = Color(0xFFE3F7EA);
  static const red = Color(0xFFE85454);
  static const redBg = Color(0xFFFCEAEA);
  static const grey = Color(0xFF8C8FA0);
  static const greyBg = Color(0xFFF1F1F5);
  static const textDark = Color(0xFF1C1E2A);
  static const textGrey = Color(0xFF8C8FA0);
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
enum TipoCambio { aumento, reduccion, sinCambio }

class RegistroPrecioModel {
  final String id;
  final String nombre;
  final String fecha;
  final double precioAnterior;
  final double precioActual;
  final TipoCambio tipo;
  final String nota;
  final double? porcentaje;

  const RegistroPrecioModel({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.precioAnterior,
    required this.precioActual,
    required this.tipo,
    required this.nota,
    this.porcentaje,
  });
}

String _formatoPrecio(double valor) {
  final entero = valor.round();
  final texto = entero.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < texto.length; i++) {
    final posDesdeFinal = texto.length - i;
    buffer.write(texto[i]);
    if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
  }
  return '\$$buffer';
}

final List<RegistroPrecioModel> historialPreciosData = [
  const RegistroPrecioModel(
    id: '#1',
    nombre: 'Correa de Distribución',
    fecha: '15/04/2026',
    precioAnterior: 210000,
    precioActual: 210000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#2',
    nombre: 'Kit de Embrague Toyota',
    fecha: '15/04/2026',
    precioAnterior: 780000,
    precioActual: 780000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#3',
    nombre: 'Filtro de Aceite',
    fecha: '15/04/2026',
    precioAnterior: 25000,
    precioActual: 25000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#4',
    nombre: 'Pastillas de Freno',
    fecha: '15/04/2026',
    precioAnterior: 120000,
    precioActual: 120000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#5',
    nombre: 'Batería 12V',
    fecha: '15/04/2026',
    precioAnterior: 350000,
    precioActual: 350000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#6',
    nombre: 'Amortiguador Delantero',
    fecha: '15/04/2026',
    precioAnterior: 450000,
    precioActual: 450000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#7',
    nombre: 'Aceite Motor 5W-30',
    fecha: '15/04/2026',
    precioAnterior: 18000,
    precioActual: 18000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#8',
    nombre: 'Bujías de Iridio',
    fecha: '15/04/2026',
    precioAnterior: 35000,
    precioActual: 35000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#9',
    nombre: 'Termostato Motor',
    fecha: '15/04/2026',
    precioAnterior: 85000,
    precioActual: 85000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#10',
    nombre: 'Radiador Aluminio',
    fecha: '15/04/2026',
    precioAnterior: 925000,
    precioActual: 620000,
    tipo: TipoCambio.reduccion,
    nota: 'Reducción por proveedor',
    porcentaje: 32.97,
  ),
  const RegistroPrecioModel(
    id: '#11',
    nombre: 'Espejo blindado',
    fecha: '15/04/2026',
    precioAnterior: 70000,
    precioActual: 70000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#12',
    nombre: 'Compresor de A/C',
    fecha: '15/04/2026',
    precioAnterior: 980000,
    precioActual: 980000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
  const RegistroPrecioModel(
    id: '#13',
    nombre: 'Llantaa',
    fecha: '15/04/2026',
    precioAnterior: 45000,
    precioActual: 45000,
    tipo: TipoCambio.sinCambio,
    nota: 'Sin cambio',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class HistorialPreciosScreen extends StatefulWidget {
  const HistorialPreciosScreen({super.key});

  @override
  State<HistorialPreciosScreen> createState() => _HistorialPreciosScreenState();
}

class _HistorialPreciosScreenState extends State<HistorialPreciosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<RegistroPrecioModel> get _filtrados {
    if (_query.trim().isEmpty) return historialPreciosData;
    final q = _query.toLowerCase();
    return historialPreciosData.where((r) => r.nombre.toLowerCase().contains(q)).toList();
  }

  int get _total => historialPreciosData.length;
  int get _aumentos => historialPreciosData.where((r) => r.tipo == TipoCambio.aumento).length;
  int get _reducciones => historialPreciosData.where((r) => r.tipo == TipoCambio.reduccion).length;
  int get _sinCambio => historialPreciosData.where((r) => r.tipo == TipoCambio.sinCambio).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _PanelContadoraAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 14),
          _buildStatsGrid(),
          const SizedBox(height: 14),
          _buildSearchBar(),
          const SizedBox(height: 14),
          ..._filtrados.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RegistroCard(registro: r),
              )),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Historial de Precios',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(width: 22, height: 2.4, color: AppColors.gold),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 9, color: AppColors.gold),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.gold),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'CONTADORA · Solo lectura',
              style: TextStyle(
                color: AppColors.goldDark,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Total Registros', value: '$_total', color: AppColors.navy)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(label: 'Aumentos', value: '$_aumentos', color: AppColors.red)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Reducciones', value: '$_reducciones', color: AppColors.goldDark)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(label: 'Sin Cambio', value: '$_sinCambio', color: AppColors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: const InputDecoration(
          hintText: 'Buscar producto...',
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13.5),
          prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        ),
      ),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class _CambioBadge extends StatelessWidget {
  final TipoCambio tipo;
  final double? porcentaje;

  const _CambioBadge({required this.tipo, this.porcentaje});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String texto;
    late IconData icono;

    switch (tipo) {
      case TipoCambio.aumento:
        bg = AppColors.redBg;
        fg = AppColors.red;
        icono = Icons.arrow_upward;
        texto = porcentaje != null ? '${porcentaje!.toStringAsFixed(2)}%' : 'Aumento';
        break;
      case TipoCambio.reduccion:
        bg = AppColors.greenBg;
        fg = AppColors.green;
        icono = Icons.arrow_downward;
        texto = porcentaje != null ? '${porcentaje!.toStringAsFixed(2)}%' : 'Reducción';
        break;
      case TipoCambio.sinCambio:
        bg = AppColors.greyBg;
        fg = AppColors.grey;
        icono = Icons.drag_handle;
        texto = 'Sin cambio';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 11, color: fg),
          const SizedBox(width: 3),
          Text(texto, style: TextStyle(color: fg, fontSize: 10.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RegistroCard extends StatelessWidget {
  final RegistroPrecioModel registro;

  const _RegistroCard({required this.registro});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  registro.nombre,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              _CambioBadge(tipo: registro.tipo, porcentaje: registro.porcentaje),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${registro.id} · ${registro.fecha}',
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _formatoPrecio(registro.precioAnterior),
                style: const TextStyle(fontSize: 12.5, color: AppColors.textGrey),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.arrow_forward, size: 12, color: AppColors.textGrey),
              ),
              Text(
                _formatoPrecio(registro.precioActual),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            registro.nota,
            style: TextStyle(
              fontSize: 11,
              color: registro.tipo == TipoCambio.reduccion ? AppColors.green : AppColors.textGrey,
              fontStyle: registro.tipo == TipoCambio.sinCambio ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== APPBAR COMPARTIDA ====================
class _PanelContadoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PanelContadoraAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.navy),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {},
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.badge, color: AppColors.navy, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'BIENVENIDO',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      'Panel de Contadora',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.gold,
                      child: Icon(Icons.person, size: 12, color: AppColors.navy),
                    ),
                    SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Usuario', style: TextStyle(color: Colors.white, fontSize: 11, height: 1)),
                        Text('Contadora', style: TextStyle(color: AppColors.gold, fontSize: 9, height: 1)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}