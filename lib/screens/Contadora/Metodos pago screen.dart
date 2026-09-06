import 'package:flutter/material.dart';

// ==================== PALETA DE COLORES ====================
class AppColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const doradoMezcla = Color(0xFFAB812E); // punto medio dorado/doradoOscuro
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

  // Alias usados en esta pantalla, ahora apuntando a la paleta nueva.
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

// ==================== MODELO ====================
// Nota: dejó de ser 100% inmutable "const" porque ahora se crea
// dinámicamente desde el formulario (el usuario define el % real).
class MetodoPagoModel {
  final String nombre;
  final String descripcion;
  final double comisionValor; // porcentaje numérico real, ej: 2.5
  final String estado;

  const MetodoPagoModel({
    required this.nombre,
    required this.descripcion,
    required this.comisionValor,
    required this.estado,
  });

  String get comisionTexto {
    // Si es entero (0, 2, 5...) no muestra decimales; si no, muestra 1 decimal.
    final esEntero = comisionValor == comisionValor.roundToDouble();
    final texto = esEntero
        ? comisionValor.toStringAsFixed(0)
        : comisionValor.toStringAsFixed(1);
    return '$texto%';
  }
}

// Datos iniciales (ya no son "const" con 0% fijo a fuerza; son el punto
// de partida, y cada método nuevo que agregues define SU PROPIO %).
final List<MetodoPagoModel> metodosPagoDataInicial = [
  const MetodoPagoModel(
    nombre: 'Efectivo',
    descripcion: 'Pago en efectivo en punto físico',
    comisionValor: 0,
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Transferencia Bancaria',
    descripcion: 'Transferencia entre cuentas bancarias',
    comisionValor: 0,
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Nequi',
    descripcion: 'Pago digital a través de la aplicación Nequi',
    comisionValor: 0,
    estado: 'Activo',
  ),
  const MetodoPagoModel(
    nombre: 'Tarjeta Crédito/Débito',
    descripcion: 'Pago con tarjeta mediante datáfono o pasarela',
    comisionValor: 2.5,
    estado: 'Activo',
  ),
];

// ==================== PANTALLA PRINCIPAL (AHORA STATEFUL) ====================
class MetodosPagoScreen extends StatefulWidget {
  const MetodosPagoScreen({super.key});

  @override
  State<MetodosPagoScreen> createState() => _MetodosPagoScreenState();
}

class _MetodosPagoScreenState extends State<MetodosPagoScreen> {
  // Esta lista vive en memoria mientras la app está abierta.
  // Si necesitas que sobreviva a cerrar la app, aquí es donde
  // conectarías shared_preferences/sqflite, o una API si varios
  // dispositivos deben ver lo mismo.
  final List<MetodoPagoModel> _metodos = List.of(metodosPagoDataInicial);

  int get _totalMetodos => _metodos.length;
  int get _activos => _metodos.where((m) => m.estado == 'Activo').length;

  Future<void> _abrirFormulario({MetodoPagoModel? existente, int? index}) async {
    final nombreCtrl = TextEditingController(text: existente?.nombre ?? '');
    final descCtrl = TextEditingController(text: existente?.descripcion ?? '');
    final comisionCtrl = TextEditingController(
      text: existente != null ? existente.comisionValor.toString() : '',
    );
    String estadoSeleccionado = existente?.estado ?? 'Activo';

    final resultado = await showDialog<MetodoPagoModel>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existente == null
                  ? 'Agregar método de pago'
                  : 'Editar método de pago'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: comisionCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Comisión (%)',
                        hintText: 'Ej: 2.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: estadoSeleccionado,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const [
                        DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                        DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => estadoSeleccionado = v);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nombre = nombreCtrl.text.trim();
                    final comision =
                        double.tryParse(comisionCtrl.text.trim().replaceAll(',', '.'));
                    if (nombre.isEmpty || comision == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Ingresa un nombre válido y una comisión numérica.'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      MetodoPagoModel(
                        nombre: nombre,
                        descripcion: descCtrl.text.trim(),
                        comisionValor: comision,
                        estado: estadoSeleccionado,
                      ),
                    );
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          _metodos[index] = resultado;
        } else {
          _metodos.add(resultado);
        }
      });
    }
  }

  void _eliminarMetodo(int index) {
    setState(() => _metodos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
            children: [
              const _PageHeaderCard(
                eyebrow: 'CONTADORA - PAGOS',
                title: 'Métodos de Pago',
                subtitle: 'Canales de pago aceptados',
              ),
              const SizedBox(height: 14),
              _buildStatsRow(),
              const SizedBox(height: 14),
              ..._metodos.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _MetodoCard(
                        metodo: entry.value,
                        onEditar: () => _abrirFormulario(
                          existente: entry.value,
                          index: entry.key,
                        ),
                        onEliminar: () => _eliminarMetodo(entry.key),
                      ),
                    ),
                  ),
            ],
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: FloatingActionButton.extended(
              onPressed: () => _abrirFormulario(),
              backgroundColor: AppColors.navy,
              icon: const Icon(Icons.add, color: AppColors.gold),
              label: const Text(
                'Agregar método',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total',
            value: '$_totalMetodos',
            accentColor: AppColors.gold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Activos',
            value: '$_activos',
            accentColor: AppColors.green,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// TARJETA DE ENCABEZADO ESTILO "HISTORIAL DE PRECIOS"
// ============================================================
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
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
              SizedBox(width: 3),
              Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE ESTADÍSTICA ====================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(height: 4, color: accentColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE MÉTODO DE PAGO ====================
class _MetodoCard extends StatelessWidget {
  final MetodoPagoModel metodo;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _MetodoCard({
    required this.metodo,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
            Container(width: 4, color: AppColors.enlace),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            metodo.nombre,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        _EstadoBadge(estado: metodo.estado),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      metodo.descripcion,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comisión',
                          style: TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                        ),
                        Text(
                          metodo.comisionTexto,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textGrey),
                  onPressed: onEditar,
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.rojo),
                  onPressed: onEliminar,
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
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
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}