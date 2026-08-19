import 'package:flutter/material.dart';
import 'package:app_t4d/models/producto.dart';
import 'package:app_t4d/widgets/producto_card.dart';
// import '../services/inventario_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const encabezado = Color(0xFF13202E);
  static const textoEncabezado = Color(0xFFE7C98A);
}

class InventarioScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const InventarioScreen({super.key, this.usuario});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final TextEditingController _busquedaCtrl = TextEditingController();

  String _filtroEstado = 'todos'; // todos | alto | medio | bajo
  bool _cargando = false;

  List<Producto> _productos = [];

  /// El mecánico solo puede consultar el inventario: sin agregar,
  /// sin editar y sin eliminar productos.
  bool get _esMecanico => widget.usuario?['rol'] == 'mecanico';

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Por ahora carga datos de ejemplo (mock) para la parte visual.
  /// Cuando conectes el backend, reemplaza el contenido de este método
  /// por una llamada a tu InventarioService, por ejemplo:
  ///
  /// final data = await InventarioService().obtenerProductos();
  /// setState(() => _productos = data);
  Future<void> _cargarProductos() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _productos = [
        Producto(
          idProducto: 13,
          nombreProducto: 'Llantaa',
          blindaje: 'Blindaje Nivel 1',
          nombreProveedor: 'Ferretería Industrial SAS',
          stockActual: 3,
          stockMinimo: 10,
          precioActual: 45000,
        ),
        Producto(
          idProducto: 12,
          nombreProducto: 'Espejo blindado',
          blindaje: 'Blindaje Nivel 2',
          nombreProveedor: 'Distribuidora La Costa EU',
          stockActual: 15,
          stockMinimo: 10,
          precioActual: 70000,
        ),
        Producto(
          idProducto: 11,
          nombreProducto: 'Correa de Distribución',
          blindaje: 'Blindaje Nivel 2',
          nombreProveedor: 'Distribuidora La Costa EU',
          stockActual: 15,
          stockMinimo: 10,
          precioActual: 210000,
        ),
        Producto(
          idProducto: 10,
          nombreProducto: 'Kit de Embrague Toyota',
          blindaje: 'Blindaje Nivel 1',
          nombreProveedor: 'Comercializadora Andina CA',
          stockActual: 780000,
          stockMinimo: 10,
          precioActual: 780000,
        ),
      ];
      _cargando = false;
    });
  }

  String _normalizar(String texto) {
    const conTilde = 'áàäâéèëêíìïîóòöôúùüû';
    const sinTilde = 'aaaaeeeeiiiioooouuuu';
    var resultado = texto.toLowerCase();
    for (var i = 0; i < conTilde.length; i++) {
      resultado = resultado.replaceAll(conTilde[i], sinTilde[i]);
    }
    return resultado;
  }

  List<Producto> get _filtrados {
    final texto = _normalizar(_busquedaCtrl.text);
    return _productos.where((p) {
      final matchTexto = texto.isEmpty ||
          _normalizar(p.nombreProducto).contains(texto) ||
          _normalizar(p.idProducto.toString()).contains(texto) ||
          _normalizar(p.codigoBarras ?? '').contains(texto);
      final matchEstado = _filtroEstado == 'todos' || p.estado == _filtroEstado;
      return matchTexto && matchEstado;
    }).toList();
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarProductos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Encabezado / título de la sección
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
                        const Text(
                          'Gestión de Inventario',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _esMecanico
                              ? 'Consulta los productos de vehículos blindados'
                              : 'Administra productos de vehículos blindados',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  // El mecánico no puede agregar productos: botón oculto.
                  if (!_esMecanico)
                    ElevatedButton.icon(
                      onPressed: () => _mostrarProximamente('Agregar producto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.doradoOscuro,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Agregar'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Buscador
            TextField(
              controller: _busquedaCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar producto o código...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Chips de filtro por estado
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chipFiltro('Todos', 'todos'),
                  _chipFiltro('Alto', 'alto'),
                  _chipFiltro('Medio', 'medio'),
                  _chipFiltro('Bajo', 'bajo'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Lista de productos
            if (_cargando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filtrados.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No se encontraron productos', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              )
            else
              ..._filtrados.map(
                (p) => ProductoCard(
                  producto: p,
                  onVer: () => _mostrarProximamente('Ver "${p.nombreProducto}"'),
                  // El mecánico solo consulta: sin editar ni eliminar.
                  onEditar: _esMecanico
                      ? null
                      : () => _mostrarProximamente('Editar "${p.nombreProducto}"'),
                  onEliminar: _esMecanico ? null : () => _confirmarEliminar(p),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chipFiltro(String label, String valor) {
    final activo = _filtroEstado == valor;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: activo,
        onSelected: (_) => setState(() => _filtroEstado = valor),
        selectedColor: AppColors.dorado,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: activo ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        shape: StadiumBorder(side: BorderSide(color: AppColors.doradoClaro)),
      ),
    );
  }

  void _confirmarEliminar(Producto p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que deseas eliminar "${p.nombreProducto}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _productos.removeWhere((x) => x.idProducto == p.idProducto));
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}