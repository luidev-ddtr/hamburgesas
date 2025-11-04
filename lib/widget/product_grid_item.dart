import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_hamburgesas/models/product_model.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onAddToCart,
  });
 
  /// Construye el widget de imagen apropiado (Asset o File) basado en la ruta.
  Widget _buildProductImage() {
    final imagePath = product.imagePath;

    // Si la ruta empieza con 'assets/', es un recurso de la app.
    if (imagePath != null && imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    }
    // Si no, intentamos cargarlo como un archivo del dispositivo.
    else if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(File(imagePath), fit: BoxFit.cover);
    }
    // Como fallback, mostramos un ícono.
    return const Icon(Icons.fastfood, color: Colors.grey, size: 60);
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildProductImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    InkWell(
                      onTap: onAddToCart,
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF980101),
                        child: Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}