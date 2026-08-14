import 'package:flutter/material.dart';
import '../models/producto.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondoCard = Color(0xFFFFFDF8);
  static const bordeCard = Color(0xFFE7C98A);
  static const textoMuted = Color(0xFF6B7280);
}

/// Tarjeta individual de producto, tal como se ve en el diseño:
/// nombre + badge de estado, categoría/proveedor, stock/precio + acciones.
class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onVer;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;

  const ProductoCard({
    super.key,
    required this.producto,
    this.onVer,
    this.onEditar,
    this.onEliminar,
  });

  Map<String, Color> get _coloresEstado {
    switch (producto.estado) {
      case 'alto':
        return {'texto': const Color(0xFF1F9D55), 'fondo': const Color(0xFFE3F7E9)};
      case 'medio':
        return {'texto': const Color(0xFFB8860B), 'fondo': const Color(0xFFFDF3DA)};
      default:
        return {'texto': const Color(0xFFC0392B), 'fondo': const Color(0xFFFBE2DF)};
    }
  }

  String get _textoEstado {
    switch (producto.estado) {
      case 'alto':
        return 'Stock Alto';
      case 'medio':
        return 'Stock Medio';
      default:
        return 'Stock Bajo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = _coloresEstado;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondoCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordeCard.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: #id + nombre  ---  badge de estado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '#${producto.idProducto}  ',
                        style: const TextStyle(
                          color: AppColors.doradoOscuro,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: producto.nombreProducto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _badge(_textoEstado, colores['texto']!, colores['fondo']!),
            ],
          ),
          const SizedBox(height: 6),

          // Fila de subtítulo: blindaje / categoría  ---  proveedor
          Row(
            children: [
              if (producto.blindaje != null || producto.nombreCategoria != null)
                Expanded(
                  child: Text(
                    producto.blindaje ?? producto.nombreCategoria ?? '',
                    style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (producto.nombreProveedor != null)
                Text(
                  producto.nombreProveedor!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Fila inferior: Stock / Precio  ---  Acciones
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _statChip('Stock', '${producto.stockActual}', colores['texto']!),
              const SizedBox(width: 18),
              _statChip(
                'Precio',
                producto.precioActual != null
                    ? '\$${producto.precioActual!.toStringAsFixed(0)}'
                    : '—',
                Colors.black87,
              ),
              const Spacer(),
              _accionIcono(Icons.remove_red_eye_outlined, Colors.grey.shade700, onVer),
              const SizedBox(width: 10),
              _accionIcono(Icons.edit_outlined, AppColors.doradoOscuro, onEditar),
              const SizedBox(width: 10),
              _accionIcono(Icons.delete_outline, const Color(0xFFC0392B), onEliminar),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String texto, Color color, Color fondo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }

  Widget _statChip(String label, String valor, Color colorValor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
        Text(
          valor,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: colorValor,
          ),
        ),
      ],
    );
  }

  Widget _accionIcono(IconData icon, Color color, VoidCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 19, color: color),
      ),
    );
  }
}