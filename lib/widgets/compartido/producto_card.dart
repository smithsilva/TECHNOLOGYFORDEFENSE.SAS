import 'package:flutter/material.dart';
import '../../models/producto.dart';

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondoCard = Color(0xFFFFFFFF);
  static const textoMuted = Color(0xFF8A93A3);
  static const chipMoradoBg = Color(0xFFEDE9FE);
  static const chipMoradoTxt = Color(0xFF6D5BD0);
}

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

  // Color principal según el estado (se usa en badge, borde lateral y stock)
  Color get _colorEstado {
    switch (producto.estado) {
      case 'alto':
        return const Color(0xFF1F9D55);
      case 'medio':
        return const Color(0xFFC98A1B);
      default:
        return const Color(0xFFD64545);
    }
  }

  Color get _fondoBadge {
    switch (producto.estado) {
      case 'alto':
        return const Color(0xFFE3F7E9);
      case 'medio':
        return const Color(0xFFFCEFD8);
      default:
        return const Color(0xFFFBE3E3);
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
    final color = _colorEstado;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.fondoCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Borde lateral de color (según estado del stock)
              Container(
                width: 5,
                color: color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // #id + nombre  ---  badge de estado
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 15, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '#${producto.idProducto}  ',
                                    style: const TextStyle(
                                      color: AppColors.doradoOscuro,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  TextSpan(
                                    text: producto.nombreProducto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _badge(_textoEstado, color, _fondoBadge),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Chip blindaje/categoría  ---  proveedor
                      Row(
                        children: [
                          if (producto.blindaje != null || producto.nombreCategoria != null)
                            _chip(producto.blindaje ?? producto.nombreCategoria ?? ''),
                          const Spacer(),
                          if (producto.nombreProveedor != null)
                            Flexible(
                              child: Text(
                                producto.nombreProveedor!,
                                style: const TextStyle(fontSize: 12, color: AppColors.textoMuted),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 10),

                      // Stock / Precio  ---  Acciones
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _statChip('Stock', '${producto.stockActual}', color),
                          const SizedBox(width: 22),
                          _statChip(
                            'Precio',
                            producto.precioActual != null
                                ? '\$${producto.precioActual!.toStringAsFixed(0)}'
                                : '—',
                            Colors.black87,
                          ),
                          const Spacer(),
                          // Ver — mismo estilo dorado claro que "Editar" (igual al Historial de Precios)
                          _accionBoton(Icons.remove_red_eye_outlined, AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD), onVer),
                          const SizedBox(width: 8),
                          // Editar — dorado claro
                          _accionBoton(Icons.edit_outlined, AppColors.doradoOscuro,
                              const Color(0xFFFBF1DD), onEditar),
                          const SizedBox(width: 8),
                          // Eliminar — rojo
                          _accionBoton(Icons.delete_outline, const Color(0xFFD64545),
                              const Color(0xFFFBE3E3), onEliminar),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String texto, Color color, Color fondo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(20)),
      child: Text(
        texto,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }

  Widget _chip(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.chipMoradoBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: AppColors.chipMoradoTxt,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _statChip(String label, String valor, Color colorValor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textoMuted)),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorValor),
        ),
      ],
    );
  }

  Widget _accionBoton(IconData icon, Color color, Color fondo, VoidCallback? onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}