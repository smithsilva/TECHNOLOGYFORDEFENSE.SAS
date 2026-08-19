import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Métodos de Pago',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const MetodosPagoScreen(),
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
  static const textDark = Color(0xFF1C1E2A);
  static const textGrey = Color(0xFF8C8FA0);
  static const cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
class MetodoPagoModel {
  final String nombre;
  final String descripcion;
  final String comision;
  final String estado;

  const MetodoPagoModel({
    required this.nombre,
    required this.descripcion,
    required this.comision,
    required this.estado,
  });
}

final List<MetodoPagoModel> metodosPagoData = [
  const MetodoPagoModel(
    nombre: 'Efectivo',
    descripcion: 'Pago en efectivo en punto físico',
    comision: '0%',
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Transferencia Bancaria',
    descripcion: 'Transferencia entre cuentas bancarias',
    comision: '0%',
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Nequi',
    descripcion: 'Pago digital a través de la aplicación Nequi',
    comision: '0%',
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Tarjeta Crédito/Débito',
    descripcion: 'Pago con tarjeta mediante datáfono o pasarela',
    comision: '2.5%',
    estado: 'Activo',
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class MetodosPagoScreen extends StatelessWidget {
  const MetodosPagoScreen({super.key});

  int get _totalMetodos => metodosPagoData.length;
  int get _activos =>
      metodosPagoData.where((m) => m.estado == 'Activo').length;

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
          _buildStatsRow(),
          const SizedBox(height: 14),
          _buildTable(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Métodos de Pago',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 26, height: 2.4, color: AppColors.gold),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 10, color: AppColors.gold),
              const SizedBox(width: 4),
              Container(width: 26, height: 2.4, color: AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Total métodos', value: '$_totalMetodos'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(label: 'Activos', value: '$_activos'),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('MÉTODO', style: _headerStyle)),
                Expanded(flex: 2, child: Text('COMISIÓN', style: _headerStyle, textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('ESTADO', style: _headerStyle, textAlign: TextAlign.right)),
              ],
            ),
          ),
          ...metodosPagoData.map((m) => _MetodoRow(metodo: m)),
        ],
      ),
    );
  }
}

const TextStyle _headerStyle = TextStyle(
  color: Colors.white,
  fontSize: 11,
  fontWeight: FontWeight.bold,
);

// ==================== WIDGETS AUXILIARES ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

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
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final String estado;

  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final bool activo = estado.toLowerCase() == 'activo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? AppColors.greenBg : const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: activo ? AppColors.green : AppColors.textGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetodoRow extends StatelessWidget {
  final MetodoPagoModel metodo;

  const _MetodoRow({required this.metodo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEFEFF2))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metodo.nombre,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metodo.descripcion,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              metodo.comision,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.goldDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: _EstadoBadge(estado: metodo.estado),
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