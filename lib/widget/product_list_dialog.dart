import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/models/product_model.dart';
import 'package:flutter_hamburgesas/widget/dialog_header.dart';

class ProductListDialog extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onEdit;
  final Function(Product) onArchive;

  const ProductListDialog({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogHeader(
              icon: Icons.fastfood_outlined,
              title: 'LISTA DE PRODUCTOS',
            ),
            const SizedBox(height: 20),
            const Divider(),
            if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text("No hay productos para mostrar.", style: TextStyle(fontSize: 16, color: Colors.black54)),
              )
            else
              _buildProductList(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CERRAR', style: TextStyle(color: Color(0xFF980101))),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final bool isArchived = product.idStatus == 2;

          return Card(
            elevation: 2,
            color: isArchived ? Colors.grey[200] : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: product.imagePath != null ? AssetImage(product.imagePath!) : null,
                child: product.imagePath == null ? const Icon(Icons.no_photography) : null,
              ),
              title: Text(
                product.productName,
                style: TextStyle(
                  decoration: isArchived ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () => onEdit(product),
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    icon: Icon(
                      isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
                      color: isArchived ? Colors.orange : Colors.red,
                    ),
                    onPressed: () => onArchive(product),
                    tooltip: isArchived ? 'Desarchivar' : 'Archivar',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}