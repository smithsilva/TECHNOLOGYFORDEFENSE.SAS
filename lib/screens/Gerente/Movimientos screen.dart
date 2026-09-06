import 'package:flutter/material.dart';

// ============================================================
// PALETA DE COLORES T4D
// ============================================================
class AppColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoBrillante = Color(0xFFF2A93D);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoMezcla = Color(0xFFAB812E);
  static const doradoClaro = Color(0xFFE8C97A);
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
}

// ============================================================
// MODELO DE DATOS
// ============================================================
enum TipoMovimiento { entrada, salida }

class Movimiento {
  final String fecha; // ej: "02/07/2026, 02:50 p.m."
  final String producto; // ej: "Llanta"
  final String usuario; // ej: "Juan"
  final String detalle; // ej: "Ajuste de stock desde edición de producto"
  final int cantidad; // positivo o negativo
  final TipoMovimiento tipo;

  const Movimiento({
    required this.fecha,
    required this.producto,
    required this.usuario,
    required this.detalle,
    required this.cantidad,
    required this.tipo,
  });
}

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================
class MovimientosScreen extends StatefulWidget {
  const MovimientosScreen({
    super.key,
    this.embedded = false,
  });

  // Si embedded = true, no dibuja su propio Scaffold/AppBar (se usa
  // así dentro de main_shell_gerente.dart, que ya provee el único
  // encabezado "BIENVENIDO" compartido por todas las pantallas).
  final bool embedded;

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  String _filtroSeleccionado = 'Todos';
  final TextEditingController _busquedaController = TextEditingController();

  // ------------------------------------------------------------
  // DATOS DE EJEMPLO (reemplaza esto por tu consulta real a Supabase)
  // ------------------------------------------------------------
  final List<Movimiento> _movimientos = const [
    Movimiento(
      fecha: '02/07/2026, 02:50 p.m.',
      producto: 'Llanta',
      usuario: 'Juan',
      detalle: 'Ajuste de stock desde edición de producto',
      cantidad: -3,
      tipo: TipoMovimiento.salida,
    ),
    Movimiento(
      fecha: '02/07/2026, 02:49 p.m.',
      producto: 'Llanta',
      usuario: 'Juan',
      detalle: 'Ajuste de stock desde edición de producto',
      cantidad: 2,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '02/07/2026, 02:47 p.m.',
      producto: 'Llanta',
      usuario: 'Juan',
      detalle: 'Ajuste de stock desde edición de producto',
      cantidad: -23,
      tipo: TipoMovimiento.salida,
    ),
    Movimiento(
      fecha: '02/07/2026, 02:46 p.m.',
      producto: 'Llanta',
      usuario: 'Juan',
      detalle: 'Ajuste de stock desde edición de producto',
      cantidad: 29,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '01/07/2026, 12:12 a.m.',
      producto: 'Amortiguador Delantero Reforzado',
      usuario: 'Juan',
      detalle: 'Ajuste de stock desde edición de producto',
      cantidad: -7,
      tipo: TipoMovimiento.salida,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:32 a.m.',
      producto: 'Correa de Distribución',
      usuario: 'Camilo',
      detalle: 'Stock inicial al crear producto',
      cantidad: 15,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:22 a.m.',
      producto: 'Kit de Embrague Toyota',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 780000,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:21 a.m.',
      producto: 'Disco de Freno Delantero',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 18,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:21 a.m.',
      producto: 'Amortiguador Delantero Reforzado',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 12,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:20 a.m.',
      producto: 'Filtro de Aire Militar',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 25,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:19 a.m.',
      producto: 'Líquido de Frenos DOT 4',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 40,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:18 a.m.',
      producto: 'Neumático Todo Terreno 265/70R17',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 16,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:37 a.m.',
      producto: 'Batería 12V 900A',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 10,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:16 a.m.',
      producto: 'Pastillas de Freno Delanteras',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 20,
      tipo: TipoMovimiento.entrada,
    ),
    Movimiento(
      fecha: '25/06/2026, 06:15 a.m.',
      producto: 'Filtro de Aceite Toyota Hilux',
      usuario: 'Juan',
      detalle: 'Stock inicial al crear producto',
      cantidad: 30,
      tipo: TipoMovimiento.entrada,
    ),
  ];

  List<Movimiento> get _movimientosFiltrados {
    var lista = _movimientos;

    if (_filtroSeleccionado == 'Entrada') {
      lista = lista.where((m) => m.tipo == TipoMovimiento.entrada).toList();
    } else if (_filtroSeleccionado == 'Salida') {
      lista = lista.where((m) => m.tipo == TipoMovimiento.salida).toList();
    }

    final texto = _busquedaController.text.trim().toLowerCase();
    if (texto.isNotEmpty) {
      lista = lista
          .where((m) =>
              m.producto.toLowerCase().contains(texto) ||
              m.usuario.toLowerCase().contains(texto))
          .toList();
    }
    return lista;
  }

  int get _totalEntradas => _movimientos
      .where((m) => m.tipo == TipoMovimiento.entrada)
      .fold(0, (sum, m) => sum + m.cantidad);

