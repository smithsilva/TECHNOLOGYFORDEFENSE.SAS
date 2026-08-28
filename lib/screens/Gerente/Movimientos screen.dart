import 'package:flutter/material.dart';

// ============================================================
// PALETA DE COLORES T4D
// ============================================================
class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const encabezado = Color(0xFF13202E);

  // Colores auxiliares para las etiquetas Entrada/Salida
  static const verde = Color(0xFF2E7D32);
  static const verdeFondo = Color(0xFFE3F3E5);
  static const rojo = Color(0xFFC62828);
  static const rojoFondo = Color(0xFFFBE6E6);
  static const grisTexto = Color(0xFF6B7280);
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
        _buildTituloYAcciones(),
        const SizedBox(height: 16),
        _buildTarjetasResumen(),
        const SizedBox(height: 20),
        _buildFiltrosYBusqueda(),
        const SizedBox(height: 20),
        Text(
          'Historial de Movimientos (${_movimientosFiltrados.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.encabezado,
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
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  // ------------------------------------------------------------
  // APP BAR (barra superior oscura) — solo se dibuja cuando la
  // pantalla NO está embebida, para que no se repita junto con el
  // header del shell principal.
  // ------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.encabezado,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),
      title: Row(
        children: [
          // Logo circular
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.dorado, width: 1.5),
              color: AppColors.encabezado,
            ),
            child: const Center(
              child: Text(
                'T4D',
                style: TextStyle(
                  color: AppColors.dorado,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BIENVENIDO',
                style: TextStyle(
                  color: AppColors.doradoClaro,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Movimientos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.dorado,
                child: Icon(Icons.person, size: 16, color: AppColors.encabezado),
              ),
              const SizedBox(width: 6),
              const Text(
                'Gerente',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TÍTULO + BOTONES EXPORTAR / ACTUALIZAR
  // ------------------------------------------------------------
  Widget _buildTituloYAcciones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Movimientos de Inventario',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.encabezado,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Historial de entradas y salidas',
          style: TextStyle(fontSize: 13, color: AppColors.grisTexto),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined,
                    size: 18, color: AppColors.encabezado),
                label: const Text(
                  'Exportar',
                  style: TextStyle(
                    color: AppColors.encabezado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dorado,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 18, color: AppColors.encabezado),
                label: const Text(
                  'Actualizar',
                  style: TextStyle(color: AppColors.encabezado),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.dorado),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
            titulo: 'Total Entradas',
            valor: _formatearNumero(_totalEntradas),
            color: AppColors.dorado,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _tarjetaResumen(
            titulo: 'Total Salidas',
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.encabezado,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'unidades en el periodo filtrado',
            style: TextStyle(fontSize: 10, color: AppColors.grisTexto),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FILTROS Y BÚSQUEDA
  // ------------------------------------------------------------
  Widget _buildFiltrosYBusqueda() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.filter_alt_outlined, color: AppColors.dorado, size: 18),
              SizedBox(width: 6),
              Text(
                'Filtros y Búsqueda',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.encabezado,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _busquedaController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Buscar por producto o usuario...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.grisTexto),
              prefixIcon: const Icon(Icons.search, color: AppColors.grisTexto),
              filled: true,
              fillColor: AppColors.fondo,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.doradoClaro),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.dorado),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chipFiltro('Todos'),
              _chipFiltro('Entrada'),
              _chipFiltro('Salida'),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _filtroSeleccionado = 'Todos';
                    _busquedaController.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.doradoClaro),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, size: 14, color: AppColors.encabezado),
                      SizedBox(width: 4),
                      Text('Limpiar',
                          style: TextStyle(fontSize: 12, color: AppColors.encabezado)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipFiltro(String etiqueta) {
    final seleccionado = _filtroSeleccionado == etiqueta;
    return GestureDetector(
      onTap: () => setState(() => _filtroSeleccionado = etiqueta),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: seleccionado ? AppColors.dorado : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: seleccionado ? AppColors.dorado : AppColors.doradoClaro,
          ),
        ),
        child: Text(
          etiqueta,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: seleccionado ? AppColors.encabezado : AppColors.grisTexto,
          ),
        ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                m.fecha,
                style: const TextStyle(fontSize: 11, color: AppColors.grisTexto),
              ),
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
            ],
          ),
          const SizedBox(height: 6),
          Text(
            m.producto,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.encabezado,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${m.usuario} · ${m.detalle}',
                  style: const TextStyle(fontSize: 12, color: AppColors.grisTexto),
                ),
              ),
              Text(
                '$signo${_formatearNumero(m.cantidad)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorBadge,
                ),
              ),
            ],
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