  int get _totalSalidas => _movimientos
      .where((m) => m.tipo == TipoMovimiento.salida)
      .fold(0, (sum, m) => sum + m.cantidad.abs());

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _buildHeroOscuro(),
        const SizedBox(height: 14),
        _buildTarjetasResumen(),
        const SizedBox(height: 14),
        _buildBusqueda(),
        const SizedBox(height: 10),
        _buildFiltros(),
        const SizedBox(height: 10),
        Center(
          child: Text(
            '${_movimientosFiltrados.length} REGISTROS',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: AppColors.textoMuted,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ..._movimientosFiltrados.map((m) => _buildMovimientoCard(m)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }

    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: SafeArea(child: _buildContent(context)),
    );
  }

  // ------------------------------------------------------------
  // TARJETA OSCURA SUPERIOR (título + subtítulo + botones)
  // ------------------------------------------------------------
  Widget _buildHeroOscuro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.navyOscuro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ADMINISTRADOR · MOVIMIENTOS',
            style: TextStyle(
              color: AppColors.dorado,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Movimientos de Inventario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Historial completo de entradas y salidas',
            style: TextStyle(
              color: AppColors.subtitulo,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined,
                      size: 18, color: Colors.white),
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Exportar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down,
                          size: 18, color: Colors.white),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.doradoMezcla,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                  label: const Text(
                    'Actualizar',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.navyClaro),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TARJETAS "TOTAL ENTRADAS" / "TOTAL SALIDAS"
  // ------------------------------------------------------------
  Widget _buildTarjetasResumen() {
    return Row(
      children: [
        Expanded(
          child: _tarjetaResumen(
            titulo: 'TOTAL ENTRADAS',
            valor: _formatearNumero(_totalEntradas),
            color: AppColors.verde,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _tarjetaResumen(
            titulo: 'TOTAL SALIDAS',
            valor: _formatearNumero(_totalSalidas),
            color: AppColors.rojo,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaResumen({
    required String titulo,
    required String valor,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              color: AppColors.textoMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'unidades',
            style: TextStyle(fontSize: 10, color: AppColors.textoMuted),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BARRA DE BÚSQUEDA
  // ------------------------------------------------------------
  Widget _buildBusqueda() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _busquedaController,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          hintText: 'Buscar por producto o usuario...',
          hintStyle: TextStyle(fontSize: 13, color: AppColors.textoMuted),
          prefixIcon: Icon(Icons.search, color: AppColors.textoMuted),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CHIPS DE FILTRO (Todos / Entrada / Salida)
  // ------------------------------------------------------------
  Widget _buildFiltros() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _chipFiltro('Todos'),
        _chipFiltro('Entrada'),
        _chipFiltro('Salida'),
        _chipOrden(),
      ],
    );
  }

  Widget _chipFiltro(String etiqueta) {
    final seleccionado = _filtroSeleccionado == etiqueta;
    return GestureDetector(
      onTap: () => setState(() => _filtroSeleccionado = etiqueta),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.doradoMezcla,
            width: seleccionado ? 1.6 : 1,
          ),
        ),
        child: Text(
          etiqueta,
          style: TextStyle(
            fontSize: 12,
            fontWeight: seleccionado ? FontWeight.bold : FontWeight.w600,
            color: AppColors.doradoMezcla,
          ),
        ),
      ),
    );
  }

  // Chip decorativo de orden/periodo, estilo igual a los de filtro
  Widget _chipOrden() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.doradoMezcla, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Todos',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.doradoMezcla,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down,
              size: 16, color: AppColors.doradoMezcla),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TARJETA DE CADA MOVIMIENTO
  // ------------------------------------------------------------
  Widget _buildMovimientoCard(Movimiento m) {
    final esEntrada = m.tipo == TipoMovimiento.entrada;
    final colorBadge = esEntrada ? AppColors.verde : AppColors.rojo;
    final fondoBadge = esEntrada ? AppColors.verdeFondo : AppColors.rojoFondo;
    final signo = m.cantidad > 0 ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        border: Border(left: BorderSide(color: colorBadge, width: 5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: fondoBadge,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  esEntrada ? 'Entrada' : 'Salida',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorBadge,
                  ),
                ),
              ),
              Text(
                '$signo${_formatearNumero(m.cantidad)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorBadge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            m.producto,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.navyOscuro,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_circle,
                      size: 15, color: AppColors.enlace),
                  const SizedBox(width: 4),
                  Text(
                    m.usuario,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.enlace,
                    ),
                  ),
                ],
              ),
              Text(
                m.fecha,
                style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            m.detalle,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: AppColors.textoMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Formatea números con separador de miles: 780000 -> 780.000
  // ------------------------------------------------------------
  String _formatearNumero(int numero) {
    final esNegativo = numero < 0;
    final numAbs = numero.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < numAbs.length; i++) {
      if (i > 0 && (numAbs.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(numAbs[i]);
    }
    return (esNegativo ? '-' : '') + buffer.toString();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }
}